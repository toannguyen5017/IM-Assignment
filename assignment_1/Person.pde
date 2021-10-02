<<<<<<< HEAD
<<<<<<<< HEAD:assignment_1/Person.pde
========
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
>>>>>>>> PersonGraph:Person.pde
=======
>>>>>>> PersonGraph
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
<<<<<<< HEAD
    fill(1);
    circle(x, y, si);
  }

<<<<<<<< HEAD:assignment_1/Person.pde
  boolean finished() {
========
  boolean finished() { //checks to see if the circle has reached halfway (persons leaving) or is off the screen (people leaving)
>>>>>>>> PersonGraph:Person.pde
    if (x == width/2 || x == width) {
=======
    fill(255);
    circle(x, y, si);
  }

  boolean finished() { //check if the dot is halfway
    if (x >= width/2 - 100) {
>>>>>>> PersonGraph
      return true;
    }
    return false;
  }

}
<<<<<<< HEAD
<<<<<<<< HEAD:assignment_1/Person.pde
========
>>>>>>> Stashed changes:assignment_1/Person.pde
>>>>>>>> PersonGraph:Person.pde
=======
>>>>>>> PersonGraph
