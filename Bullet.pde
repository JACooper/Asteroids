
/*
  Jesse Cooper
  IGME202.01
  Prof. Erin Cascioli
*/

public class Bullet extends SpaceObject
{
  //  --  Instance Variables  --
  
  private boolean fired;  // Essentially an "active" flag
  private int distance;   // How long the bullet stays active
 
  //  --  End of Instance Variables  -- 
  
  
  //  --  Constructors  --
  
  public Bullet(float x, float y)
  {
    super(x, y);
    fired = false;
    distance = 0;
    startShaping();
  }
  
  //  --  End of Constructors  --
  
  
  //  --  Methods  --
  
  public void fire(PVector firePosition, PVector fireDirection)
  {
    fired = true;
    position = firePosition;
    speed = 11;  // Make it slightly faster than the ship itself
    direction = fireDirection;
    velocity = PVector.mult(direction, speed);
  }
  
  public void takeHit()
  {
    fired = false;
  }
  
  public void startShaping()
  {
    boundingCircleRadius = 2;
    
    //objShape = createShape(ELLIPSE, 0, 0, boundingCircleRadius, boundingCircleRadius, RADIUS);    // Invalid in Processing 3
    ellipseMode(RADIUS);
    objShape = createShape(ELLIPSE, 0, 0, boundingCircleRadius, boundingCircleRadius);
    objShape.setFill(color(255, 255, 255, 230));
  }
  
  public boolean colliding(SpaceObject otherObj)
  {
    boolean resultFlag = false;
    
    if (fired == true)  // Only check for collisions if the bullet is "active"
      if (otherObj.getRadius() + this.boundingCircleRadius > PVector.dist(otherObj.getPosition(), position))
      {
        resultFlag = true;
        fired = false;
      }
      
    return resultFlag; 
  }
  
  public void displaySelf()
  {
    if (fired == true)  // Only display if fired
    {
      pushMatrix();
        translate(this.position.x, this.position.y);
        rotate(direction.heading());
        shape(objShape);
      popMatrix();
    }
  }
  
  public void move()
  {
    if (fired == true)  // Only move if fired
    {
      distance++;  // Run down the timer
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
    
    if (distance >= 50)  // If you've gone far enough, stop and reset distance for next time
    {
      fired = false;
      distance = 0;
    }
  }
  
  //  --  End of Methods  --
  
  
}