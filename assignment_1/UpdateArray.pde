void updateArray() { // checks if all persons in the array are gone. need to and time for when the count is 0 
  if (persons.size() == 0) { //once all gone increases count and startX.
    String[] splitDate = split(rowIn.getString(0), '/');
    //println(splitDate[0], " ", lastDate[0]);
    if (int(splitDate[0]) == int(lastDate[0])) {
      inCount = inCount + rowIn.getInt(1);
      outCount = outCount + rowOut.getInt(1);
      index++; //increases index to the next rowIn
      rowIn = peopleCountIn.getRow(index);
      rowOut = peopleCountOut.getRow(index);
    } else {  
      //println(rowIn.getString(0), " ", count); //debugging to see if the count is working
      lastDate = split(rowIn.getString(0), '/');
      //startX1 = -50; //startX has to be updated as else it continues to get further and further back.
      startX2 = width/2;
      inCount = inCount /10; 
      outCount = outCount /10;
      println(index / 48, " ", inCount);
      for (int i = 0; i < inCount; i++) { //creates new persons according to the new count.
        persons.add(new Person(startX1, startY, speed, personSize)); 
        startX1 = startX1 - 50;
      }

      for (int i = 0; i < outCount; i++) { //does the same but for people leaving
          //persons.add(new Person(startX2, startY, speed, personSize)); 
          startX2 = startX2 - 50;
        }
        
      }
      index++;
      rowIn = peopleCountIn.getRow(index);
      rowOut = peopleCountOut.getRow(index);
    }
  }
