int inCount; //increase or decrease the amoount of people
int outCount;
int index = 0; //starts the count at the first rowIn 
float personSize = 30; //changes the size
int startX1 = -30;
int startX2; //startX2 and startY have to be delacred in setUp as the height and width isn't set till the program starts because of fullscreen();
int startY; 
int speed = 10; //
String[] lastDate;
TableRow rowIn;
TableRow rowOut;
ArrayList <Person> persons = new ArrayList <Person>();
Table peopleCountIn;
Table peopleCountOut;

void setup() {
  fullScreen();
  ellipseMode(CENTER);
  rectMode(CENTER);
  startY = height / 2;
  startX2 = width / 2;

  peopleCountIn = loadTable("peopleCountIn.csv"); //produces the table of people entering.
  peopleCountOut = loadTable("peopleCountOut.csv"); //produces table of people leaving.
  rowIn = peopleCountIn.getRow(index);
  rowOut = peopleCountIn.getRow(index);
  String[] splitlast = split(rowIn.getString(0), ' ');
  lastDate = split(splitlast[1], ':');
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
