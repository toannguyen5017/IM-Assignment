int count; //increase or decrease the amoount of people
int index = 0; //starts the count at the first row 
float personSize = 30; //changes the size
int startX = -30;
int startY; //have to be hard coded as size isn't set till after this is declared
int speed = 15; //
String[] lastDate;
TableRow row;
ArrayList <Person> persons = new ArrayList <Person>();
Table peopleCount;

void setup() {
  fullScreen();
  ellipseMode(CENTER);
  rectMode(CENTER);

  peopleCount = loadTable("peopleCount.csv"); //produces the table
  row = peopleCount.getRow(index); 
  String[] splitlast = split(row.getString(0), ' ');
  lastDate = split(splitlast[1], ':');
  startY = height / 2;
}

void draw() {
  noStroke();
  background(255); 

  fill(1);
  circle(width/2, height/2, 100);
  updateArray();

  for (Person person : persons) {
    person.personMove(); 
    person.display();
  }

  for (int i = 0; i < persons.size(); i++) { //goes through each person and checks if they are passed 500, if so removes it. seperate from other for loop as it need i to find the position in the array
    Person checkPerson = persons.get(i);
    if (checkPerson.finished()) {
      persons.remove(i);
    }
  }
  if (index / 2 == 365) {
    println("done!");
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
      count = count /10; 
      println(index / 48, " ", count);
      for (int i = 0; i < count; i++) { //creates new persons according to the new count.
        persons.add(new Person(startX, startY, speed, personSize)); 
        startX = startX - 50;
      }
      index++;
      row = peopleCount.getRow(index);
    }
  }
}
