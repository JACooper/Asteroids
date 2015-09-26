
/*
  Jesse Cooper
  IGME202.01
  Prof. Erin Cascioli
*/

//  --  Import Statements  --

import java.util.Random;

//  --  End of Import Statements  --

public class PlayerShip extends Ship
{
  //  --  Instance Variables  --
  
  private PShape thruster;
  private Bullet[] magazine;
  protected PVector acceleration;
  protected float rotationAngle;
  protected boolean accelerating, turningRight, turningLeft;  // Movement control vars
  
  //  --  End of Instance Variables  -- 
  
  
  //  --  Constructors  --
  
  public PlayerShip(float x, float y)
  {
    super(x, y);
    acceleration = new PVector(0, 0);
    accelerating = false;
    turningRight = false;
    turningLeft = false;
    magazine = new Bullet[4];
    for (int i = 0; i < magazine.length; ++i)
      magazine[i] = new Bullet(this.position.x, this.position.y);
    
    objShape = createShape();
    thruster = createShape();
    startShaping();
  }
 
  //  --  End of Constructors  --
  
  
  //  --  Methods  --
  
    //  --  Setters & Getters  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
  
      //  --  Accelerating Methods  --
      
        public void setAccelerating(boolean flag)
        { accelerating = flag; }
        
        public boolean getAccelerating()
        { return accelerating; }
        
      //  --  End of Accelerating Methods  --
      
      
      //  --  Turning Right Methods  --
      
        public void setTurningRight(boolean flag)
        { turningRight = flag; }
        
        public boolean getTurningRight()
        { return turningRight; }
        
      //  --  End of Turning Right Methods  --
  
  
      //  --  Turning Left Methods  --
      
        public void setTurningLeft(boolean flag)
        { turningLeft = flag; }
        
        public boolean getTurningLeft()
        { return turningLeft; }
        
        public Bullet[] getMagazine()
        { return magazine; }
        
      //  --  End of Turning Left Methods  --
  
    //  -- End of Setters & Getters  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
  
  public void shoot()
  {
    boolean firedBullet = false;
    
    for (int i = 0; i < magazine.length && firedBullet == false; ++i)    // Only shoot if you have not already, so you don't fire all 4 bullets at once
      if (magazine[i].fired == false)
      {
        magazine[i].fire(PVector.add(PVector.mult(direction, 10), position), direction);  // Slightly offset the bullets so they don't start in the middle of the ship shape
        firedBullet = true;
      }
  }
  
  public void startShaping()
  {
    objShape.beginShape();
      objShape.stroke(255, 255, 255, 230);
      objShape.vertex(10, 0);
      objShape.vertex(-9, 6);
      objShape.vertex(-6, 1);
      objShape.vertex(-6, -1);
      objShape.vertex(-9, -6);
    objShape.endShape(CLOSE);
    objShape.setFill(0);
    
    // The little flame that appears on the back of the ship
    thruster.beginShape();
      thruster.stroke(255, 255, 255, 230);
      thruster.vertex(-13, 2);
      thruster.vertex(-11, 1);
      thruster.vertex(-13, 0);
      thruster.vertex(-11, -1);
      thruster.vertex(-13, -2);
      thruster.vertex(-9, -2);
      thruster.vertex(-9, 2);
    thruster.endShape(CLOSE);
    thruster.setFill(0);
    
    boundingCircleRadius = 9;
    
    //boundingCircle = createShape(ELLIPSE, 0, 0, boundingCircleRadius, boundingCircleRadius, RADIUS);    // Invalid in Processing 3
    ellipseMode(RADIUS);
    boundingCircle = createShape(ELLIPSE, 0, 0, boundingCircleRadius, boundingCircleRadius);
    boundingCircle.setFill(color(255, 255, 255, 50));
  }
  
  public void takeHit()
  {
    gameOver = true;
  }
  
  public boolean colliding(SpaceObject otherObj)
  {
    boolean resultFlag = false;
    
    if (otherObj.getRadius() + this.boundingCircleRadius > PVector.dist(otherObj.getPosition(), position))
      resultFlag = true;
    
    return resultFlag; 
  }
  
  public void displaySelf()
  {
    pushMatrix();
      translate(this.position.x, this.position.y);
      rotate(direction.heading());
      shape(objShape);
      if (accelerating == true)  // If the player is accelerating, display the thruster
        shape(thruster);
    popMatrix();
  }
  
  public void move()
  {
    // Numbers may seem a little random, but they seemed to be the one's that worked best
    if (turningRight == true)
      direction.rotate(radians(3.7)); 
    if (turningLeft == true)
      direction.rotate(radians(-3.7)); 
    direction.normalize();
    
    // Speed is basically what tapers acceleration - accelRate would be more accurate, but it's gone through a lot of iterations and I didn't want to break anything by changing them
    if (accelerating == true)
    {
      if (acceleration.mag() == 0)  // Give them a quick boost so they can quickly move from rest
        speed += 0.1;
      else
        speed += 0.001;
    }
    else
    {
      if (speed > 0)
        speed -= 0.03;
      if (speed < 0)
        speed = 0;
    }
    
    PVector.mult(direction, speed, acceleration);
    acceleration.limit(10);
    
    velocity.add(acceleration);
    
    velocity.limit(10);
    if (velocity.mag() < 0.05)
      velocity.mult(0);
    else
      velocity.mult(0.99);
    
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
  
  // Transport the player to some random position and reset their speed & velocity
  public void hyperdrive()
  {
    Random rnd = new Random();
    Random rndProper = new Random(rnd.nextLong());
    position = new PVector((rndProper.nextFloat() * 10) + (700 * rndProper.nextFloat()) + 10, (rndProper.nextFloat() * 10) + (640 * rndProper.nextFloat()) + 10);
    velocity.mult(0);
    acceleration.mult(0);
  }
  
  //  --  End of Methods  --
  
  
}