class Attractor {
  float mass;                // Mass, tied to size
  PVector location;          // Location
  PVector acceleration;      // Location
  PVector velocity;
  boolean dragging = false;  // Is the object being dragged?
  boolean rollover = false;  // Is the mouse over the ellipse?
  PVector dragOffset;        // holds the offset for when object is clicked on

  Attractor() {
    location = new PVector(width/2 , height/2 );
    mass = random(900, 1200);
    dragOffset = new PVector(0.0, 0.0);
    velocity = new PVector(random(-0.009, -0.0011), 0);
    acceleration = new PVector(0, 0);
  }

  PVector attract(Mover m) {
    PVector force = PVector.sub(location, m.location);  // Calculate direction of force
    float d = force.mag();                              // Distance between objects
    if (d<=1)
    {
      m.swallowed = true;
      mass += m.mass;     
      swallowedObjectsSolar ++;
      return new PVector(0, 0);
    } else
    {
      d = constrain(d, 1.0, 175.0);                          // Limiting the distance to eliminate "extreme" results for very close or very far objects
      force.normalize();                                  // Normalize vector (distance doesn't matter here, we just want this vector for direction)
      float strength = (G * mass * m.mass) / (d * d);     // Calculate gravitional force magnitude
      force.mult(strength);                               // Get force vector --> magnitude * direction
      return force;
    }
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    velocity.x = constrain(velocity.x, -18, 18);
    velocity.y = constrain(velocity.y, -18, 18);
    location.add(velocity);
    acceleration.mult(0);
  }

  // Method to display
  void display() {
    ellipseMode(CENTER);
    strokeWeight(1);
    stroke(0);
    fill(127, 127, 127);

    float windowWidth = zoom*width;
    float windowHeight = zoom*height;

    float x = map(location.x, - windowWidth, windowWidth +width, 0, width);
    float y = map(location.y, -windowHeight, windowHeight +height, 0, height);

    ellipse(x + offsetX, y+offsetY, mass/100, mass/100);
  }

  // The methods below are for mouse interaction
  void clicked(int mx, int my) {
    float d = dist(mx, my, location.x, location.y);
    if (d < mass) {
      dragging = true;
      dragOffset.x = location.x-mx;
      dragOffset.y = location.y-my;
    }
  }

  void hover(int mx, int my) {
    float d = dist(mx, my, location.x, location.y);
    if (d < mass) {
      rollover = true;
    } else {
      rollover = false;
    }
  }

  void stopDragging() {
    dragging = false;
  }

  void drag() {
    if (dragging) {
      location.x = mouseX + dragOffset.x;
      location.y = mouseY + dragOffset.y;
    }
  }
}