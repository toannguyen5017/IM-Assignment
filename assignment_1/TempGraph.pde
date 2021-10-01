void setUpGraph() { 
  X1 = width/2 + 100; 
  Y1 = height/2 + 300;
  X2 = width/2 + 800; 
  Y2 = height/2 + 450;

  amount = new float[167]; // how many days there are betweem july 14th and january 1st. Has to be hard coded as the amount of rows in each day is different between days
  mm = new int[167];


  for (int i=0; i<temperature.getRowCount(); i++) {
    tempSplit = split(tempRow.getString(0), '-');
    String[] tempDate = split(tempSplit[2], ' ');
    if (int(tempDate[0]) == int(lastTempDate[0])) {
      sum = sum + tempRow.getFloat(1);
      tempCount++;
    } else {
      float avg = sum/ tempCount;
      //println("date: ",tempSplit[0],"/",tempSplit[1],"/",tempSplit[2],"/", " sum: ", sum, " count: ", tempCount, " avg: ", avg);
      if (avg > 0) { //had 4 0.0 avgs at the end for some reason this is to filter them out
        amount[y] = avg;
        mm[y] = int(avg);
        y++;
        sum = 0;
        tempCount = 0;
        lastTempDate[0] = tempDate[0];
      }
    }
    graphIndex++; 
    tempRow = temperature.getRow(graphIndex);
  }

  minamount = min(amount);
  maxamount = max(amount);
}

void drawGraph(float[] data, float yMin, float yMax) {
  stroke(255);
  strokeWeight(1);
  beginShape();
  for (int i=0; i < data.length; i++) {
    float x = map(i, 0, data.length-1, X1, X2);
    float y = map(data[i], yMin, yMax, Y2, Y1);
    vertex(x, y);
  }
  endShape();
}

void drawXLabels() {
  fill(255);
  textSize(10);
  textAlign(CENTER);

  String[] months = {"July", "August", "September", "October", "December", "January"};
  for (int i=0; i< months.length; i++) {
    float x = map(i, 0, months.length - 1, X1, X2);
    text(months[i], x, Y2+30);
    strokeWeight(0.3);
    line(x, Y2, x, Y1);
  }
  textSize(18);
  textAlign(CENTER, TOP);
  text("months", width/2 + 450, Y2+40);
}

void drawYLabels() {
  fill(255);
  textSize(10);
  textAlign(RIGHT);
  stroke(255);
  for (float i = minamount; i <= maxamount; i++ ) {
    float y = map(i, minamount, maxamount, Y2, Y1);
    text(floor(i), X1-10, y);
    line(X1, y, X1 -5, y);
  }
  textSize(18);
  text("°C", X1-50, height/2 + 375);
} // drawYLabels()
