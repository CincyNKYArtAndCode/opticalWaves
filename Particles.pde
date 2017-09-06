// Class that represent a particle and 
// it's velocity 

float drag = 0.1;

float maxVel = 0.0;

float minDisplayX = 0;
float maxDisplayX = 0;
float minDisplayY = 0;
float maxDisplayY = 0;

float velocityScale = 0.5;

class Particle {
    
  public PVector origin;
  public PVector position;
  public PVector velocity;
  
  Particle(float x, float y) {
    origin = new PVector(x,y);
    position = new PVector(x,y);
    velocity = new PVector(0,0);
  }
  
  Particle(PVector p) {
    origin = new PVector(p.x, p.y);
    position = new PVector(p.x, p.y);
    velocity = new PVector(0,0);
  }
  
  void Update(PVector newVel) {
    
    newVel.mult(velocityScale);
    // Slow down over time
    velocity.add(-drag * velocity.x, -drag * velocity.y);
    // Add new velocity impulse.  This is sort of like
    // acceleration
    velocity.add(newVel);
    // Let's not got too fast
    velocity.limit(min(maxDisplayX  - minDisplayX, maxDisplayY  - minDisplayY)/2);
    
    // Update the particles position
    position.add(velocity);
    
    // Add a impulse to return the particle back to
    // it's origin
    PVector dir = PVector.sub(origin, position);
    
    if(dir.mag() > 1.0) {
      dir.limit(3);
      position.add(dir);    
    }
    
    // Bounce the particles off the sides
    if(position.x < minDisplayX) {
      position.x = 2*minDisplayX - position.x;
      velocity.x = -velocity.x;
    }
    
    if(position.x >= maxDisplayX) {
      position.x = 2*maxDisplayX - position.x;
      velocity.x = -velocity.x;
    }
    
    if(position.y < minDisplayY) {
      position.y = 2*minDisplayY - position.y;
      velocity.y = -velocity.y;
    }
    
    if(position.y >= maxDisplayY) {
      position.y = 2*maxDisplayY - position.y;
      velocity.y = -velocity.y;
    }
  }
}

// Create an array of particles and thier initial positions
Particle[] createGrid(int sizeX, int sizeY, float minX, float minY, float maxX, float maxY) {
  
  minDisplayX = minX;
  maxDisplayX = maxX;
  minDisplayY = minY;
  maxDisplayY = maxY;
  
  println(minDisplayX,maxDisplayX,minDisplayY,maxDisplayY);
  
  float incX = (maxX - minX)/sizeX;
  float incY = (maxY - minY)/sizeY;
  
  Particle[] grid = new Particle[sizeX * sizeY];
  
  int idx = 0;
  for(int y = 0; y < sizeY; ++y) {
    for(int x = 0; x < sizeX; ++x) {
      grid[idx] = new Particle(minX + x*incX, minY + y*incY);
      ++idx;
    }
  }
  
  return grid;
}