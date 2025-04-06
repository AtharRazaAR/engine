// main.d
module main;

import std.stdio;
import std.file;
import std.json;
import std.algorithm;
import std.array;
import sdl_abstraction;
import scene_manager;
import home_scene;
import bindbc.sdl;
import std.conv;
import edit_scene;
import upload_scene;
import game_scene;
import game_over_scene;
import std.exception;
import game_won_scene;


void main() 
{
    SDL_Window* window;
    SDL_Renderer* renderer;

    if (SDL_Init(SDL_INIT_VIDEO) != 0) 
    {
        writeln("Error initializing SDL: ", SDL_GetError());
        return;
    }
    
    loadSDLTTF();
    TTF_Init();
    window = SDL_CreateWindow("Brick Breaker", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, SDL_WINDOW_SHOWN);
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

    SceneManager sceneManager = new SceneManager();

    HomeScene homeScene = new HomeScene(renderer, &sceneManager);
    sceneManager.addScene("home", homeScene);
    sceneManager.changeScene("home");

    EditScene editScene = new EditScene(renderer, &sceneManager, "Editing bricks.json...");
    sceneManager.addScene("edit", editScene);

    UploadScene uploadScene = new UploadScene(renderer, &sceneManager);
    sceneManager.addScene("upload", uploadScene);

    GameScene gameScene = new GameScene(renderer, &sceneManager);
    sceneManager.addScene("game", gameScene);

    GameOverScene gameOverScene = new GameOverScene(renderer, &sceneManager);
    sceneManager.addScene("gameOver", gameOverScene);

    GameWonScene gameWonScene = new GameWonScene(renderer, &sceneManager);
    sceneManager.addScene("gameWon", gameWonScene);

    SDL_Event event;
    bool running = true;

    //time management
    int targetFPS = 60;
    int frameDelay = 1000 / targetFPS; // 16 ms per frame
    uint lastFrameTime = 0;
    uint currentFrameTime;
    int frameTime;


    while (running) 
    {
        currentFrameTime = SDL_GetTicks();
        frameTime = currentFrameTime - lastFrameTime;

        //handle events
        while (SDL_PollEvent(&event) != 0) 
        {
            if (event.type == SDL_QUIT) 
            {
                running = false;
            } 
            else 
            {
                sceneManager.handleEvent(event);
            }
        }

        //update and render
        sceneManager.update();
        sceneManager.render();

        SDL_RenderPresent(renderer);

        // Calculate delay to cap the frame rate
        if (frameTime < frameDelay) 
        {
            SDL_Delay(frameDelay - frameTime);
        }

        lastFrameTime = currentFrameTime;
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    TTF_Quit(); 
    unloadSDLTTF();
    SDL_Quit();
}