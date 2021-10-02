void updateArray() { // checks if all persons in the array are gone. need to and time for when the count is 0 
  if (persons.size() == 0) { //once all gone increases count and startX.
    count = int(pAmount[index]) / 10; //divides the count by 10 so each dot represents 10 people
    startX1 = -50; //startX has to be updated as else it continues to get further and further back.
    //println(index / 48, " ", inCount); //debugging to show where we are in the table and current count size
    for (int i = 0; i < count; i++) { //creates new persons according to the new count.
      persons.add(new Person(startX1, startY, speed, personSize)); 
      startX1 = startX1 - 50;
      index++;
    }
  }

  tempRow = temperature.getRow(index);
}
