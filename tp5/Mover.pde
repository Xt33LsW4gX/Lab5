class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
   
  float topSpeed;
  float mass;
  
  Mover () {
    
    this.location = new PVector (random (width), random (height));    
    this.velocity = new PVector (0, 0);
    this.acceleration = new PVector (0 , 0);
    
    this.mass = 1;
  }  
  
  Mover (PVector loc, PVector vel) {
    this.location = loc;
    this.velocity = vel;
    this.acceleration = new PVector (0 , 0);
    
    this.topSpeed = 100;
  }
  
  Mover (float m, float x, float y) {
    mass = m;
    location = new PVector (x, y);
    
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  void update () {
    velocity.add (acceleration);
    location.add (velocity);

    acceleration.mult (0);
  }
  
  void display () {
    stroke (0);
    strokeWeight(6);
    fill (127, 127, 127, 127);
    
    ellipse (location.x, location.y, mass * 16, mass * 16); // Dimension à l'échelle de la masse
  }
  
  void checkEdges() {
    if (location.x > width) {
      location.x = width;
      velocity.x *= -0.9;
    } else if (location.x < 0) {
      velocity.x *= -0.9;
      location.x = 0;
    }
    
    if (location.y > height) {
      velocity.y *= -0.9;
      location.y = height;
    } else if (location.y < 0) {
      velocity.y *= -0.9;
      location.y = 0;
    }
    
  }
  
  void applyForce (PVector force) {
    PVector f = PVector.div (force, mass);
   
    this.acceleration.add(f);
  }
  
  boolean isInside(Liquid l) {
    if (location.x>l.x && location.x<l.x+l.w && location.y>l.y && location.y<l.y+l.h) {
      return true;
    }
    else {
      return false;
    }
  }
  
  void drag(Liquid l) {

    float speed = velocity.mag();
    // The force’s magnitude: Cd * v~2~
    float dragMagnitude = (l.c/10) * speed * speed;

    PVector drag = velocity.get();
    drag.mult(-1);
    // The force's direction: -1 * velocity
    drag.normalize();

    // Finalize the force: magnitude and direction together.
    drag.mult(dragMagnitude);

    // Apply the force.
    applyForce(drag);
  }
}