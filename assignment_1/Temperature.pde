float temp;
float diff;
void backgroundColour() { 
  //gets the temp
  tempRow = temperature.getRow(tempIndex);
  temp = tempRow.getFloat(1);
  if (temp > lastTemp) {
    diff = temp - lastTemp;  
    R = PR + diff;
    B = PB - diff;
  } else if (temp < lastTemp) {
    diff = lastTemp - temp; 
    B = PB + diff;
    R = PR - diff;
  }
  bColour = color(map(R, -2000, 2000, 0, 255), 0, map(B, -2000, 2000, 0, 255));
  //bolour = color(R,0,B);
  background(bColour);
  println(R, " ", B, diff);
  PR = R;
  PB = B;
  tempIndex++;
}
