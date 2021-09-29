//Tab;es
Table peopleCountIn;
Table peopleCountOut;
Table temperature;

//people count parameters
int index = 0; //starts the count at the first rowIn 
TableRow rowIn;
TableRow rowOut;
String[] lastDate;
int inCount; //increase or decrease the amoount of people
int outCount;

//person parameters
ArrayList <Person> persons = new ArrayList <Person>();
int startX1 = -30;
int startX2; //startX2 and startY have to be delacred in setUp as the height and width isn't set till the program starts because of fullscreen();
int startY; 
float personSize = 30; //changes the size
int speed = 10; //


//background colour parameters
TableRow tempRow;
int tempIndex = 0;
float lastTemp;
float R, B, PR, PB; 
color bColour;
color pColour;

//temperature graph parameters
float[] amount;
float minamount, maxamount;
int[] mm;
float X1, Y1, X2, Y2;

void setup() {
  fullScreen();
  ellipseMode(CENTER);
  colorMode(RGB, 255, 100, 255); //needs to be in RGB for background to change between red and blue

  //loading tables
  peopleCountIn = loadTable("peopleCountIn.csv");
  peopleCountOut = loadTable("peopleCountOut.csv");
  temperature = loadTable("airTemperature.csv");
  String[] lines = loadStrings("airTemperature.csv");

  //getting last date for people counter and temp
  rowIn = peopleCountIn.getRow(index); //sets up the starting dates for update array
  rowOut = peopleCountIn.getRow(index); 
  
  String[] splitlast = split(rowIn.getString(0), ' '); //splits the string first into date and then time
  lastDate = split(splitlast[1], ':'); //splits the string into hours and minutes 
  
  tempRow = temperature.getRow(tempIndex);
  lastTemp = tempRow.getFloat(1);

  //sets up the graph adjust these values to change it's position just be careful as it may flip the graph upside down.
  X1 = width/2 - 300; 
  Y1 = height/2 + 200;
  X2 = width/2 + 300; 
  Y2 = height/2 + 400;
  
  amount = new float[lines.length];
  mm = new int[lines.length];
  
  //splits up the string
  for (int i=0; i<lines.length; i++) {
    String[] pieces = split(lines[i], ",");
    amount[i] = float(pieces[1]);
    mm[i] = int(pieces[0]);
  }

  minamount = min(amount);
  maxamount = max(amount);


  //initalisng values dependant on the screen size
  startY = height / 2;
  startX2 = width / 2;
}

void draw() {
  noStroke();

  //functions that need calling
  backgroundColour();
  updateArray();
  noFill();
  drawGraph(amount, minamount, maxamount);
  drawXLabels();
  drawYLabels();


  //drawing the center circle
  fill(255);
  circle(width/2, height/2, 100);

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
