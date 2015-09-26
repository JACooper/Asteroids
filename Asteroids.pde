
/*
  Jesse Cooper
  IGME202.01
  Prof. Erin Cascioli
*/

//  --  Import Statements  --

import java.util.Random;

//  --  End of Import Statements  --

//  --  Global Variables  --

PlayerShip ps;
Bullet[] magazineHolder;
ArrayList<Debris> asteroidList;

AlienShip as;
Bullet ab;
int alienTimer;
boolean alienDied;

int playerScore;
boolean gameOver;
int level;
boolean newLevel;

Random rand;
Random randProper;

PFont myFont;
PFont myFont2;

int WINDOW_WIDTH = 700, WINDOW_HEIGHT = 640;

//  --  End of Global Variables  --



void setup()
{
  /*
  * Invalid in Processing 3
  * WINDOW_WIDTH = 700;
  * WINDOW_HEIGHT = 640;
  * size(WINDOW_WIDTH, WINDOW_HEIGHT, P2D);
  */
  size(700, 640, P2D);
  
  ps = new PlayerShip(width/2, height/2);  // Start player in center of screen
  magazineHolder = ps.getMagazine();
  
  as = null;              // Alien ship is created later
  ab = new Bullet(0, 0);  // Initialize alien bullet, so it can be used later
  alienTimer = 600;
  
  asteroidList = new ArrayList<Debris>();  // Start game with 3 asteroids
  asteroidList.add(new Debris(80, 80));
  asteroidList.add(new Debris(180, 480));
  asteroidList.add(new Debris(580, 340));
  
  gameOver = false;  // Endgame state
  
  level = 1;
  newLevel = false;  // Flag to tell the program when to make a new level
  
  myFont = loadFont("OCRAExtended-30.vlw");
  myFont2 = loadFont("OCRAExtended-10.vlw");
  
  rand = new Random();
  randProper = new Random(rand.nextLong());
}


void draw()
{
  background(0);
  
  // Display the player's score
  textFont(myFont2);
  text("Score: " + playerScore, width - 80, 10, 120, 40);
  
  if (newLevel == true)  // Up here so that the "level #" message can be displayed during the delay
  {
    newLevel = false;
    nextLevel();         // Create a new level
  }
  
  if (gameOver == false)  // If the game is still going
  {
    if (randProper.nextFloat() < 0.0008 && as == null)  // Spawn an alien, if there isn't already one and you get an appropriately small random number
    {
      as = new AlienShip(randProper.nextFloat() * 400, randProper.nextFloat() * 400);
    }
    
    Debris tempDebris;  // Holder variable
    
    if (as != null)     // If there *is* an alien
    {
      if (alienTimer > 0)   // And it hasn't timed out
      {
        alienDied = false;  // Flag value allowing as to be set to null without getting a null pointer exception - it'll make sense in a second
        
        // Do all the logistics
        as.move();
        as.displaySelf();
        as.shoot();
        ab = as.alienBullet;  // Assign ab to the stored alienBullet object
        ab.displaySelf();
        ab.move();
        
        if (as.colliding(ps) == true)  // Alien collided with player
        {
          ps.takeHit();
          alienDied = true;
        }
        else if (ab.colliding(ps) == true)  // Alien bullet hit player
        {
          ps.takeHit();
          ab.takeHit();
        }
        else
        {
          for (int l = 0; l < magazineHolder.length; ++l)
            if (as.colliding(magazineHolder[l]) == true)  // Alien was hit by player bullet
            {
              magazineHolder[l].takeHit();
              as.takeHit();
              alienDied = true;
            }
        }
        
        for (int k = 0; k < asteroidList.size(); ++k)
        {
          tempDebris = asteroidList.get(k);
          if (as.colliding(tempDebris) == true)  // Alien collided with asteroid
          {
            alienDied = true;
            tempDebris.takeHit();
            asteroidList.remove(k);
          }
        }
        
        if (alienDied == true)  // If any of the above conditions would have killed the alien, kill it now
          as = null;
      }
      else          // i.e. if the timer has run out
        as = null;
    }
    
    // Display and move the ship
    ps.displaySelf();
    ps.move();
    
    // Move & display all of the asteroids and check to see if they collided with the player
    for (int i = 0; i < asteroidList.size(); ++i)
    {
      tempDebris = asteroidList.get(i);
      tempDebris.move();
      tempDebris.displaySelf();
      if (ps.colliding(tempDebris) == true)
      {
        ps.takeHit();
        tempDebris.takeHit();
        asteroidList.remove(i);
      }
    }
    
    // Move & display all the player bullets and get to see if they hit anything
    for (int i = 0; i < magazineHolder.length; ++i)
    {
      magazineHolder[i].displaySelf();
      magazineHolder[i].move();
      for (int j = 0; j < asteroidList.size(); ++j)
      {
        tempDebris = asteroidList.get(j);
        if (magazineHolder[i].colliding(tempDebris) == true)
        {
          magazineHolder[i].takeHit();
          tempDebris.takeHit();
          asteroidList.remove(j);
        }
      }
      if (magazineHolder[i].colliding(ps) == true)  // Rather hard to test, but I have no reason to believe it *doesn't* work, so. . .
        ps.takeHit();
    }
  }
    
  if (gameOver == true)  // If the player died, display the game over screen
  {
    textFont(myFont);
    text("Game Over", width / 2 - 80, height / 2 - 20, 320, 40);
  }
  
  if (asteroidList.size() == 0)  // If you're out of asteroids, start a new level
  {
    level++;
    background(0);
    ps.displaySelf();
    textFont(myFont);
    text("Level " + level, width / 2 - 90, height / 2 - 20, 320, 40);
    newLevel = true;
  }
}


// Function spawns new debris for next level
void nextLevel()
{
  int m = millis();
  while(m + 1000 > millis()) { } // Do nothing. . .I know, I know, I hate it too - Delays so that the "level #" message can be read
  Random rnd = new Random();
  Random rndProper = new Random(rnd.nextLong());
  for (int i = 0; i < 2 + level; ++i)
    asteroidList.add(new Debris(rndProper.nextInt(width), rndProper.nextInt(height)));
}


void keyPressed()
{
  switch(keyCode)
  {
    case RIGHT:
      ps.setTurningRight(true);
      break;
    case LEFT:
      ps.setTurningLeft(true);
      break;
    case UP:
      ps.setAccelerating(true);
      break;
    case DOWN:          // Hyperdrive. Self-explanatory (sends the player a random on-screen location)
      ps.hyperdrive();
      break;
  }
  if (key == ' ')
  {
    ps.shoot();
  }
}


void keyReleased()
{
  switch(keyCode)
  {
    case RIGHT:
      ps.setTurningRight(false);
      break;
    case LEFT:
      ps.setTurningLeft(false);
      break;
    case UP:
      ps.setAccelerating(false);
      break;
  }
}