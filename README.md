A project made for an interactive media class. Remake of the classic Asteroids arcade game.

NOTE: This program was developed in Processing, a specialized Java-based development tool, and requires it to run. You can download Processing for free here: https://processing.org/download/ (This project was initially developed for Processing 2, but has been updated to work with the latest version, Processing 3.)


User Functionality: 
	-	Users can use the up arrow key to accelerate, the left and right arrow keys to turn, the spacebar to shoot, and the down arrow key to activate hyperdrive and warp to a random screen position.
	-	Player can collide with aliens, asteroids, alien bullets, and their own bullets – any collision will destroy the player and present them with the game over screen.
	-	When the player destroys all asteroids on screen, they will advance to the next level, at which point more asteroids will be created (one more than the previous level had). This will repeat until the player dies.

“Above & Beyond” Features: 
	-	Ship movement has drift and gradual (while limited for gameplay purposes) acceleration, very similar to the base game.
	-	In addition to the asteroids, there are alien ships which randomly spawn and appear on screen for a limited time. Aliens can shoot the player (and be shot), as well as collide with asteroids, correctly damaging them both.
	-	There are infinite levels, each one reached by destroying all asteroids in the previous level. 
	-	The player’s current score is kept track of on the top right part of the screen (scores are, shamefully, not saved).
	-	Asteroids break multiple times, each time with adjusted point values. “Child” asteroids will never overlap each other when they are created.
	-	The player ship gives visual feedback when accelerating.