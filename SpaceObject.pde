
/*
  Jesse Cooper
  IGME202.01
  Prof. Erin Cascioli
*/

public abstract class SpaceObject
{
  //  --  Instance Variables  --
 
  protected PVector position;
  protected PVector velocity;
  protected PVector direction;
  protected PShape objShape;
  protected PShape boundingCircle;
  protected float boundingCircleRadius;
  protected float speed;
 
  //  --  End of Instance Variables  -- 
  
  
  //  --  Constructors  --
  
  public SpaceObject(float x, float y)
  {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    direction = new PVector(0, 0);
    PVector.fromAngle(0, direction);
    boundingCircleRadius = 0;
    speed = 0;
  }
  
  public SpaceObject(int x, int y, float spd)
  {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    direction = new PVector(0, 0);
    PVector.fromAngle(0, direction);
    boundingCircleRadius = 0;
    speed = spd;
  }
  
  //  --  End of Constructors  --
  
  
  //  --  Methods  --
  
  public PVector getPosition()
  { return position; }
  
  public float getRadius()
  { return boundingCircleRadius; }
  
  public abstract void takeHit();
  
  public abstract void startShaping();
  
  public abstract boolean colliding(SpaceObject otherObj);
  
  public abstract void displaySelf();
  
  public abstract void move();
  
  //  --  End of Methods  --
  
  
}