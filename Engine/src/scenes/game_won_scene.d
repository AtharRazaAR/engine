module game_won_scene;

import sdl_abstraction;
import scene_manager;
import render_text;
import bindbc.sdl;

class GameWonScene : Scene {
    SDL_Renderer* renderer;
    SceneManager* sceneManager;
    RenderText textRenderer;

    this(SDL_Renderer* renderer, SceneManager* sceneManager) {
        this.renderer = renderer;
        this.sceneManager = sceneManager;
        this.textRenderer = new RenderText();
    }

    override void handleEvent(SDL_Event event) {
        if (event.type == SDL_KEYDOWN) {
            switch (event.key.keysym.sym) {
                case SDLK_b: // Go back to HomeScene
                    sceneManager.changeScene("home");
                    break;
                default:
                    break;
            }
        }
    }

    override void update() {}

    override void render() {
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255); // Black background
        SDL_RenderClear(renderer);

        SDL_Color white = {255, 255, 255, 255};
        textRenderer.render("Congratulations! You Won!", 150, 200, renderer, white, "./assets/ARCADECLASSIC.ttf", 48);
        textRenderer.render("Press B to return to Home", 200, 300, renderer, white, "./assets/ARCADECLASSIC.ttf", 24);
    }
}
