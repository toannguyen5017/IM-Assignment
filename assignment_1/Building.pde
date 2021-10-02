class Building { //center circle to bounce off
  float x = 500, y = 500;
  float radius = 300;
  float vx = 0, vy = 0;
  PVector position = new PVector(x, y);
  void display() {
    noFill();
    circle (x, y, radius);
    image(icon, x, y, 200, 200);
  }
}
