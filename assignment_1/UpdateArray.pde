

void updateArray() { // checks if all persons in the array are gone. need to and time for when the count is 0 
  if (persons.size() == 0) { //once all gone increases count and startX.
    String[] splitDate = split(rowIn.getString(0), '/');
    //println(splitDate[0], " ", lastDate[0]);
    if (int(splitDate[0]) == int(lastDate[0])) { // if the date is the same as the pervious date,
      inCount = inCount + rowIn.getInt(1); //add the value to the count
      outCount = outCount + rowOut.getInt(1);
      index++; //increases index to the next row
      rowIn = peopleCountIn.getRow(index);
      rowOut = peopleCountOut.getRow(index);
    } else {  //if the dates are different,
      //println(rowIn.getString(0), " ", count); //debugging to see if the count is working
      lastDate = split(rowIn.getString(0), '/'); //changes last date to the new date 
      startX1 = -50; //startX has to be updated as else it continues to get further and further back.
      startX2 = width/2;
      inCount = inCount /10; //divides the count by 10 so each dot represents 10 people
      outCount = outCount /10;
      println(index / 48, " ", inCount); //debugging to show where we are in the table and current count size
      for (int i = 0; i < inCount; i++) { //creates new persons according to the new count.
        persons.add(new Person(startX1, startY, speed, personSize)); 
        startX1 = startX1 - 50;
      }

      /* for (int i = 0; i < outCount; i++) { //does the same but for people leaving
        persons.add(new Person(startX2, startY, speed, personSize)); 
        //startX2 = startX2 - 50;
      } */
    }
    index++;
    rowIn = peopleCountIn.getRow(index);
    rowOut = peopleCountOut.getRow(index);
    tempRow = temperature.getRow(index);
  }
}
