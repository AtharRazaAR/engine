module home_scene;

import std.stdio;
import std.process;
import std.string;
import std.exception;
import sdl_abstraction;
import scene_manager;
import bindbc.sdl;
import render_text;
import std.conv;
import edit_scene;
import game_scene;


class HomeScene : Scene {
    SDL_Renderer* renderer;
    SceneManager* sceneManager;
    RenderText textRenderer;
    
    TTF_Font* font;

    this(SDL_Renderer* renderer, SceneManager* sceneManager) {
        this.renderer = renderer;
        this.sceneManager = sceneManager;
        this.textRenderer = new RenderText();

        if (SDL_Init(SDL_INIT_VIDEO) != 0) {
            writeln("Error initializing SDL: ", fromStringz(SDL_GetError()));
            return;
        }

        // Initialize SDL_ttf
        enforce(TTF_Init() == 0, "Failed to initialize SDL_ttf: " ~ fromStringz(TTF_GetError()));

        // Load local font
        font = TTF_OpenFont("./assets/ARCADECLASSIC.ttf", 24); // Replace with your font path
        enforce(font !is null, "Failed to load font: " ~ fromStringz(TTF_GetError()));
    }

    ~this() {
        if (font !is null) {
            TTF_CloseFont(font);
        }
        TTF_Quit();
    }

    override void handleEvent(SDL_Event event) {
        if (event.type == SDL_KEYDOWN) {
            switch (event.key.keysym.sym) {
                case SDLK_p:
                    auto gameScene = cast(GameScene) sceneManager.scenes["game"];
                    if (gameScene !is null) {
                        gameScene.reset();
                    }
                    sceneManager.changeScene("game");
                    break;

                case SDLK_e:
                    writeln("Opening BrickEditor...");
                    import std.process;
                    auto process = spawnProcess(["python3", "./src/gui/brick_editor.py"]);

                    // Switch to EditScene while Python process is running
                    sceneManager.changeScene("edit");
                    process.wait(); // Wait for Python process to complete

                    // Update EditScene message
                    auto editScene = cast(EditScene) sceneManager.scenes["edit"];
                    if (editScene !is null) {
                        editScene.message = "Edited bricks.json!";
                    }
                    break;
                case SDLK_u:
                    sceneManager.changeScene("upload");
                    break;
                default:
                    writeln("Unhandled key press in HomeScene.");
                    break;
            }
        }
    }


    override void update() {}

    override void render() {
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255); // Black background
        SDL_RenderClear(renderer);

        // Define colors
        SDL_Color titleColor = {255, 255, 0, 255}; // Yellow for title
        SDL_Color optionColor = {255, 255, 255, 255}; // White for options
        SDL_Color highlightColor = {0, 255, 0, 255}; // Green for instructions

        // Render "Brickbreaker!" in a larger font
        textRenderer.render("Brickbreaker!", 225, 100, renderer, titleColor, "./assets/ARCADECLASSIC.ttf", 48);

        // Render instructions in default size and colors
        textRenderer.render("Options", 50, 200, renderer, optionColor, "./assets/ARCADECLASSIC.ttf", 32);
        textRenderer.render("Press          P        to    play", 50, 250, renderer, highlightColor, "./assets/ARCADECLASSIC.ttf", 24);
        textRenderer.render("Press          E        to    enter    GUI    editor", 50, 300, renderer, highlightColor, "./assets/ARCADECLASSIC.ttf", 24);
        textRenderer.render("Press          U        to    upload    custom    file", 50, 350, renderer, highlightColor, "./assets/ARCADECLASSIC.ttf", 24);
    }
}
