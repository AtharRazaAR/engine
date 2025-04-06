module game_scene;

import std.stdio;
import std.file;
import std.json;
import std.array;
import sdl_abstraction;
import scene_manager;
import game_object;
import bindbc.sdl;
import render_text;
import bricks, paddle, ball;
import std.algorithm;
import std.datetime;
import std.conv;

class GameScene : Scene {
    SDL_Renderer* renderer;
    SceneManager* sceneManager;
    RenderText textRenderer;
    Brick[] bricks;
    Paddle paddle;
    Ball ball;
    long startTime;

    int score;         // Current score
    int highScore;     // High score

    this(SDL_Renderer* renderer, SceneManager* sceneManager) {
        this.renderer = renderer;
        this.sceneManager = sceneManager;
        this.textRenderer = new RenderText();
        this.bricks = [];

        // Initialize paddle and ball
        this.paddle = new Paddle(350, 580, 100, 20);
        this.ball = new Ball(400, 300, 10, 10, 10); // Lower initial speed

        this.score = 0;
        this.highScore = loadHighScore();

        // Set initial time
        this.startTime = Clock.currTime.toUnixTime;

        // Load bricks from JSON
        loadBricks("./bricks.json");
    }

    void loadBricks(string filePath) {
        if (!filePath.exists) {
            writeln("Error: bricks.json file not found.");
            return;
        }

        auto jsonData = parseJSON(readText(filePath)).array;
        foreach (entry; jsonData) {
            auto obj = entry.object;
            float x = obj["x"].get!float;
            float y = obj["y"].get!float;
            string color = obj["color"].get!string;
            int strength = obj["strength"].get!int;

            bricks ~= new Brick(x, y, 50, 20, strength);
        }
    }

    int loadHighScore() {
        if (!exists("score.json")) {
            return 0; // Default high score if file doesn't exist
        }

        auto jsonData = parseJSON(readText("score.json"));
        return jsonData["highScore"].get!int;
    }

    void saveHighScore() 
    {
        JSONValue jsonData;
        jsonData["highScore"] = JSONValue(highScore);
        std.file.write("score.json", jsonData.toString);
    }


    override void handleEvent(SDL_Event event) 
    {
        ubyte* state = SDL_GetKeyboardState(null);
        if (state[SDL_SCANCODE_A] || state[SDL_SCANCODE_LEFT])
        {
            paddle.velocity = -250;
        }
        else if (state[SDL_SCANCODE_D] || state[SDL_SCANCODE_RIGHT])
        {
            paddle.velocity = 250;
        }
        else
            paddle.velocity = 0;

        if (state[SDL_SCANCODE_B])
        {
            saveHighScore();
            sceneManager.changeScene("home");
        }


        // if (event.type == SDL_KEYDOWN) 
        // {
        //     writeln("key down!");
        //     switch (event.key.keysym.sym) {
        //         case SDLK_b: // Go back to HomeScene
        //             saveHighScore();
        //             sceneManager.changeScene("home");
        //             break;
        //         case SDLK_LEFT:
        //             paddle.velocity = -200; // Move left
        //             break;
        //         case SDLK_RIGHT:
        //             paddle.velocity = 200; // Move right
        //             break;
        //         default:
        //             break;
        //     }
        // } 
        // else if (event.type == SDL_KEYUP) 
        // {
        //     switch (event.key.keysym.sym) 
        //     {
        //         case SDLK_LEFT:
        //         case SDLK_RIGHT:
        //             paddle.velocity = 0; // Stop moving
        //             break;
        //         default:
        //             break;
        //     }
        // }
    }

    override void update() 
    {
        // Update paddle and ball
        paddle.update();
        ball.update(paddle, bricks, this);

        // Remove bricks with 0 strength
        bricks = bricks.filter!(b => b.strength > 0).array;

        if (bricks.length == 0) {
            saveHighScore(); // Save high score before transitioning
            sceneManager.changeScene("gameWon");
            return;
        }
        
        // Check if the ball goes below the screen
        if (ball.y > 600) {
            saveHighScore();
            sceneManager.changeScene("gameOver");
        }

        // Increment ball speed cap every minute
        long currentTime = Clock.currTime.toUnixTime;
        long elapsedTime = currentTime - startTime;

        if (elapsedTime > 0 && elapsedTime % 60 == 0) {
            ball.speedCap = min(ball.speedCap + 5, 20); // Increment by 5, max 20
        }
    }

    override void render() {
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255); // Black background
        SDL_RenderClear(renderer);

        // Render bricks
        foreach (brick; bricks) {
            brick.render(renderer);
        }

        // Render paddle and ball
        paddle.render(renderer);
        ball.render(renderer);

        SDL_Color green = {0, 255, 0, 255};
        textRenderer.render("Score  " ~ to!string(score), 600, 10, renderer, green, "./assets/ARCADECLASSIC.ttf", 24);
        textRenderer.render("High Score  " ~ to!string(highScore), 600, 40, renderer, green, "./assets/ARCADECLASSIC.ttf", 24);

        textRenderer.render("Press B to return to Home", 50, 550, renderer, green, "./assets/ARCADECLASSIC.ttf", 24);
    }

    void increaseScore(int value) {
        score += value;

        // Update high score if needed
        if (score > highScore) {
            highScore = score;
        }
    }

    // Reset the game to its initial state
    void reset() {
        bricks.length = 0; // Clear existing bricks
        loadBricks("./bricks.json"); // Reload bricks

        // Reset ball and paddle
        ball.x = 400;
        ball.y = 300;
        ball.velocityX = 10;
        ball.velocityY = 10;

        paddle.x = 350;
        paddle.velocity = 0;

        startTime = Clock.currTime.toUnixTime; // Reset timer

        score = 0;
        highScore = loadHighScore();
    }

}
