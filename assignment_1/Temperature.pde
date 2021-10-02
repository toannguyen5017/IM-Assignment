float temp;
float diff;
float tempAv;
int presentAvTemp;
int count = 0;

void backgroundColour() { 
/*  tempRow = temperature.getRow(index);
  float temp = tempRow.getFloat(1);
  
  //background 
  
  if (temp == lastTemp) {
    R = temp; 
    B = temp;
  } else if (temp > lastTemp) {
    float diff = temp - lastTemp; 
    R = PR + diff;
    B = PB - diff;
  } else if (temp < lastTemp) {
    float diff = lastTemp - temp; 
    B = PB + diff;
    R = PR - diff;
  }

  lastTemp = temp;

  index++;
  */
  bColour = color(map(R, -2000, 2000 , 60, 255), 50, map(B, -2000, 2000, 120, 255));
  background(bColour);
  // println(R, " ", B);
  
  PR = R;
  PB = B;
  
  
  //average
  
  tempAv = tempAv + temp;
  println(temp, " temp");
  count++;
  println(count, " count");
  tempIndex++;
  
  if (count == 287) {
    presentAvTemp = round(tempAv/287);
    
    println(tempAv, " tempAv");
    count = 0;
    tempAv = 0;
  }
  
  textSize(30);
  text("Current Temp: " + temp + " °C", width/3, height/3.5);
  text("Average Temp of the Day: "+ presentAvTemp + " °C" , width/3, height/3);
  
  
}
