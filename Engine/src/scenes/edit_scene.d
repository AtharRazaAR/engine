module edit_scene;

import std.stdio;
import sdl_abstraction;
import scene_manager;
import bindbc.sdl;
import std.exception;
import render_text;

class EditScene : Scene {
    SDL_Renderer* renderer;
    SceneManager* sceneManager;
    RenderText textRenderer;
    string message;

    this(SDL_Renderer* renderer, SceneManager* sceneManager, string message) {
        this.renderer = renderer;
        this.sceneManager = sceneManager;
        this.textRenderer = new RenderText();
        this.message = message;
    }

    override void handleEvent(SDL_Event event) {
        if (event.type == SDL_KEYDOWN) {
            switch (event.key.keysym.sym) {
                case SDLK_b: // Go back to HomeScene
                    sceneManager.changeScene("home");
                    break;
                default:
                    sceneManager.changeScene("home");
                    break;
            }
        }
    }

    override void update() {}

    override void render() {
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255); // Black background
        SDL_RenderClear(renderer);

        SDL_Color yellow = {255, 255, 0, 255}; // White text

        // Use textRenderer to render the message and navigation hint
        textRenderer.render(message, 200, 250, renderer, yellow, "./assets/ARCADECLASSIC.ttf", 32);
        textRenderer.render("Press    B    to    return    to    the    Home    Screen", 100, 350, renderer, yellow, "./assets/ARCADECLASSIC.ttf", 24);
    }
}
