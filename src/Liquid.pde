
 // Liquid class 
 class Liquid {
   
  PVector location;
  float w,h;
  float drag;

  Liquid(float locationX, float locationY, float w_, float h_, float d_) {
    location = new PVector(locationX, locationY);
    w = w_;
    h = h_;
    drag = d_;
  }
  
  // This checks if the asteroid is in the water
  boolean contains(Asteroid theAsteroid) {
    PVector asteroidLocation = theAsteroid.location;
    if (asteroidLocation.x > location.x && asteroidLocation.x < location.x + w && asteroidLocation.y > location.y && asteroidLocation.y < location.y + h) return true;
    else return false;
  }
  
  // Calculate drag force
  PVector drag(Asteroid theAsteroid) {
    float speed = theAsteroid.velocity.mag();                            // Magnitude is coefficient * speed squared
    float dragMagnitude = drag * speed * speed;
    PVector drag = theAsteroid.velocity.copy();                          // Direction is inverse of velocity
    drag.mult(-1);
    drag.setMag(dragMagnitude);                                          // Scale according to magnitude
    return drag;                                                         // Return the drag
  }
  
  // Draw the rectangle that represents the water
  void display() {
    noStroke();
    fill(115,193,229);
    rect(location.x,location.y,w,h);
  }
}