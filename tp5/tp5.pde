int nbMovers = 50;
float windX = 0;

boolean showLiquid = true;
boolean spacePressed = false;
boolean debug = false;

Mover[] movers;
Mover balloon;

Liquid liquid;

void setup () {
  size (800, 600);
  
  //MOVERS
  movers = new Mover[nbMovers];
  
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(random(2, 6), random(0, 800), random(0, 300));
  }
  
  //BALLOON
  balloon = new Mover(3, 400, 300);
  
  //LIQUID
  liquid = new Liquid();
  System.out.println("Mass attenuation coefficient: " + liquid.c);
}

void draw () {
  input();
  
  update();
  
  render();
}

void input() {
  if (mousePressed && (mouseButton == LEFT)) {
    windX = 0.05;
  }
  else if (mousePressed && (mouseButton == RIGHT)) {
    windX = -0.05;
  }
  else {
    windX = 0;
  }
}

void update() {
  
  float bm = balloon.mass;
  
  PVector wind = new PVector(windX, 0); 
  PVector heliumGravity = new PVector (0, -0.1 * bm);
  
  //MOVERS
  for (int i = 0; i < movers.length; i++) {
    float m = movers[i].mass;
    PVector gravity = new PVector (0, 0.1 * m);
    
    //LIQUID
    if(showLiquid) {
      if (movers[i].isInside(liquid)) {
          movers[i].drag(liquid);
        }
    }
  
    movers[i].applyForce(wind);
    movers[i].applyForce(gravity);
    
    movers[i].update();
    movers[i].checkEdges();
    
  }

  //BALLOON
  balloon.applyForce(wind);
  balloon.applyForce(heliumGravity);
    
  balloon.update();
  balloon.checkEdges();
}

void render() {
  background (255);

  //MOVERS
  for (int i = 0; i < movers.length; i++) {
    movers[i].display();
    textSize(20);
    fill(0);
    
    if(debug) {
      text(movers[i].velocity.y, movers[i].location.x + 10, movers[i].location.y - 10);
      text(balloon.velocity.y, balloon.location.x + 10, balloon.location.y - 10);
    }
  }

  //BALLOON
  balloon.display();
  
  //LIQUID
  if(showLiquid) {
    liquid.display();
    
    if(debug) {
      text(liquid.c, liquid.x + liquid.w/2, liquid.y + liquid.h/2);
    }
  }
}

void keyPressed() {
  if((key == ' ') && spacePressed == false) {
    showLiquid = !showLiquid;
    if(showLiquid) {
      liquid = new Liquid();
      System.out.println("Mass attenuation coefficient: " + liquid.c);
    }
    spacePressed = true;
  }
  
  if(key == 'r') {
    showLiquid = true;
    setup();
  }
  
  if(key == 'd') {
    debug = !debug;
  }
}

void keyReleased() {
  if(key == ' ') {
    spacePressed = false;
  }
}