module ball;

import game_object;
import paddle;
import bricks;
import std.algorithm;
import bindbc.sdl;
import std.stdio;
import std.math;
import std.datetime;
import game_scene;

import bindbc.sdl.mixer;

class Ball : GameObject {
    float velocityX, velocityY;
    float speedCap;

    this(float x, float y, float size, float velocityX, float velocityY) 
    {
        super(x, y, size, size);
        this.velocityX = velocityX;
        this.velocityY = velocityY * 2;
        this.speedCap = 50; // Cap the ball's maximum speed



    }

    void update(Paddle paddle, Brick[] bricks, GameScene gameScene) {
        x += (velocityX / 4);
        y += (velocityY / 3);

        if (x <= 0 || x + width >= 800) 
        {
            velocityX = -velocityX; // wall bounce
            x = clamp(x, 0, 800 - width); // prevent sticking
        }

        if (y <= 0) 
        {
            velocityY = -velocityY; // roof bounce
            y = 0;
        }

        // Check collision with paddle
        if (y + height >= paddle.y &&
            x + width >= paddle.x &&
            x <= paddle.x + paddle.width) 
            {
            velocityY = -velocityY;

            // Adjust angle based on paddle velocity
            float paddleEffect = paddle.velocity * 0.2;
            velocityX += paddleEffect;

            // Prevent the ball from getting stuck in the paddle
            y = paddle.y - height;

            //increment difficulty
            speedCap+=3;
        }

        // Check collision with bricks
        foreach (brick; bricks) {
            if (x + width >= brick.x &&
                x <= brick.x + brick.width &&
                y + height >= brick.y &&
                y <= brick.y + brick.height) {

                // Check hit buffer (0.25 seconds)
                long currentTime = Clock.currTime.toUnixTime;
                if (currentTime - brick.lastHitTime > 0.25) {
                    // Determine collision side
                    float ballCenterX = x + width / 2;
                    float ballCenterY = y + height / 2;
                    float brickCenterX = brick.x + brick.width / 2;
                    float brickCenterY = brick.y + brick.height / 2;

                    float dx = ballCenterX - brickCenterX;
                    float dy = ballCenterY - brickCenterY;

                    if (abs(dx) > abs(dy)) {
                        // Horizontal collision: reverse X velocity
                        velocityX = -velocityX;
                    } else {
                        // Vertical collision: reverse Y velocity
                        velocityY = -velocityY;
                    }

                    brick.strength--; // Reduce brick strength
                    brick.updateColor(); // Update brick color
                    brick.lastHitTime = currentTime; // Update hit time
                    gameScene.increaseScore(10); // Increase score by 10
                }

                break;
            }
        }


        // Normalize velocity to avoid speed spikes
        normalizeVelocity();

        // Handle falling off the screen
        if (y > 600) {
        //     writeln("Game Over!");
             //resetBall();
        }
    }

   void normalizeVelocity() {
        float magnitude = sqrt(velocityX * velocityX + velocityY * velocityY);
        if (magnitude > speedCap) {
            float scale = speedCap / magnitude;
            velocityX *= scale;
            velocityY *= scale;
        }
        if (magnitude < 5) { // Avoid the ball moving too slowly
            velocityX = velocityX > 0 ? 5 : -5;
            velocityY = velocityY > 0 ? 5 : -5;
        }
    }


    void resetBall() {
        x = 400; // Reset to center
        y = 300;
        velocityX = 100; // Reset initial velocity
        velocityY = -100;
    }

    override void render(SDL_Renderer* renderer) {
        SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255); // Red ball
        SDL_Rect rect = {cast(int) x, cast(int) y, cast(int) width, cast(int) height};
        SDL_RenderFillRect(renderer, &rect);
    }
}
