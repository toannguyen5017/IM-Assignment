<<<<<<< Updated upstream:Person.pde
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

  boolean finished() { //checks if x is greater than 500; 
    if (x >= width/2) {
      return true;
    } else {
      return false;
    }
  }
}
=======
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

  boolean finished() { //checks to see if the circle has reached halfway (persons leaving) or is off the screen (people leaving)
    if (x == width/2 || x == width) {
      return true;
    }
    return false;
  }

}
>>>>>>> Stashed changes:assignment_1/Person.pde
