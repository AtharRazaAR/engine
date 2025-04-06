module render_text;

import bindbc.sdl;
import std.exception;
import std.string;

class RenderText {
    void render(
        string text,
        int x,
        int y,
        SDL_Renderer* renderer,
        SDL_Color color,
        string fontPath,
        int fontSize
    ) {
        // Load font at the specified size
        TTF_Font* font = TTF_OpenFont(fontPath.ptr, fontSize);
        enforce(font !is null, "Failed to load font: " ~ fromStringz(TTF_GetError()));

        // Create text surface
        SDL_Surface* surface = TTF_RenderText_Blended(font, text.ptr, color);
        enforce(surface !is null, "Failed to create text surface: " ~ fromStringz(TTF_GetError()));

        // Create texture from surface
        SDL_Texture* texture = SDL_CreateTextureFromSurface(renderer, surface);
        enforce(texture !is null, "Failed to create texture: " ~ fromStringz(SDL_GetError()));

        // Get text width and height
        SDL_Rect dstRect = {x, y, surface.w, surface.h};

        // Render the texture
        SDL_RenderCopy(renderer, texture, null, &dstRect);

        // Clean up
        SDL_FreeSurface(surface);
        SDL_DestroyTexture(texture);
        TTF_CloseFont(font);
    }
}
