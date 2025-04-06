// scene_manager.d
module scene_manager;

import std.exception;
import bindbc.sdl;


interface Scene {
    void handleEvent(SDL_Event event);
    void update();
    void render();
}

class SceneManager {
    Scene currentScene;
    Scene[string] scenes;

    void addScene(string id, Scene scene) {
        scenes[id] = scene;
    }

    void changeScene(string id) {
        currentScene = id in scenes ? scenes[id] : throw new Exception("Scene not found: " ~ id);
    }

    void handleEvent(SDL_Event event) 
    {
        currentScene.handleEvent(event);
    }

    void update() 
    {
        currentScene.update();
    }

    void render() 
    {
        currentScene.render();
    }
}