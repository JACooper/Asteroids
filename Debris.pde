
/*
  Jesse Cooper
  IGME202.01
  Prof. Erin Cascioli
*/

//  --  Import Statements  --

import java.util.Random;

//  --  End of Import Statements  --

public class Debris extends SpaceObject
{
  //  --  Instance Variables  --
 
  private int size;
  private int pointValue;
  private int shapeType;
 
  //  --  End of Instance Variables  -- 
  
  
  //  --  Constructors  --
  
  public Debris(float x, float y)
  {
    super(x, y);
    size = 3;         // Determines how many times it can break
    pointValue = 20;  // Biggest targets = 20 points
    
    boundingCircleRadius = 16;
    shapeType = 0;
    objShape = createShape();
    startShaping();
    
    // Assign direction, velocity, etc.
    Random rnd = new Random();
    Random rndProper = new Random(rnd.nextLong());
    
    direction = new PVector(0, 0);
    PVector.fromAngle(0, direction);
    direction.rotate(radians(rndProper.nextFloat() * (360 * rndProper.nextFloat())));
    direction.normalize();
    speed = 2;
    velocity = PVector.mult(direction, speed);
  }
  
  private Debris(PVector p, int sz, int ptVal, PShape parentShape, float scaleFactor, int type, float r)  // For creating smaller asteroids from bigger ones
  {
    super(p.x, p.y);
    size = sz;
    pointValue = ptVal;
    shapeType = type;
    
    boundingCircleRadius = r * scaleFactor;  // Scale the size (take the initial radius and scale that too, so it matches the shape)
    objShape = createShape();
    startShaping();
    objShape.scale(scaleFactor);
    
    Random rnd = new Random();
    Random rndProper = new Random(rnd.nextLong());
    
    direction = new PVector(0, 0);
    PVector.fromAngle(0, direction);
    direction.rotate(radians(rndProper.nextFloat() * (360 * rndProper.nextFloat()) + 0.01));
    direction.normalize();
    speed = 3;    // Make smaller asteroids slightly faster
    velocity = PVector.mult(direction, speed);
  }
  
  //  --  End of Constructors  --
  
  
  //  --  Methods  --
  
  public void takeHit()
  {
    if (size == 3)      // If it was a big asteroid, break into two 50 point asteroids at 66% the initial size, add them to the global asteroid list, and give the player points
    {
      Debris child1 = new Debris(PVector.add(new PVector(boundingCircleRadius, 0), position), (size - 1), 50, objShape, 0.66, shapeType, boundingCircleRadius);
      Debris child2 = new Debris(PVector.add(new PVector(0, boundingCircleRadius), position), (size - 1), 50, objShape, 0.66, shapeType, boundingCircleRadius);
      asteroidList.add(child1);
      asteroidList.add(child2);
      playerScore += pointValue;
    }
    else if (size == 2)  // Medium asteroids break into two 100 point asteroids and 45% the size
    {
      Debris child1 = new Debris(PVector.add(new PVector(boundingCircleRadius, 0), position), (size - 1), 100, objShape, 0.45, shapeType, boundingCircleRadius);
      Debris child2 = new Debris(PVector.add(new PVector(0, boundingCircleRadius), position), (size - 1), 100, objShape, 0.45, shapeType, boundingCircleRadius);
      asteroidList.add(child1);
      asteroidList.add(child2);
      playerScore += pointValue;
    }
    else if (size == 1)  // Small asterois just give the player points and die
      playerScore += pointValue;
  }
  
  public void startShaping()
  {
    // Random var to determine which of the three asteroid shapes to use
    Random rnd = new Random();
    Random rndProper = new Random(rnd.nextLong());
    float rndTester = rndProper.nextFloat();
    
    objShape.beginShape();
      objShape.stroke(255, 255, 255, 230);
      if (shapeType == 1 || rndTester < 0.33)
      {
        // 1st asteroid type  -  I probably spent more time trying to make these vertex coordinates work than I did on anything else in my code
        objShape.vertex(0, -15);
        objShape.vertex(15, -6);
        objShape.vertex(18, -1);
        objShape.vertex(15, 0);
        objShape.vertex(9, 4);
        objShape.vertex(2, 14);
        objShape.vertex(0, 15);
        objShape.vertex(-8, 12);
        objShape.vertex(-9, 6);
        objShape.vertex(-15, 0);
        objShape.vertex(-12, -4);
        objShape.vertex(-8, -17);
        shapeType = 1;
      }
      else if (shapeType == 2 || rndTester < 0.66)
      {
        // 2nd asteroid type
        //objShape.stroke(0, 255, 0, 230);  // Testing colors 
        objShape.vertex(0, -15);
        objShape.vertex(6, -9);
        objShape.vertex(11, -1);
        objShape.vertex(13, 5);
        objShape.vertex(11, 13);
        objShape.vertex(5, 19);
        objShape.vertex(4, 19);
        objShape.vertex(1, 14);
        objShape.vertex(-9, 9);
        objShape.vertex(-13, 6);
        objShape.vertex(-11, -7);
        shapeType = 2;
      }
      else if (shapeType == 3 || rndTester <= 1)
      {
        // 3rd asteroid type
        //objShape.stroke(0, 0, 255, 230);
        objShape.vertex(0, -15);
        objShape.vertex(7, -8);
        objShape.vertex(18, -1);
        objShape.vertex(15, 4);
        objShape.vertex(9, 4);
        objShape.vertex(5, 19);
        objShape.vertex(0, 15);
        objShape.vertex(-8, 22);
        objShape.vertex(-11, 10);
        objShape.vertex(-15, 0);
        objShape.vertex(-12, -4);
        objShape.vertex(-8, -17);
        shapeType = 3;
      }
    
    objShape.endShape(CLOSE);
    objShape.setFill(0);
    
    //boundingCircle = createShape(ELLIPSE, 0, -1, boundingCircleRadius, boundingCircleRadius, RADIUS);    // Invalid in Processing 3
    ellipseMode(RADIUS);
    boundingCircle = createShape(ELLIPSE, 0, -1, boundingCircleRadius, boundingCircleRadius);
    boundingCircle.setFill(color(255, 255, 255, 50));
  }
  
  public boolean colliding(SpaceObject otherObj)
  {
    boolean resultFlag = false;
    
    if (otherObj.getRadius() + this.boundingCircleRadius > PVector.dist(otherObj.getPosition(), position))
    {
      resultFlag = true;
    }
    
    return resultFlag; 
  }
  
  public void displaySelf()
  {
    pushMatrix();
      translate(this.position.x, this.position.y);
      rotate(direction.heading());
      shape(objShape);
    //shape(boundingCircle);
    popMatrix();
  }
  
  public void move()
  {
    
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