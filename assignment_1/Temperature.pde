float diff;

void backgroundColour() { 
  tempRow = temperature.getRow(tempIndex);
  float temp = tempRow.getFloat(1);
  
  if (temp == lastTemp) {
    R = temp; 
    B = temp;
  } else if (temp > lastTemp) {
    diff = temp - lastTemp; 
    R = PR + diff;
    B = PB - diff;
  } else if (temp < lastTemp) {
    diff = lastTemp - temp; 
    B = PB + diff;
    R = PR - diff;
  }
  bColour = color(map(R, -2000, 2000 ,0,255), 0, map(B, -2000, 2000, 0, 255));
  background(bColour);
  println(R, " ", B);
  PR = R;
  PB = B;
  tempIndex++;
}
