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

//Circle Branch
PImage icon;
float easing = 0.05;
int savedTime;
int totalTime = 5000;


CalendarTimelapse calendar;


void setup() {
  fullScreen(1);
  ellipseMode(CENTER);
  rectMode(CENTER);

  calendar = new CalendarTimelapse();

  peopleCount = loadTable("./data/peopleCount.csv"); //produces the table
  row = peopleCount.getRow(index); 
  String[] splitlast = split(row.getString(0), ' ');
  lastDate = split(splitlast[1], ':');

  //Circle branch 
  imageMode(CENTER);
  icon = loadImage("buildingicon.png");
  savedTime = millis();
}


void draw() {
  noStroke();
  background(255); 



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

  rectMode(CORNER);
  calendar.drawCalendar();
  rectMode(CENTER);
}

void updateArray() { // checks if all persons in the array are gone. need to and time for when the count is 0 
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
}

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
