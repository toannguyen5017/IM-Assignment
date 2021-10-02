PImage icon;
ArrayList <Person> persons = new ArrayList <Person>();
float easing = 0.05;
int savedTime;
int totalTime = 5000;

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

void setup() {
  size(1000, 1000);
  ellipseMode(CENTER);
  imageMode(CENTER);
  icon = loadImage("buildingicon.png");
  savedTime = millis();
}

void draw() {
  noStroke();
  background(200);
  Building building = new Building();
  int personCounter = persons.size();
  fill(0);
  text(personCounter, 50, 50); 
  textSize(50);
  int passedTime = millis() - savedTime; //time passed

  for (int i=persons.size()-1; i>=0; i--) {      
    Person person = persons.get(i);
    person.display();
    person.move();
    if (passedTime < totalTime) {
      person.checkCollision(building); //bounce person off building, move to center after 5 seconds
    }
    if (passedTime > 6000) { //remove people
      persons.remove(person);
    }
    if (passedTime > 8000) { //reset timer
      savedTime = millis();
    }  
  }

  fill(255);
  circle (500, 500, 300);
  image(icon, 500, 500, 200, 200);
}

/*
void mousePressed() {
  if (mouseX>0 && mouseX<1000 &&
    mouseY>0 && mouseY<1000) {
    persons.add(new Person(mouseX, mouseY, 20));
  }
}
*/
