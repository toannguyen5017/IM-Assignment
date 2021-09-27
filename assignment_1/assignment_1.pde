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

int tempIndex = 0;
float lastTemp;
float R, B, PR, PB; 
color bColour;
color pColour;

void setup() {
  fullScreen();
  ellipseMode(CENTER);
  colorMode(RGB, 255, 100, 255); //needs to be in RGB for background to change between red and blue

  peopleCountIn = loadTable("peopleCountIn.csv"); //produces the table of people entering.
  peopleCountOut = loadTable("peopleCountOut.csv"); //produces table of people leaving.
  temperature = loadTable("airTemperature.csv"); //produces the table for air temperature

  rowIn = peopleCountIn.getRow(index); //sets up the starting dates for update array
  rowOut = peopleCountIn.getRow(index); 
  String[] splitlast = split(rowIn.getString(0), ' '); //splits the string first into date and then time
  lastDate = split(splitlast[1], ':'); //splits the string into hours and minutes 
  tempRow = temperature.getRow(tempIndex);
  lastTemp = tempRow.getFloat(1);



  startY = height / 2;
  startX2 = width / 2;
}

void draw() {
  noStroke();
  
  backgroundColour();
  
  updateArray();


  fill(255);
  circle(width/2, height/2, 100);

  for (Person person : persons) { //for each person object in the persons arraylist it runs personMove and display
    person.personMove(); 
    person.display();
  }

  for (int i = 0; i < persons.size(); i++) { //goes through each person and checks if they are passed 500, if so removes it. seperate from other for loop as it need i to find the position in the array
    Person checkPerson = persons.get(i);
    if (checkPerson.finished()) {
      persons.remove(i);
    }
  }
}
