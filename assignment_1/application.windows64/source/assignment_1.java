import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import beads.*; 
import java.util.LinkedList; 
import java.util.Calendar; 
import java.util.Date; 
import java.text.SimpleDateFormat; 
import java.util.LinkedList; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class assignment_1 extends PApplet {




// global values for ambient sound
AudioContext ac;
Gain gain;

// global values for mute button
ControlP5 cp5;
boolean muteToggle = false;

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
int bColour;
int pColour;

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
float easing = 0.05f;
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


public void setup() {
  
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
  System.out.println(row.getString(0) + " yes");
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

  // setup for ambient sound
  ac = AudioContext.getDefaultContext();
  sound();

  // setup for mute button
  cp5 = new ControlP5(this);

  cp5.addToggle("muteToggle")
    .setPosition(50, 50)
    .setSize(80, 50)
    .setValue(false)
    .setColorBackground(color(0xff2904C4))
    .setColorForeground(color(0xff3BB0FC))
    .setColorActive(color(0xffFC3B3B))
    .setCaptionLabel("Mute")
    .setColorCaptionLabel(0)

    ;
}

Building building;

public void draw() {
  noStroke();
  
  backgroundColour();

  building = new Building();
  //int personCounter = persons.size();

  drawCircles(building);


   // set gain based off of number of people, or 0 if mute button is activated
  if(muteToggle == true){
    gain.setGain(0);
  }
  else {
  gain.setGain(calendar.peopleCountAverage/10);
  }

  noStroke();

  //Amend the color background function
  // calendar.airTempAverage
  // calendar.peopleCountAverage


  fill(255);
  circle (width/2, height/2, 300);
  image(icon, width/2, height/2, 200, 200);

  noFill();
  drawTempGraph(minamount, maxamount);
  drawTempXLabels();
  drawTempYLabels();

  noFill();
  drawPeopleGraph(pMinAmount, pMaxAmount);
  drawPeopleXLabels();
  drawPeopleYLabels();
  
  rectMode(CORNER);
  fill(0);
  calendar.drawCalendar();
  fill(255);
  rectMode(CENTER);
    
  textSize(18);
  textAlign(CENTER);
  text("Average Temp of the Day: "+ round(calendar.airTempAverage) + "°C", width/2 + width/4.5f, height/2 + height/5);
  textAlign(CORNER);
  text("Average No. People Entering B11 a Day Per 30 minutes: "+ calendar.peopleCountAverage, width/2 - width/2.5f, height/2 + height/5);
}


public void drawCircles(Building building) {
  personCount = calendar.peopleCountAverage;
  
  if(personCount != 0) {
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
  }
}


public void mouseClicked() {
  if(mouseX >= width - width/16.5f && mouseX <= width - width/20 + 15 && mouseY >= 50 && mouseY <= 50 + 30) {
    calendar.isPaused = !calendar.isPaused;
  }

  if (calendar.isDateText == true && mouseX >= calendar.translateX + 55 && mouseX <= calendar.translateX + 230
    && mouseY <= 70) calendar.toggleDate();


  if (!calendar.isDateText) {
    for (Day day : calendar.dayObjects) {
      if (mouseX >= day.getDetranslatedX() && mouseX <= day.getDetranslatedX() + day.getWidth()
        && mouseY >= day.getDetranslatedY() && mouseY <= day.getDetranslatedY() + day.getHeight()) {
        day.handleClick();
        persons.clear();
        circles = 0;
        drawCircles(building);
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
class Building { //center circle to bounce off
  float x = width/2, y = height/2;
  float radius = 300;
  float vx = 0, vy = 0;
  PVector position = new PVector(x, y);
  public void display() {
    noFill();
    circle (x, y, radius);
    image(icon, x, y, 200, 200);
  }
}
class Button {
  float x, y;
  String type;
  CalendarTimelapse parent;
  float detranslatedX;
  float detranslatedY;
  float buttonWidth;
  float buttonHeight = 20;

  public Button(String type, CalendarTimelapse parent, float x, float y) {
    this.type = type;
    this.parent = parent;

    this.x = x;
    this.y = y;
    
    buttonWidth = parent.calendarSize/7;

    detranslatedX = parent.detranslateCoordinate(x, y)[0];
    detranslatedY = parent.detranslateCoordinate(x, y)[1];
  }

  public float getDetranslatedX() {
    return detranslatedX;
  }

  public float getDetranslatedY() {
    return detranslatedY;
  }

  public float getWidth() {
    return buttonWidth;
  }

  public float getHeight() {
    return buttonHeight;
  }

  public void handleButton() {
    if (this.type == "NEXT") parent.viewNextMonth();
    if (this.type == "PREV") parent.viewPreviousMonth();
    if (this.type == "CLOSE") parent.toggleDate();
  }

  public void drawButton() {
    fill(240);
    rect(x, y, buttonWidth, buttonHeight);
    fill(0);
    textSize(10);
    textAlign(CENTER);
    text(type, x + buttonWidth/2, y + buttonHeight/1.6f);
    textAlign(CORNER);
  }

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }
}
class Day {
  String date;
  float x, y;
  float deTranslatedX, deTranslatedY;
  float widthHeight;
  int dayIndex;
  int monthIndex;
  CalendarTimelapse parent;
  boolean isCurrentTime = false;
  boolean isHovered = false;
  int fill = color(0, 0, 255);

  public Day(int dayIndex, int monthIndex, float x, float y, float widthHeight, CalendarTimelapse parent) {
    this.x = x;
    this.y = y;
    this.parent = parent;
    this.dayIndex = dayIndex;
    this.monthIndex = monthIndex;
    this.widthHeight = widthHeight;
    this.deTranslatedX = parent.detranslateCoordinate(x, y)[0];
    this.deTranslatedY = parent.detranslateCoordinate(x, y)[1];

    if (parent.getCalendar().get(Calendar.DAY_OF_MONTH) == dayIndex) {
      isCurrentTime = true;
    }

    drawDay();
  }

  public float getWidth() {
    return widthHeight;
  }

  public float getHeight() {
    return widthHeight;
  }

  public float getDetranslatedX() {
    return deTranslatedX;
  }

  public float getDetranslatedY() {
    return deTranslatedY;
  }

  public void handleClick() {
    parent.handleDateChange(dayIndex, monthIndex);
  }

  public void handleHover() {
    isHovered = true;
  }

  public void handleUnhover() {
    isHovered = false;
  }

  public void drawDay() {
    if (parent.getCalendar().get(Calendar.DAY_OF_MONTH) == dayIndex) {
      isCurrentTime = true;
    }
    else isCurrentTime = false;
    
    if (isCurrentTime && !parent.getIsBrowse()) fill = color(255, 0, 0);
    else fill = color(255);
    
    fill(fill);
    rect(x, y, widthHeight, widthHeight);
    fill(0);

    textAlign(CENTER);
    text(dayIndex, x + widthHeight/2, y + widthHeight/2);
    textAlign(CORNER);
  }
}
class Person {

  float vx = 0;
  float vy = 0;

  PVector position;

  float radius, m;
  

  Person(float x, float y, float r_) {
    position = new PVector(x, y);
    radius = r_;
  }

  public void checkCollision(Building building) { //copied from bouncing balls from processing examples
    PVector distanceVect = PVector.sub(building.position, position);
    float distanceVectMag = distanceVect.mag();

    float minDistance = radius + 190;

    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0f;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      building.position.add(correctionVector);
      position.sub(correctionVector);

      float theta  = distanceVect.heading();

      float sine = sin(theta);
      float cosine = cos(theta);

      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      building.position.x = position.x + bFinal[1].x;
      building.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);
    }
  }

  public void display() {
    stroke(255);
    strokeWeight(1);
    fill(100);
    ellipse(position.x, position.y, radius*2, radius*2);
  }

  public void move() { //move people circles towards center
    if (abs(width/2 - position.x) > 0.1f) {
      position.x = position.x + (width/2 - position.x) * easing;
    }
    if (abs(height/2 - position.y) > 0.1f) {
      position.y = position.y + (height/2- position.y) * easing;
    }
  }

}
public void sound() {
  // load sample
  String audioFileName = sketchPath("") +  "data/326016__vincepest11__ambiance-food-market.wav";
  
  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
  
  Envelope rate = new Envelope(ac, 1);
  player.setRate(rate);
  
  player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  gain = new Gain(2, 1.0f);
  
  gain.addInput(player);
  ac.out.addInput(gain);
  ac.start(); 
}
float x1; 
float x2;
float pATA; 
float y1;

Table accurateAirTemp = new Table();


public void setUpTempGraph() { 
  X1 = width/2 + width * 1/20; 
  Y1 = height/2 + height * 5/20; 
  X2 = width - width * 2/20;
  Y2 = height - height * 2/20;
  x1 = X1;
  y1 = Y1;


  Calendar calendarForAirTemp = Calendar.getInstance();
  calendarForAirTemp.set(2019, 6, 14);

  SimpleDateFormat sdf = calendar.sdfAirTemp;

  accurateAirTemp = new Table();
  accurateAirTemp.addColumn("date");
  accurateAirTemp.addColumn("airTemp");

  float sum = 0;
  int numberOfRows = 0;
  float average;

  for (int i = 0; i < 171; ++i) {
    sum = 0;
    numberOfRows = 0;
    average = 0;
    for (TableRow row : temperature.matchRows(getTextOfDate(sdf, calendarForAirTemp) + ".*", 0)) {
      sum += Double.parseDouble((row.getString(1)));
      numberOfRows++;
    }
    if (sum != 0)average = sum/numberOfRows;
    TableRow row = accurateAirTemp.addRow();
    row.setString("date", getTextOfDate(sdf, calendarForAirTemp));
    row.setFloat("airTemp", average);
    calendarForAirTemp.add(Calendar.DAY_OF_YEAR, 1);
  }

  minamount = 100000000;
  maxamount = 0;
  for (TableRow row : accurateAirTemp.rows()) {
    if (row.getInt("airTemp") < minamount ) minamount = row.getFloat("airTemp");
    if (row.getInt("airTemp") > maxamount) maxamount = row.getFloat("airTemp");

    System.out.println("Date: " + row.getString("date") + " Count: " + row.getFloat("airTemp"));
    System.out.println(minamount + " " + maxamount);
  }
}

public void drawTempGraph(float yMin, float yMax) {
  stroke(255);

  strokeWeight(1);


  beginShape();

  int i = 0;


  for (TableRow row : accurateAirTemp.rows()) { //have to minus 4 as or else there is a 0.0 at the end

    float x = map(i++, 0, accurateAirTemp.getRowCount(), X1, X2);

    float y = map(row.getInt("airTemp"), yMin, yMax, Y2, Y1);

    vertex(x, y);
  }
  endShape();

  fill(255);

  textSize(18);

  textAlign(LEFT);

  text("Average Air Temperature (July - December 2019)", X1, Y1 - 10);
  textSize(10);
  textAlign(RIGHT, BOTTOM);
  text("Source: FEIT EIF Researcher Interface (eif-research.feit.uts.edu.au) ", width-10, height-10);
}

public void drawTempXLabels() {
  fill(255);

  textSize(20);

  textAlign(CENTER);


  String[] months = {"July", "August", "September", "October", "November", "December"};

  float xJuly = 0;
  float xAugust = xJuly + 18;
  float xSept = xAugust + 31;
  float xOct = xSept + 30;
  float xNov = xOct + 31;
  float xDec = xNov + 30;

  float[] xMonths = {xJuly, xAugust, xSept, xOct, xNov, xDec};

  for (int i=0; i< months.length; i++) {

    float x = map(xMonths[i], 0, 171, X1, X2);

    text(months[i], x, Y2+30);

    strokeWeight(0.3f);

    line(x, Y2, x, Y1);
  }

  textSize(18);

  textAlign(CENTER, TOP);

  text("Months", width/2 + width * 4.5f/20, Y2 + 40);
}

public void drawTempYLabels() {
  fill(255);
  textSize(10);
  textAlign(RIGHT);
  stroke(255);
  for (float i = minamount; i <= maxamount; i++ ) {
    float y = map(i, minamount, maxamount, Y2, Y1);
    text(floor(i), X1-10, y);
    line(X1, y, X1 -5, y);
    ++i;
    ++i;
  }
  textSize(18);
  text("°C", X1-30, height - height * 3.25f/20);
}

public void drawLines() {
  float dayIndex = calendar.dayIndexForLine - 195;
  float xPosPeople = map(dayIndex, 0, 171, PX1, PX2);
  float xPosAirTemp = map(dayIndex, 0, 171, X1, X2);

  strokeWeight(3);
  line(xPosPeople, Y1, xPosPeople, Y2);
  line(xPosAirTemp, PY1, xPosAirTemp, PY2);
  //text(currentPeopleAverage, x2, PY2+5);
}


float temp;
//float prev;

float r = 150;
float g = 100;
float b = 150;

LinkedList<Float> list = new LinkedList<Float>();

public void backgroundColour() { 

  temp = calendar.airTempAverage;
  //list.add(temp);

  //if (list.size() == 2) {

  //  list.remove(0);

  //}

  //println(list); 
  //prev = list.get(0);

  background(r, g, b);

  if (temp > 25) {
    r = r + 1;
    b = b - 1;
  } else {
    r = r - 1;
    b = b + 1;
  }


  if ( r > 200) {
    r = 200;
  } else if (r < 100) {
    r = 100;
  }

  if ( b > 255) {
    b = 255;
  } else if (b < 100) {
    b = 100;
  }




  
}


/*void updateArray() { // checks if all persons in the array are gone. need to and time for when the count is 0 
  if (persons.size() == 0) { //once all gone increases count and startX.
    String[] splitDate = split(row.getString(0), '/');
    //println(splitDate[0], " ", lastDate[0]);
    if (int(splitDate[0]) == int(lastDate[0])) { // if the date is the same as the pervious date,
      inCount = inCount + row.getInt(1); //add the value to the count
      index++; //increases index to the next row
      row = peopleCount.getRow(index);
    } else {  //if the dates are different,
      //println(row.getString(0), " ", count); //debugging to see if the count is working
      lastDate = split(row.getString(0), '/'); //changes last date to the new date 
      startX1 = -50; //startX has to be updated as else it continues to get further and further back.
      startX2 = width/2;
      inCount = inCount /10; //divides the count by 10 so each dot represents 10 people
      //println(index / 48, " ", inCount); //debugging to show where we are in the table and current count size
      for (int i = 0; i < inCount; i++) { //creates new persons according to the new count.
        persons.add(new Person(startX1, startY, speed, personSize)); 
        startX1 = startX1 - 50;
      }

      /* for (int i = 0; i < outCount; i++) { //does the same but for people leaving
       persons.add(new Person(startX2, startY, speed, personSize)); 
       startX2 = startX2 - 50; 
       }*/
  //  }

/*
    index++;
    row = peopleCount.getRow(index);
    tempRow = temperature.getRow(index);
  }
}
*/
 //<>// //<>//





class CalendarTimelapse {
  float dayIndexForLine;

  boolean isPaused = false;

  int peopleCountAverage;
  float airTempAverage;

  Table peopleCounter = loadTable("peopleCount.csv");
  Table airTemp = loadTable("airTemp.csv");

  Table peopleTimelapse = new Table();

  Calendar calendar = (Calendar) Calendar.getInstance();
  Calendar calendarForBrowsing = (Calendar) Calendar.getInstance();

  Calendar calMinLimit = (Calendar) Calendar.getInstance();
  Calendar calMaxLimit = (Calendar) Calendar.getInstance();

  SimpleDateFormat sdf;
  SimpleDateFormat sdfAirTemp;
  int monthIndexForBrowsing;
  boolean isDateText = true;
  boolean isBrowse = false;
  int calendarSize = 280;

  float translateX = width/2 - calendarSize/2;
  float translateY = 50;

  int timelapseModulo = 250;
  int timelapseIncrement = 1;

  boolean isntTimelapse;


  LinkedList<Day> dayObjects = new LinkedList<Day>();


  Button nextButton = new Button("NEXT", this, calendarSize - calendarSize/7, 0 - calendarSize/7);
  Button prevButton = new Button("PREV", this, 0, 0 - calendarSize/7);
  Button closeButton = new Button("CLOSE", this, calendarSize - calendarSize/7, calendarSize - 35);

  CalendarTimelapse() {
    calendar.set(2019, 6, 14, 0, 0);
    calendarForBrowsing.set(2019, 6, 14, 0, 0);
    calMinLimit.set(2019, 7, 12);
    calMaxLimit.set(2019, 11, 31, 0, 0);

    sdf = new SimpleDateFormat("d/MM/y");
    sdfAirTemp = new SimpleDateFormat("y-MM-d");

    System.out.println(getTextOfDate(sdf) + " " + getTextOfDay());
    System.out.println(calendar.get(Calendar.MONTH));

    monthIndexForBrowsing = calendarForBrowsing.get(Calendar.MONTH);

    updatePeopleCounter();

    updateAirTemp();

    dayIndexForLine = calendar.get(Calendar.DAY_OF_YEAR);
  }
  boolean isAnimating = false;
  boolean endTimelapse = false;
  public void timelapse() {
    if ((timelapseIncrement % timelapseModulo) == 0) {
      isntTimelapse = true;
    } else {
      isntTimelapse = false;
    }
    if (isntTimelapse) {
      System.out.println(endTimelapse);
      if (calendar.get(Calendar.DAY_OF_YEAR) != 365 && !isAnimating) {
        calendar.add(Calendar.DAY_OF_MONTH, 1);
        calendarForBrowsing.add(Calendar.DAY_OF_MONTH, 1);
        updatePeopleCounter();
        updateAirTemp();
        dayIndexForLine = calendar.get(Calendar.DAY_OF_YEAR);
        timelapseIncrement = 1;
      }
    } else {
      if (!isPaused) timelapseIncrement++;
    }
  }

  public void drawPausePlay() {
    fill(0);
    if (!isPaused) {
      rect(width - width/16.5f, 50, 10, 30);
      rect(width - width/20, 50, 10, 30);
    } else {
      beginShape();
      vertex(width - width/16.5f, 50);
      vertex(width - width/20 + 15, 65);
      vertex(width - width/16.5f, 80);
      endShape(CLOSE);
    }
  }

  public void updatePeopleCounter() {
    int sum = 0;
    int numberOfRows = 0;
    int average = 0;

    for (TableRow row : peopleCounter.matchRows(getTextOfDate(sdf) + ".*", 0)) {
      sum += Integer.parseInt((row.getString(1)));
      ++numberOfRows;
    }

    if (sum != 0) average = sum/numberOfRows;
    peopleCountAverage = average;

    System.out.println(getTextOfDate(sdf));
    System.out.println("People counter average: " + peopleCountAverage);


    //System.out.println("People count: " + getTextOfDate(sdf) + " " + sum + " " + numberOfRows + " " + average);
  }

  public int getPeopleCount() {
    return peopleCountAverage;
  }

  public void updateAirTemp() {
    float sum = 0;
    int numberOfRows = 0;
    float average = 0;

    for (TableRow row : airTemp.matchRows(getTextOfDate(sdfAirTemp) + ".*", 0)) {
      sum += Double.parseDouble((row.getString(1)));
      ++numberOfRows;
    }

    if (sum != 0) average = sum/numberOfRows;
    airTempAverage = average;
    dayIndexForLine = calendar.get(Calendar.DAY_OF_YEAR);


    System.out.println(getTextOfDate(sdf));
    System.out.println("Air temp average: " + airTempAverage);

    //System.out.println("Air temp: " + getTextOfDate(sdf) + " " + sum + " " + numberOfRows + " " + average);
  }

  public Boolean getIsBrowse() {
    return isBrowse;
  }

  public Calendar getCalendar() {
    return calendar;
  }

  public Button getButton(String type) {
    switch(type) {
    case "NEXT": 
      return nextButton;
    case "PREV": 
      return prevButton;
    case "CLOSE": 
      return closeButton;
    default: 
      return null;
    }
  }

  public String getTextOfDate(SimpleDateFormat sdf) {
    return sdf.format(calendar.getTime());
  }

  public void drawDate() {
    textSize(30);
    textAlign(CENTER);
    text(getTextOfDate(sdf), width/2, translateY);
  }

  public String getTextOfMonth(int monthIndex) {
    switch(monthIndex) {
    case 0:
      return "January";
    case 1:
      return "February";
    case 2:
      return "March";
    case 3:
      return "April";
    case 4:
      return "May";
    case 5:
      return "June";
    case 6:
      return "July";
    case 7:
      return "August";
    case 8:
      return "September";
    case 9:
      return "October";
    case 10:
      return "November";
    case 11:
      return "December";
    }

    return "";
  }

  public String getTextOfDay() {

    int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);

    if (dayOfWeek == Calendar.SUNDAY) return "Sunday";
    if (dayOfWeek == Calendar.MONDAY) return "Monday";
    if (dayOfWeek == Calendar.TUESDAY) return "Tuesday";
    if (dayOfWeek == Calendar.WEDNESDAY) return "Wednesday";
    if (dayOfWeek == Calendar.THURSDAY) return "Thursday";
    if (dayOfWeek == Calendar.FRIDAY) return "Friday";
    if (dayOfWeek == Calendar.SATURDAY) return "Saturday";

    return "";
  }

  public int getDayOfWeek(int dayOfWeek) {

    if (dayOfWeek == Calendar.SUNDAY) return Calendar.SUNDAY;
    if (dayOfWeek == Calendar.MONDAY) return Calendar.MONDAY;
    if (dayOfWeek == Calendar.TUESDAY) return Calendar.TUESDAY;
    if (dayOfWeek == Calendar.WEDNESDAY) return Calendar.WEDNESDAY;
    if (dayOfWeek == Calendar.THURSDAY) return Calendar.THURSDAY;
    if (dayOfWeek == Calendar.FRIDAY) return Calendar.FRIDAY;
    if (dayOfWeek == Calendar.SATURDAY) return Calendar.SATURDAY;

    return -1;
  }


  public void drawMonth() {
    drawDays(); 
    if (calendar.get(Calendar.MONTH) == calendarForBrowsing.get(Calendar.MONTH)) isBrowse = false;
    else isBrowse = true;
    textAlign(CENTER);
    fill(0);
    textSize(15);
    if (isBrowse) text(getTextOfMonth(calendarForBrowsing.get(Calendar.MONTH)), calendarSize/2, 0 - 30);
    else {
      text(getTextOfMonth(calendar.get(Calendar.MONTH)), calendarSize/2, 0 - 30);
    }
    textAlign(CORNER);
  }

  int track = 1;

  public void drawDays() {
    textSize(10);
    fill(255);
    stroke(0);

    dayObjects.clear();

    int numberOfDays = isBrowse ? calendarForBrowsing.getActualMaximum(Calendar.DAY_OF_MONTH) :  calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
    int dayIndex = 1;

    int widthHeight = calendarSize/7;
    int x = 0;
    int y = 0;

    Calendar firstDayOfMonthCal = Calendar.getInstance();
    Calendar calendarTemp;
    if (isBrowse) calendarTemp = calendarForBrowsing;
    else calendarTemp = calendar;

    firstDayOfMonthCal.set(2019, calendarTemp.get(Calendar.MONTH), 1);
    if (calendar.get(Calendar.DAY_OF_MONTH) == 1) {
      dayObjects.clear();
    }

    for (int i = 0; i < 6; ++i) {
      for (int j = 1; j <= 7; ++j, ++track) {
        rect(x, y, widthHeight, widthHeight);
        stroke(0);
        fill(0);

        if (getDayOfWeek(firstDayOfMonthCal.get(Calendar.DAY_OF_WEEK)) <= track ) {
          if (dayIndex <= numberOfDays) {
            if (dayObjects.size() < numberOfDays) dayObjects.push(new Day(dayIndex, monthIndexForBrowsing, x, y, widthHeight, this));
            for (Day day : dayObjects) {
              day.drawDay();
            }
            ++dayIndex;
          }
        }
        fill(255);
        x += widthHeight;
      }
      x = 0;
      y += widthHeight;
    }
    track = 1;
    fill(0);
    float xDay = x + widthHeight/4;
    float yDay = -5;

    text("Sun", xDay, yDay);
    text("Mon", xDay + widthHeight, yDay);
    text("Tues", xDay + widthHeight*2, yDay);
    text("Wed", xDay + widthHeight*3, yDay);
    text("Thurs", xDay + widthHeight*4, yDay);
    text("Fri", xDay + widthHeight*5, yDay);
    text("Sat", xDay + widthHeight*6, yDay);

    fill(255);
  }


  public void drawCalendar() {
    timelapse();
    drawLines();
    if (isDateText) drawDate(); 

    drawPausePlay();
    pushMatrix();
    translate(translateX, translateY);
    if (!isDateText)
    {
      drawMonth();
      nextButton.drawButton();
      prevButton.drawButton();
      closeButton.drawButton();
    }
    popMatrix();
  }

  public void toggleDate() {
    isDateText = !isDateText;
    if (!isDateText) calendarForBrowsing.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));
  }


  public float[] detranslateCoordinate(float x, float y) {
    float translatedXY[] =  new float[2];

    translatedXY[0] = translateX  + x;
    translatedXY[1] = translateY + y;

    return translatedXY;
  }

  public void handleDateChange(int dayIndex, int monthIndex) {
    calendar.set(2019, monthIndex, dayIndex);
    calendarForBrowsing.set(2019, monthIndex, dayIndex);

    isBrowse = false;
    timelapseIncrement = 1;

    updatePeopleCounter();
    updateAirTemp();
  }

  public void viewNextMonth() {
    dayObjects.clear();
    if (calendarForBrowsing.get(Calendar.MONTH) + 1 != 12) {
      calendarForBrowsing.add(Calendar.MONTH, 1);
      monthIndexForBrowsing = calendarForBrowsing.get(Calendar.MONTH);
    }
  }

  public void viewPreviousMonth() {
    dayObjects.clear();
    if (calendarForBrowsing.after(calMinLimit)) {
      System.out.println("YES I AM");
      calendarForBrowsing.add(Calendar.MONTH, -1);
      monthIndexForBrowsing = calendarForBrowsing.get(Calendar.MONTH);
      System.out.println(calendarForBrowsing.getTime());
    }
  }
}
int pCount = 0;

float pAvg;

float Px; 

Table accuratePeopleCount = new Table();


public String getTextOfDate(SimpleDateFormat sdf, Calendar calendar) {
  return sdf.format(calendar.getTime());
}

public void setUpPersonGraph() {

  PX1 = 0 + width * 2/20; 

  PY1 = height/2 + height * 5/20;

  PX2 = width/2 - width * 1/20; 

  PY2 = height - height * 2/20;

  x2 = PX1;


  //pAmount = new float[161]; // how many days there are betweem july 14th and january 1st. Has to be hard coded as the amount of rows in each day is different between days

  Calendar calendarForPeople = Calendar.getInstance();
  calendarForPeople.set(2019, 6, 14);

  SimpleDateFormat sdf = calendar.sdf;

  accuratePeopleCount = new Table();
  accuratePeopleCount.addColumn("date");
  accuratePeopleCount.addColumn("people");

  int sum = 0;
  int numberOfRows = 0;
  int average;

  for (int i = 0; i < 171; ++i) {
    sum = 0;
    numberOfRows = 0;
    average = 0;
    for (TableRow row : peopleCount.matchRows(getTextOfDate(sdf, calendarForPeople) + ".*", 0)) {
      sum += Integer.parseInt((row.getString(1)));
      numberOfRows++;
    }
    if (sum != 0)average = sum/numberOfRows;
    TableRow row = accuratePeopleCount.addRow();
    row.setString("date", getTextOfDate(sdf, calendarForPeople));
    row.setFloat("people", average);
    calendarForPeople.add(Calendar.DAY_OF_YEAR, 1);
  }

    pMinAmount = 100000000;
    pMaxAmount = 0;
  for (TableRow row : accuratePeopleCount.rows()) {
    if(row.getInt("people") < pMinAmount ) pMinAmount = row.getInt("people");
    if(row.getInt("people") > pMaxAmount) pMaxAmount = row.getInt("people");

  }


 // for (int i=0; i<accuratePeopleCount.getRowCount(); i++) {
    /* String[] date = split(row.getString(0), '/');
     
     //System.out.println(row.getString(0));
     
     //println(tempDate[0], " ", lastDate[0]);
     
     if (int(date[0]) == int(lastDate[0])) {
     
     //println(row.getFloat(1));
     
     pSum = pSum + row.getFloat(1);
     
     pCount++;
     } else {
     
     pAvg = pSum / pCount;
     
     pAmount[Py] = pAvg;
     
     Py++;
     
     pSum = 0;
     
     pCount = 0;
     
     lastDate[0] = date[0];
     }
     
     pIndex++; 
     
     row = peopleCount.getRow(pIndex);
     }
     
     
     pMinAmount = min(pAmount);
     
     pMaxAmount = max(pAmount);
     */
  }



  public void drawPeopleGraph(float yMin, float yMax) {
    stroke(255);

    strokeWeight(1);


    beginShape();

    int i = 0;
    
    
    for (TableRow row : accuratePeopleCount.rows()) { //have to minus 4 as or else there is a 0.0 at the end
      
      float x = map(i++, 0, accuratePeopleCount.getRowCount(), PX1, PX2);

      float y = map(row.getInt("people"), yMin, yMax, PY2, PY1);

      vertex(x, y);     
    }
    endShape();

    fill(255);

    textSize(18);

    textAlign(LEFT);

    text("Average People Count (July - December 2019)", PX1, PY1 - 10);
  }


  public void drawPeopleXLabels() {

    fill(255);

    textSize(20);

    textAlign(CENTER);


    String[] months = {"July", "August", "September", "October", "November", "December"};

    float xJuly = 0;
    float xAugust = xJuly + 18;
    float xSept = xAugust + 31;
    float xOct = xSept + 30;
    float xNov = xOct + 31;
    float xDec = xNov + 30;

    float[] xMonths = {xJuly, xAugust, xSept, xOct, xNov, xDec};

    for (int i=0; i< months.length; i++) {

      float x = map(xMonths[i], 0, 171, PX1, PX2);

      text(months[i], x, PY2+30);

      strokeWeight(0.3f);

      line(x, PY2, x, PY1);
    }

    textSize(18);

    textAlign(CENTER, TOP);

    text("Months", width/2 - width * 4.5f/20, PY2 + 40);
  }


  public void drawPeopleYLabels() {

    fill(255);

    textSize(10);

    textAlign(RIGHT);

    stroke(255);

    for (float i = pMinAmount; i <= pMaxAmount; i += 5) {

      float y = map(i, pMinAmount, pMaxAmount, Y2, Y1);

      text(floor(i), PX1-10, y);
      line(PX1, y, PX1 -5, y);
    }

    textSize(18);

    text("People", PX1 - 30, height - height * 3.25f/20);
  }
  public void settings() {  fullScreen(1); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "assignment_1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
