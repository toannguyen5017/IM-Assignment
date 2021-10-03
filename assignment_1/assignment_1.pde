//int count; //increase or decrease the amoount of people
Table peopleCountIn;
Table peopleCountOut;
Table temperature;

TableRow tempRow;

int startX1 = -30;
int startX2; //startX2 and startY have to be delacred in setUp as the height and width isn't set till the program starts because of fullscreen();

int inCount; //increase or decrease the amoount of people
int outCount;

int tempIndex = 0;
float lastTemp;
float R, B, PR, PB; 
color bColour;
color pColour;

int index = 0; //starts the count at the first row 
float personSize = 30; //changes the size
int startX = -30;
int startY = 500; //have to be hard coded as size isn't set till after this is declared
int speed = 10; //not nearly fast enough
String[] hour;
int[] countArray = new int[23];
TableRow row;
ArrayList <Person> persons = new ArrayList <Person>();
Table peopleCount;

//Circle Branch
PImage icon;
float easing = 0.05;
int savedTime;
//int totalTime = 5000;
int personCount;
int circles = 0;

//temperature graph parameters
float[] amount;
float minamount, maxamount;
int tempCount;
int graphIndex = 0;
float X1, Y1, X2, Y2, sum;
int y = 0;
String[] tempSplit;
String[] lastTempDate;

//person graph parameters
int pIndex = 0;
int Py = 0;
float[] pAmount;
float pMinAmount, pMaxAmount;
float PX1, PY1, PX2, PY2, pSum;
String[] dateSplit;
String[] lastDate;

CalendarTimelapse calendar;


void setup() {
  fullScreen(1);
  ellipseMode(CENTER);
  rectMode(CENTER);

  calendar = new CalendarTimelapse();


  //Circle branch 
  imageMode(CENTER);
  icon = loadImage("buildingicon.png");

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
}



void draw() {
  noStroke();
  background(0, 200, 0); 

  /*
  fill(1);
   circle(500, 500, 100);
   updateArray();
   
   for (Person person : persons) {
   person.move(); 
   person.display();
   }
   
   
   for (int i = 0; i < persons.size(); i++) { //goes through each person and checks if they are passed 500, if so removes it. seperate from other for loop as it need i to find the position in the array
   Person checkPerson = persons.get(i);
   if (checkPerson.finished()) {
   persons.remove(i);
   }
   }
   
   */

  noStroke();

  //Amend the color background function
  // calendar.airTempAverage
  // calendar.peopleCountAverage

  Building building = new Building();
  //int personCounter = persons.size();
  fill(0);
  text(calendar.peopleCountAverage, 100, 50); 
  textSize(50);

  personCount = calendar.peopleCountAverage;
  while (circles<personCount) {
    persons.add(new Person(random(width), random(height), 15));
    circles++;
  }

  for (int p=persons.size()-1; p>=0; p--) {
    Person person = persons.get(p);
    person.display();
    person.move();
    if (!calendar.isntTimelapse) {
      person.checkCollision(building);
    } else { //remove people
      calendar.isAnimating = true;
      persons.clear();           
      calendar.isAnimating = false;
      circles = 0;
      break;
    }
  }


  fill(255);
  circle (width/2, height/2, 300);
  image(icon, width/2, height/2, 200, 200);

  noFill();
  drawTempGraph(amount, minamount, maxamount);
  drawTempXLabels();
  drawTempYLabels();
  noFill();
  drawPeopleGraph(pAmount, pMinAmount, pMaxAmount);
  drawPeopleXLabels();
  drawPeopleYLabels();

  rectMode(CORNER);
  fill(0);
  calendar.drawCalendar();
  fill(255);
  rectMode(CENTER);
}

//void updateArray() { // checks if all persons in the array are gone. need to and time for when the count is 0 
/*if (persons.size() == 0) { //once all gone increases count and startX.
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
 */
//}





void mouseClicked() {
  if (calendar.isDateText == true && mouseX >= calendar.translateX + 55 && mouseX <= calendar.translateX + 230
    && mouseY <= 70) calendar.toggleDate();


  if (!calendar.isDateText) {
    for (Day day : calendar.dayObjects) {
      if (mouseX >= day.getDetranslatedX() && mouseX <= day.getDetranslatedX() + day.getWidth()
        && mouseY >= day.getDetranslatedY() && mouseY <= day.getDetranslatedY() + day.getHeight()) {
        day.handleClick();
        break;
      }
    }
  }


  if (mouseX >= calendar.getButton("CLOSE").getDetranslatedX() && mouseX <= calendar.getButton("CLOSE").getDetranslatedX() + calendar.getButton("CLOSE").getWidth()
    && mouseY >= calendar.getButton("CLOSE").getDetranslatedY() && mouseY <= calendar.getButton("CLOSE").getDetranslatedY() + calendar.getButton("CLOSE").getHeight()) {
    calendar.getButton("CLOSE").handleButton();
  }

  if (mouseX >= calendar.getButton("NEXT").getDetranslatedX() && mouseX <= calendar.getButton("NEXT").getDetranslatedX() + calendar.getButton("NEXT").getWidth()
    && mouseY >= calendar.getButton("NEXT").getDetranslatedY() && mouseY <= calendar.getButton("NEXT").getDetranslatedY() + calendar.getButton("NEXT").getHeight()) {
    calendar.getButton("NEXT").handleButton();
  }

  if (mouseX >= calendar.getButton("PREV").getDetranslatedX() && mouseX <= calendar.getButton("PREV").getDetranslatedX() + calendar.getButton("PREV").getWidth()
    && mouseY >= calendar.getButton("PREV").getDetranslatedY() && mouseY <= calendar.getButton("PREV").getDetranslatedY() + calendar.getButton("PREV").getHeight()) {
    calendar.getButton("PREV").handleButton();
  }
}
