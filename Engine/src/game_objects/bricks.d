module bricks;

import game_object;
import bindbc.sdl;
import std.stdio;
import std.conv;

class Brick : GameObject {
    int strength;
    SDL_Color color;
    long lastHitTime; // Track last hit time

    this(float x, float y, float width, float height, int strength) {
        super(x, y, width, height);
        this.strength = strength;
        this.color = getColorByStrength(strength);
        this.lastHitTime = 0;
        writeln("Brick created at (", x, ", ", y, ") with strength: ", strength, " and color: (", color.r, ", ", color.g, ", ", color.b, ")");
    }


   SDL_Color getColorByStrength(int strength) {
        switch (strength) {
            case 1: return SDL_Color(0, 0, 255, 255); // Blue
            case 2: return SDL_Color(255, 0, 0, 255); // Red
            case 3: return SDL_Color(0, 255, 0, 255); // Green
            default: return SDL_Color(128, 128, 128, 255); // Default gray
        }
    }




    void updateColor() 
    {
        


        this.color = getColorByStrength(this.strength);
    }

    override void render(SDL_Renderer* renderer) {
        writeln("Rendering brick at (", x, ", ", y, ") with color: (", color.r, ", ", color.g, ", ", color.b, ")");
        SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
        SDL_Rect rect = {cast(int) x, cast(int) y, cast(int) width, cast(int) height};
        auto result = SDL_RenderFillRect(renderer, &rect);
        if (result != 0) {
            writeln("Failed to render brick at (", x, ", ", y, "): ", to!string(SDL_GetError()));
        }
    }

}
