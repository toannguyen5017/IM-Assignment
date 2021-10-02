//Tables
Table peopleCount;
Table temperature;

//person parameters
ArrayList <Person> persons = new ArrayList <Person>();
int startX1 = -30;
int startX2; //startX2 and startY have to be delacred in setUp as the height and width isn't set till the program starts because of fullscreen();
int startY; 
float personSize = 30; //changes the size
int speed = 15; //
int index = 0;
int count = 0;

//background colour parameters
TableRow tempRow;
int tempIndex = 0;
float lastTemp;
float R, B, PR, PB; 
color bColour;
color pColour;
float temp;
float diff;

//temperature graph parameters
float[] amount;
float minamount, maxamount;
int tempCount;
int graphIndex = 0;
float X1, Y1, X2, Y2, sum;
int y = 0;
String[] tempSplit;
String[] lastTempDate;
float lineX; 

//person graph parameters
TableRow row;
int pIndex = 0;
int Py = 0;
float[] pAmount;
float pMinAmount, pMaxAmount;
float PX1, PY1, PX2, PY2, pSum;
String[] dateSplit;
String[] lastDate;
float pLineX;

void setup() {
  fullScreen(1);
  ellipseMode(CENTER);
  colorMode(RGB, 255, 100, 255); //needs to be in RGB for background to change between red and blue

  //loading tables
  peopleCount = loadTable("peopleCount.csv");
  temperature = loadTable("airTemp.csv");

  //getting last date for people counter and temp
  row = peopleCount.getRow(index); //sets up the starting dates for update array
  
    lastDate = split(row.getString(0), '/'); 
  
  tempRow = temperature.getRow(graphIndex);
  lastTemp = tempRow.getFloat(0);
  tempSplit = split(tempRow.getString(0), '-'); 
  lastTempDate = split(tempSplit[2], ' '); 
 
 

  //sets up the graph adjust these values to change it's position just be careful as it may flip the graph upside down.

  //set up Graphs
  setUpTempGraph();
  setUpPersonGraph();

  tempRow = temperature.getRow(0);
  //initalisng values dependant on the screen size
  startY = height / 2;
  startX2 = width / 2;
}

void draw() {
  noStroke();
  //functions that need calling
  backgroundColour();
  noFill();
  drawTempGraph(amount, minamount, maxamount);
  drawTempXLabels();
  drawTempYLabels();
  drawTempLine();
  noFill();
  drawPeopleGraph(pAmount, pMinAmount, pMaxAmount);
  drawPeopleXLabels();
  drawPeopleYLabels();
  drawPeopleLine();

  //drawing the center circle
  fill(255);
  circle(width/2, height/2, 200);
  fill(bColour);
  textSize(30);
  textAlign(CENTER, CENTER);
  text(persons.size() * 10 + " people", width/2,height/2);
  
  //draws a circle with the current temperature;
  fill(255);
  circle(width/2, height/2 + 200, 150);
  fill(bColour);
  textSize(30);
  textAlign(CENTER, CENTER);
  String printTemp = nf(temp, 0, 2);
  text(printTemp +"°C", width/2,height/2 + 200);
  
  updateArray();
  
  //for each person object in the persons arraylist it runs personMove and display
  for (Person person : persons) { 
    person.personMove(); 
    person.display();
  }

  //goes through each person and checks if they are passed 500, if so removes it. seperate from other for loop as it need i to find the position in the array
  for (int i = 0; i < persons.size(); i++) { 
    Person checkPerson = persons.get(i);
    if (checkPerson.finished()) {
      persons.remove(i);
    }
  }
}
