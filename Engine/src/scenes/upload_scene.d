module upload_scene;

import std.stdio;
import sdl_abstraction;
import scene_manager;
import bindbc.sdl;
import std.process;
import std.exception;
import render_text;

class UploadScene : Scene {
    SDL_Renderer* renderer;
    SceneManager* sceneManager;
    RenderText textRenderer;
    string statusMessage;

    this(SDL_Renderer* renderer, SceneManager* sceneManager) {
        this.renderer = renderer;
        this.sceneManager = sceneManager;
        this.textRenderer = new RenderText();
        this.statusMessage = "Upload a new bricks.json file.";
    }

    override void handleEvent(SDL_Event event) {
        if (event.type == SDL_KEYDOWN) {
            switch (event.key.keysym.sym) {
                case SDLK_b: // Go back to HomeScene
                    sceneManager.changeScene("home");
                    break;
                case SDLK_u: // Trigger Python upload script
                    writeln("Launching upload script...");
                    auto process = spawnProcess(["python3", "./src/gui/upload_bricks.py"]);
                    process.wait(); // Wait for Python script to finish

                    // Update status based on script completion
                    this.statusMessage = "bricks.json replaced successfully!";
                    break;
                default:
                    writeln("Unhandled key press in UploadScene.");
                    break;
            }
        }
    }

    override void update() {}

    override void render() {
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255); // Black background
        SDL_RenderClear(renderer);

        SDL_Color white = {255, 255, 255, 255}; // White text

        // Render status and navigation hint
        textRenderer.render("Upload Scene", 200, 100, renderer, white, "./assets/ARCADECLASSIC.ttf", 48);
        textRenderer.render(statusMessage, 100, 200, renderer, white, "./assets/ARCADECLASSIC.ttf", 24);
        textRenderer.render("Press U to upload bricks.json", 100, 300, renderer, white, "./assets/ARCADECLASSIC.ttf", 24);
        textRenderer.render("Press B to return to the Home Screen", 100, 350, renderer, white, "./assets/ARCADECLASSIC.ttf", 24);
    }
}
