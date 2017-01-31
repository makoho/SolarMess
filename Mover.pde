// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  color c;
  float size;
  boolean swallowed = false;

  Mover(boolean big) {

    // Generate a random point in a circle around the central attractor
    float angle = random(0, 2 * PI);
    float distance = random(0, 3 * height/4);

    float ix = cos(angle) * distance + width/2;
    float iy = sin(angle) * distance + height/2;
    location = new PVector(ix, iy);

    float vx = cos(angle + (PI/2)) * map(distance, 0, height/2, 1.9, 5);
    float vy = sin(angle + (PI/2)) * map(distance, 0, height/2, 1.9, 5);
    velocity = new PVector(vx, vy);

    acceleration = new PVector(0, 0);
   
    if (big)
      mass=random(400, 800);
    else
      mass=random(1, 10);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    velocity.x = constrain(velocity.x, -15, 15);
    velocity.y = constrain(velocity.y, -15, 15);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {

    float windowWidth = zoom*width;
    float windowHeight = zoom*height;

    float x = map(location.x, - windowWidth, windowWidth +width, 0, width);
    float y = map(location.y, -windowHeight, windowHeight +height, 0, height);

    float s = map(mass, 1, 1000, 1, 10);

    if (s>2)
    {
      stroke(180);
      fill(200);
      strokeWeight(1);
      ellipse(x +offsetX, y+offsetY, s, s);
    } else
    {
      stroke(200);
      point(x+offsetX, y+offsetY);
    }
  }

  PVector attract(Attractor a) {
    
    // Calculate direction of force
    PVector force = PVector.sub(location, a.location);   
    
    // Distance between objects
    float d = force.mag();     
    
    // Limiting the distance to eliminate "extreme" results for very close or very far objects
    d = constrain(d, 1.0, 175.0); 
    
    // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    force.normalize();                  
    
    // Calculate gravitional force magnitude
    float strength = (G * mass * a.mass) / (d * d);     
    force.mult(strength/100);
    return force;
  }

  PVector attract(Mover m) {

    PVector force = PVector.sub(m.location, location);   
    float d = force.mag();                               

    float d1 = constrain(d, 1.0, 175.0);                 
    force.normalize();                                  
    float strength = (G * mass * m.mass) / (d1 * d1);   
    force.mult(strength/10);                            

    if (d<0.01 && strength < 1.5)
    {
      m.swallowed = true;
      mass += m.mass;     
      //velocity.add(m.acceleration);
      swallowedObjectsPlanet ++;
      return new PVector(0, 0);
    } 

    return force;
  }
}