
/*
  Jesse Cooper
  IGME202.01
  Prof. Erin Cascioli
*/

public abstract class Ship extends SpaceObject
{
  
  //  --  Constructors  --
  
  public Ship(float x, float y)
  {
    super(x, y);
  }
  
  //  --  End of Constructors  --
  
  
  //  --  Methods  --
  
  public abstract void shoot();  // Implemented in subclasses
  
  public abstract void takeHit();
  
  public abstract void startShaping();
  
  public abstract boolean colliding(SpaceObject otherObj);
  
  public abstract void displaySelf();
  
  public abstract void move();
  
  //  --  End of Methods  --
  
  
}