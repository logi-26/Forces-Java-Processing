
class Asteroid {

  // Asteroid location, velocity, and acceleration 
  PVector location, velocity, acceleration;
  float mass;                                          // Mass is tied to size
  float size;                                          // Size of the asteroid
  int maxHealth;                                       // Asteroid maximum health
  int health;                                          // Asteroid current health

  // Asteroid constructor
  Asteroid(PVector asteroidLocation, float asteroidMass, int asteroidHealth) {
    location = asteroidLocation;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = asteroidMass;
    size = mass*16;
    maxHealth = asteroidHealth;
    health = maxHealth;
  }

  // This function applies a force to the asteroid
  void applyForce(PVector force) {
    PVector newForce = PVector.div(force, mass);        // Divide by mass
    acceleration.add(newForce);                         // Accumulate all forces in acceleration
  }

  // Updates the asteroid
  void update() {
    checkEdges();
    velocity.add(acceleration);                        // Velocity changes according to acceleration
    location.add(velocity);                            // Location changes by velocity
    acceleration.mult(0);                              // We must clear acceleration each frame
  }
  
  // Draws Asteroid
  void display() {
    stroke(255);
    strokeWeight(2);
    fill(255, 200);
    ellipse(location.x, location.y, size, size);
  }
  
  // This function calculates the gravitational attraction between other asteroids
  PVector attract(Asteroid theAsteroid, PVector currentGravity) {
    PVector force = PVector.sub(location,theAsteroid.location);
    float distance = force.mag();
    distance = constrain(distance,5,25);
    force.normalize();
    float strength = (currentGravity.x * mass * theAsteroid.mass) / (distance * distance);
    force.mult(strength);
  
    return force;
  }
  
  // This function checks if the asteroid has reached the edges of the screen
  void checkEdges() {
    if (location.x + size > width - 5) {
        location.x = width - size - 5;
        velocity.x *= -1;
    } else if (location.x < 5) {
        velocity.x *= -1;
        location.x = 5;
    }
  }
  
  // This function checks if the asteroid has reached the bottom of the screen
  boolean outOfBounds(boolean gameOver) {
    if (location.y >= 840) gameOver = true;            // If the asteroid has reached the bottom of the screen the boolean is set true
    
    return gameOver;                                   // Returns the boolean
  }
}