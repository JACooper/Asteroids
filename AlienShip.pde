
/*
  Jesse Cooper
  IGME202.01
  Prof. Erin Cascioli
*/

//  --  Import Statements  --

import java.util.Random;

//  --  End of Import Statements  --

public class AlienShip extends Ship
{
  //  --  Instance Variables  --
 
  private int pointValue;
  public Bullet alienBullet;    // Public so Asteroids can access it
 
  //  --  End of Instance Variables  -- 
  
  
  //  --  Constructors  --
  
  public AlienShip(float x, float y)
  {
    super(x, y);
    pointValue = 1000;  // Aliens give 1000 points
    
    // Give the alien a random scale (and appropriate hitbox. . .circle. Shape.)
    Random rnd = new Random();
    Random rndProper = new Random(rnd.nextLong());
    
    float scaleFactor = rndProper.nextInt(2) + 1;
    boundingCircleRadius = 9 * scaleFactor;
    objShape = createShape();
    startShaping();
    objShape.scale(scaleFactor);
    
    // Give it random direction & a speed of 2
    direction = new PVector(0, 0);
    PVector.fromAngle(0, direction);
    direction.rotate(radians(rndProper.nextFloat() * (360 * rndProper.nextFloat())));
    direction.normalize();
    speed = 2;
    velocity = PVector.mult(direction, speed);
    alienTimer = 600;
    
    alienBullet = new Bullet(0, 0);
  }
  
  //  --  End of Constructors  --
  
  
  //  --  Methods  --
  
  public void shoot()
  {
    Random rnd = new Random();
    Random rndProper = new Random(rnd.nextLong());
    
    if (rndProper.nextFloat() < 0.05 && alienBullet.fired == false)  // If it hasn't fired and the number is sufficiently low enough (simulates a timer, but much easier to implement), fire
    {
      PVector tempDir = new PVector(0, 0);
      PVector.fromAngle(0, tempDir);
      tempDir.rotate(radians(rndProper.nextFloat() * (360 * rndProper.nextFloat())));
      tempDir.normalize();
      alienBullet.fire(PVector.add(PVector.mult(direction, boundingCircleRadius), position), tempDir);
    }
  }
  
  public void takeHit()
  { playerScore += pointValue; }  // Give the player points
  
  public void startShaping()
  {
    objShape.beginShape();
      objShape.stroke(150, 255, 150, 230);    // Make it slightly green, so it can be easily distinguished from the asteroids
      objShape.vertex(10, 0);
      objShape.vertex(5, 6);
      objShape.vertex(-5, 6);
      objShape.vertex(-10, 0);
      objShape.vertex(-7, -4);
      objShape.vertex(-3, -5);
      objShape.vertex(3, -5);
      objShape.vertex(7, -4);
    objShape.endShape(CLOSE);
    objShape.setFill(0);
    
    //boundingCircle = createShape(ELLIPSE, 0, 0, boundingCircleRadius, boundingCircleRadius, RADIUS);    // Invalid in Processing 3
    ellipseMode(RADIUS);
    boundingCircle = createShape(ELLIPSE, 0, 0, boundingCircleRadius, boundingCircleRadius);
    boundingCircle.setFill(color(255, 255, 255, 50));
  }
  
  public boolean colliding(SpaceObject otherObj)
  {
    boolean resultFlag = false;
    
    if (otherObj.getRadius() + this.boundingCircleRadius > PVector.dist(otherObj.getPosition(), position))
      resultFlag = true;
    
    return resultFlag; 
  }
  
  public void displaySelf()  // Note that aliens intentionally do not rotate
  {
    pushMatrix();
      translate(this.position.x, this.position.y);
      shape(objShape);
    popMatrix();
  }
  
  public void move()
  {
    alienTimer--;  // Run down the alien's onscreen time a little bit each time
    position.add(velocity);
    
    // Wrapping
    if(position.x > width)
      position.x = 0;
    if(position.x < 0)
      position.x = width;
    if(position.y > height)
      position.y = 0;
    if(position.y < 0)
      position.y = height;
  }
  
  //  --  End of Methods  --
  
}