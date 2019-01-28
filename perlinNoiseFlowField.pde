float scl = 10;
float inc = 0.1;
int col, row;
float zoffset = 0;
Particle[] particles;
PVector[] flow;

void setup() {
  size(800, 600, P2D);
  col = floor(width / scl);
  row = floor(height / scl);

  particles = new Particle[1500];
  for (int i = 0; i < particles.length; ++i)
    particles[i] = new Particle();

  flow = new PVector[col * row];

  background(255);
}

void draw() {
  float yoffset = 0;
  for (int y = 0; y < row; y++) {
    float xoffset = 0;
    for (int x = 0; x < col; x++) {
      int index = x + y * col; 
      float angle = noise(xoffset, yoffset, zoffset) * TWO_PI * 2;
      PVector v = PVector.fromAngle(angle);
      v.setMag(1);
      flow[index] = v;

      xoffset += inc;
    }
    yoffset += inc;
    // change this for cooler effects
    zoffset += 0.0003;
  }
  for (int i = 0; i < particles.length; ++i) {
    particles[i].follow(flow);
    particles[i].update();
    particles[i].show();
  }
}
class Particle {
  PVector pos = new PVector(random(width - 1), random(height - 1)); // position
  PVector vel = new PVector(0, 0); // velocity
  PVector acc = new PVector(0, 0); // acceleration
  PVector prevPos = pos.copy(); // previous position
  // increase speed [might change pattern :^)]
  float maxSpeed = 1;
  void update() {
    prevPos.x = pos.x; 
    prevPos.y = pos.y; 
    vel.add(acc); 
    vel.limit(maxSpeed);
    pos.add(vel); 
    if (pos.x >= width) pos.x = prevPos.x = 0;
    if (pos.x < 0) pos.x = prevPos.x = width - 1;
    if (pos.y >= height) pos.y = prevPos.y = 0;
    if (pos.y < 0) pos.y = prevPos.y = height - 1;
    acc.mult(0);
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void show() {
    // changes colour
    stroke(random(0,250), random(0,250), random(0,250));
    // changes thickness of brush
    strokeWeight(1);
    line(pos.x, pos.y, prevPos.x, prevPos.y);
  }

  void follow(PVector[] flow) {
    int x = floor(pos.x / scl);
    int y = floor(pos.y / scl);
    int index = x + y * col;
    PVector force = flow[index];
    applyForce(force);
  }
}