class Person {
  float y;
  float x;
  float s; 
  float si;

  Person(float xpos, float ypos, float speed, float size) {
    x = xpos;
    y = ypos;
    s = speed;
    si = size;
  }

  void personMove() { //updates the x value each frame according to the speed value (s)
    pushMatrix(); 
    translate(x, y);
    popMatrix(); 
    x = x + s;
  }
  void display() { //draws the circle
    fill(1);
    circle(x, y, si);
  }

  boolean finished() { //check if the dot is halfway
    if (x >= width/2 - 100) {
      return true;
    }
    return false;
  }

}
