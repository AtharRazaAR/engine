module paddle;

import game_object;
import bindbc.sdl;

class Paddle : GameObject {
    float velocity;

    this(float x, float y, float width, float height) 
    {
        super(x, y, width, height);
        this.velocity = 0;
    }

    override void update() 
    {
        x += velocity / 30;

        // Constrain paddle within screen bounds
        if (x < 0) x = 0;
        if (x + width > 800) x = 800 - width; // Assuming screen width of 800
    }

    override void render(SDL_Renderer* renderer) {
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255); // White paddle
        SDL_Rect rect = {cast(int) x, cast(int) y, cast(int) width, cast(int) height};
        SDL_RenderFillRect(renderer, &rect);
    }
}
