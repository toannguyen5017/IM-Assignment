<<<<<<< Updated upstream
int count; //increase or decrease the amoount of people
int index = 0; //starts the count at the first row 
float personSize = 30; //changes the size
int startX = -30;
int startY = 500; //have to be hard coded as size isn't set till after this is declared
int speed = 10; //not nearly fast enough
String[] lastDate;
String[] hour;
int[] countArray = new int[23];
TableRow row;
ArrayList <Person> persons = new ArrayList <Person>();
Table peopleCount;

int test;
=======

Table peopleCountIn;
Table peopleCountOut;
Table temperature;

int index = 0; //starts the count at the first rowIn 
TableRow rowIn;
TableRow rowOut;
TableRow tempRow;
String[] lastDate;

ArrayList <Person> persons = new ArrayList <Person>();
int startX1 = -30;
int startX2; //startX2 and startY have to be delacred in setUp as the height and width isn't set till the program starts because of fullscreen();
int startY; 
float personSize = 30; //changes the size
int speed = 10; //

int inCount; //increase or decrease the amoount of people
int outCount;

float lastTemp;
color fColour; //starting Colour
>>>>>>> Stashed changes

void setup() {
  size(1000, 1000);
  ellipseMode(CENTER);
<<<<<<< Updated upstream
  rectMode(CENTER);

  peopleCount = loadTable("peopleCount.csv"); //produces the table
  row = peopleCount.getRow(index); 
  String[] splitlast = split(row.getString(0), ' ');
  lastDate = split(splitlast[1], ':');
=======
  colorMode(RGB, 100, 100, 100);
  

  peopleCountIn = loadTable("peopleCountIn.csv"); //produces the table of people entering.
  peopleCountOut = loadTable("peopleCountOut.csv"); //produces table of people leaving.
  temperature = loadTable("airTemperature.csv"); //produces the table for air temperature

  rowIn = peopleCountIn.getRow(index); //sets up the starting dates for update array
  rowOut = peopleCountIn.getRow(index); 
  String[] splitlast = split(rowIn.getString(0), ' '); //splits the string first into date and then time
  lastDate = split(splitlast[1], ':'); //splits the string into hours and minutes 
  
  tempRow = temperature.getRow(index);

  startY = height / 2;
  startX2 = width / 2;
>>>>>>> Stashed changes
}

void draw() {
  noStroke();
  backgroundColour(); 

<<<<<<< Updated upstream
  fill(1);
  circle(500, 500, 100);
=======
>>>>>>> Stashed changes
  updateArray();

  for (Person person : persons) { //for each person object in the persons arraylist it runs personMove and display
    person.personMove(); 
    person.display();
  }
<<<<<<< Updated upstream
=======
  fill(0);
  circle(width/2, height/2, 100);

>>>>>>> Stashed changes

  for (int i = 0; i < persons.size(); i++) { //goes through each person and checks if they are passed 500, if so removes it. seperate from other for loop as it need i to find the position in the array
    Person checkPerson = persons.get(i);
    if (checkPerson.finished()) {
      persons.remove(i);
    }
  }
}

void updateArray() { // checks if all persons in the array are gone. need to and time for when the count is 0 
  if (persons.size() == 0) { //once all gone increases count and startX.
    String[] splitDate = split(row.getString(0), '/');
    //println(splitDate[0], " ", lastDate[0]);
    if (int(splitDate[0]) == int(lastDate[0])) {
      count = count + row.getInt(1);
      index++; //increases index to the next row
      row = peopleCount.getRow(index);
    } else {  
      //println(row.getString(0), " ", count); //debugging to see if the count is working
      lastDate = split(row.getString(0), '/');
      startX = -50; //startX has to be updated as else it continues to get further and further back.
      for (int i = 0; i < count; i++) { //creates new persons according to the new count.
        persons.add(new Person(startX, startY, speed, personSize)); 
        startX = startX - 50;
      }
      count = row.getInt(1);
      index++;
      row = peopleCount.getRow(index);
    }
  }
}


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
    if (x >= 500) {
      return true;
    } else {
      return false;
    }
  }
}
