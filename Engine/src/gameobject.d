// game_object.d
module game_object;
import bindbc.sdl;
import sdl_abstraction;

class GameObject {
    float x, y;
    float width, height;

    this(float x, float y, float width, float height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    void update() {}
    void render(SDL_Renderer* renderer) {}
}