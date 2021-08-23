PFont font;                                                  // Font to be used
int time;                                                    // Time between asteroid spawns
int currentLevel = 1;                                        // Level
int windTunnelHeight = 100;
int asteroidHealth = 1;
int score;
boolean shoot;
boolean gameOver = false;
float currentGravity = 0.08;
float shots;
float hits;
String currentForce = "Gravity & Wind";
ArrayList asteroidArray;                                     // List of asteroids
Liquid water;                                                // The water
PVector windTunnel_1_Location = new PVector(0, 100);
PVector windTunnel_2_Location = new PVector(780, 350);


void setup() {
  
  font = loadFont("AgencyFB-Reg-20.vlw");
  size(800,900);
  
  asteroidArray = new ArrayList();                            // Create the list of asteroids
  water = new Liquid(0, height, width, height, 0.1);          // Create the water
  noCursor();
}



void draw() {
  
  background(0);
  frameRate(30);
  
  if (!gameOver) {
 
    time++;
    water.display();                                                                      // Draw the water
    
    if (currentLevel == 1) {
      rect(windTunnel_1_Location.x, windTunnel_1_Location.y, 20, windTunnelHeight);       // Left wind tunnel
      rect(windTunnel_2_Location.x, windTunnel_2_Location.y, 20, windTunnelHeight);       // Right wind tunnel
      fill(84,155,196,60); 
      rect(windTunnel_1_Location.x, windTunnel_1_Location.y, width, windTunnelHeight);    // Left wind
      rect(0, windTunnel_2_Location.y, width, windTunnelHeight);                          // Right wind
    }

    spawnAsteroid();                                                                      // Create the asteroids
    updateAsteroid();                                                                     // Update the asteroids
    hitCheck();
    
    // Player ship
    fill(229,154,48);
    stroke(229,154,48);
    rect(mouseX-20,830,40,30);
    rect(mouseX-10,820,20,40);
    
    // Bottom barrier
    if (currentLevel == 1) {
      fill(255); 
      stroke(255);
    } else {
      fill(0);
      stroke(0);
    }
 
    rect(0,860,width,2);                                                                   // Bottom wall
    rect(0,0,5,height);                                                                    // Left wall
    rect(width - 5,0,5,height);                                                            // Right wall
    
    textFont(font, 20);
    text("Force = " + currentForce, 20,885);
    text("Level: " + currentLevel, 350,885);
    text("Score: " + score, 500,885);
    text("Accuracy: " + int(hits) + "/" + int(shots), 670, 885);
    
    if (shoot) {
      stroke(255, 0, 0);
      line(mouseX,0,mouseX,820);
      stroke(0);
    }
    
    if (score == 20) {
      currentLevel = 2;
      water = new Liquid(0, 0, width, height, 0.1);               // Create liquid object
      currentForce = "Gravity & Drag & Gravitational Attraction";
    }
    
  } else {
    stroke(0);
    textFont(font, 40);
    text("YOU LOSE",10,40);
    textFont(font,20);
    text("SCORE: " + score,10,70);
  }
  
  shoot = false;
}


void mousePressed() {
  shoot = true;
  shots ++;
}


// This function spawns the asteroids
void spawnAsteroid() {
  
  if (time == 30) {
    
    time = 0;
    PVector asteroidLocation = new PVector(int(random(30,870)), 0);  
    float asteroidMass = random(0.8, 3);
    Asteroid theAsteroid = new Asteroid(asteroidLocation, asteroidMass, asteroidHealth);
    asteroidArray.add(theAsteroid);
    theAsteroid = null;
  }
}


// This function updates the asteroids
void updateAsteroid() {
  
  for(int i = 0; i < asteroidArray.size(); i++) {
    
    if (!gameOver) {
    
      Asteroid theAsteroid = (Asteroid)asteroidArray.get(i);                                                     // Get the asteroid
      
      // If the Asteroid is currently in water
      if (water.contains(theAsteroid)) {
        PVector drag = water.drag(theAsteroid);                                                                  // Calculate drag force
        theAsteroid.applyForce(drag);                                                                            // Apply drag force to the asteroid
     
        // Loop through the list of asteroids
        for(int j = 0; j < asteroidArray.size(); j++) {
          Asteroid remoteAsteroid = (Asteroid)asteroidArray.get(j);                                              // Get the current asteroid from the list
           
          // If the remote asteroids mass is smaller than the current asteroids mass
          if (remoteAsteroid.mass < theAsteroid.mass) {
            PVector gravity = new PVector(8 * theAsteroid.mass, 8 * theAsteroid.mass);
            PVector gravitationalAttraction = theAsteroid.attract(remoteAsteroid, gravity);                      // Calculates the gravitational attraction between the 2 asteroids
            remoteAsteroid.applyForce(gravitationalAttraction);                                                  // Applies the gravitational attraction force to the asteroid
          }
        }
        
        // Apply the gravity to the asteroid
        PVector gravity = new PVector(0, (currentGravity*4) * theAsteroid.mass);                                  // Gravity is scaled by mass (gravity acting on Y axis only here)
        theAsteroid.applyForce(gravity);                                                                          // Apply gravity
        
      } else {
        
        // If the asteroid is in the proximity of the left wind tunnel
        if (theAsteroid.location.y > windTunnel_1_Location.y && theAsteroid.location.y < windTunnel_1_Location.y + windTunnelHeight) {
          PVector wind = new PVector(0.2,0);                                                                     // Sets the wind force blowing from left to right
          theAsteroid.applyForce(wind);                                                                           // Apply the wind force to the asteroid
        }
      
        // If the asteroid is in the proximity of the right wind tunnel
        if (theAsteroid.location.y > windTunnel_2_Location.y && theAsteroid.location.y < windTunnel_2_Location.y + windTunnelHeight) {
          PVector wind = new PVector(-0.5,0);                                                                     // Sets the wind force blowing from right to left
          theAsteroid.applyForce(wind);                                                                           // Apply the wind force to the asteroid
        }
        
        // Apply the gravity to the asteroid
        PVector gravity = new PVector(0, currentGravity * theAsteroid.mass);                                      // Gravity is scaled by mass (gravity acting on Y axis only here)
        theAsteroid.applyForce(gravity);                                                                          // Apply gravity
      }
      
      // Update and display the asteroids
      theAsteroid.update();
      theAsteroid.display();
      gameOver = theAsteroid.outOfBounds(gameOver);
    }
  }
}


// This function checks if any of the bullets have hit the asteroids
void hitCheck() {
  
  if (shoot) {
    for (int i = 0; i < asteroidArray.size(); i++) {
      Asteroid theAsteroid = (Asteroid) asteroidArray.get(i);
      if (mouseX < theAsteroid.location.x + theAsteroid.mass*16 && mouseX > theAsteroid.location.x - theAsteroid.mass*16) {
        theAsteroid.health -= 1;
        if (theAsteroid.health <= 0) {
          theAsteroid = null;
          asteroidArray.remove(i);
        }
        hits ++;
        score ++;
      }
    }
  } 
}