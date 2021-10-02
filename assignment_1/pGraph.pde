void setUpPersonGraph() {
  PX1 = width/2 - 100; 
  PY1 = height/2 + 300;
  PX2 = width/2 - 800; 
  PY2 = height/2 + 450;

  pAmount = new float[161]; // how many days there are betweem july 14th and january 1st. Has to be hard coded as the amount of rows in each day is different between days
for (int i=0; i<peopleCount.getRowCount(); i++) {
    String[] date = split(row.getString(0), '/');
    //println(tempDate[0], " ", lastDate[0]);
    if (int(date[0]) == int(lastDate[0])) {
      //println(row.getFloat(1));
      pSum = pSum + row.getFloat(1);
    } else {
      pAmount[Py] = pSum;
      Py++;
      pSum = 0;
      lastDate[0] = date[0];      
    }
    pIndex++; 
    row = peopleCount.getRow(pIndex);
  }

  pMinAmount = min(pAmount);
  pMaxAmount = max(pAmount);
}

void drawPeopleGraph(float[] data, float yMin, float yMax) {
stroke(255);
  strokeWeight(1);
  beginShape();
 for (int i=0; i < data.length - 4; i++) { //have to minus 4 as or else there is a 0.0 at the end
    float x = map(i, 0, data.length-5, PX1, PX2);
    float y = map(data[i], yMin, yMax, PY2, PY1);
    vertex(x, y);
  }
  endShape();
}

void drawPeopleXLabels() {
 fill(255);
  textSize(10);
  textAlign(CENTER);

  String[] months = {"July", "August", "September", "October", "December", "January"};
  for (int i=0; i< months.length; i++) {
    float x = map(i, 0, months.length - 1, PX1, PX2);
    text(months[i], x, PY2+30);
    strokeWeight(0.3);
    line(x, PY2, x, PY1);
  }
  textSize(18);
  textAlign(CENTER, TOP);
  text("months", width/2 - 450, PY2 + 40);
}

void drawPeopleYLabels() {
  fill(255);
  textSize(10);
  textAlign(RIGHT);
  stroke(255);
  for (float i=pMinAmount; i <= pMaxAmount; i += 200) {
    float y = map(i, pMinAmount, pMaxAmount, PY2, PY1);
    text(floor(i), PX1-710, y);
    line(PX1-700, y, PX1-705, y);
  }
  textSize(18);
  text("People", PX1-740, height/2 + 375);
}
