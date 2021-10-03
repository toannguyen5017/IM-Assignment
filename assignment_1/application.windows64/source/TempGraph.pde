float x1; 
float x2;
float pATA; 
float y1;

Table accurateAirTemp = new Table();


void setUpTempGraph() { 
  X1 = width/2 + width * 1/20; 
  Y1 = height/2 + height * 5/20; 
  X2 = width - width * 2/20;
  Y2 = height - height * 2/20;
  x1 = X1;
  y1 = Y1;


  Calendar calendarForAirTemp = Calendar.getInstance();
  calendarForAirTemp.set(2019, 6, 14);

  SimpleDateFormat sdf = calendar.sdfAirTemp;

  accurateAirTemp = new Table();
  accurateAirTemp.addColumn("date");
  accurateAirTemp.addColumn("airTemp");

  float sum = 0;
  int numberOfRows = 0;
  float average;

  for (int i = 0; i < 171; ++i) {
    sum = 0;
    numberOfRows = 0;
    average = 0;
    for (TableRow row : temperature.matchRows(getTextOfDate(sdf, calendarForAirTemp) + ".*", 0)) {
      sum += Double.parseDouble((row.getString(1)));
      numberOfRows++;
    }
    if (sum != 0)average = sum/numberOfRows;
    TableRow row = accurateAirTemp.addRow();
    row.setString("date", getTextOfDate(sdf, calendarForAirTemp));
    row.setFloat("airTemp", average);
    calendarForAirTemp.add(Calendar.DAY_OF_YEAR, 1);
  }

  minamount = 100000000;
  maxamount = 0;
  for (TableRow row : accurateAirTemp.rows()) {
    if (row.getInt("airTemp") < minamount ) minamount = row.getFloat("airTemp");
    if (row.getInt("airTemp") > maxamount) maxamount = row.getFloat("airTemp");

    System.out.println("Date: " + row.getString("date") + " Count: " + row.getFloat("airTemp"));
    System.out.println(minamount + " " + maxamount);
  }
}

void drawTempGraph(float yMin, float yMax) {
  stroke(255);

  strokeWeight(1);


  beginShape();

  int i = 0;


  for (TableRow row : accurateAirTemp.rows()) { //have to minus 4 as or else there is a 0.0 at the end

    float x = map(i++, 0, accurateAirTemp.getRowCount(), X1, X2);

    float y = map(row.getInt("airTemp"), yMin, yMax, Y2, Y1);

    vertex(x, y);
  }
  endShape();

  fill(255);

  textSize(18);

  textAlign(LEFT);

  text("Average Air Temperature (July - December 2019)", X1, Y1 - 10);
  textSize(10);
  textAlign(RIGHT, BOTTOM);
  text("Source: FEIT EIF Researcher Interface (eif-research.feit.uts.edu.au) ", width-10, height-10);
}

void drawTempXLabels() {
  fill(255);

  textSize(20);

  textAlign(CENTER);


  String[] months = {"July", "August", "September", "October", "November", "December"};

  float xJuly = 0;
  float xAugust = xJuly + 18;
  float xSept = xAugust + 31;
  float xOct = xSept + 30;
  float xNov = xOct + 31;
  float xDec = xNov + 30;

  float[] xMonths = {xJuly, xAugust, xSept, xOct, xNov, xDec};

  for (int i=0; i< months.length; i++) {

    float x = map(xMonths[i], 0, 171, X1, X2);

    text(months[i], x, Y2+30);

    strokeWeight(0.3);

    line(x, Y2, x, Y1);
  }

  textSize(18);

  textAlign(CENTER, TOP);

  text("Months", width/2 + width * 4.5/20, Y2 + 40);
}

void drawTempYLabels() {
  fill(255);
  textSize(10);
  textAlign(RIGHT);
  stroke(255);
  for (float i = minamount; i <= maxamount; i++ ) {
    float y = map(i, minamount, maxamount, Y2, Y1);
    text(floor(i), X1-10, y);
    line(X1, y, X1 -5, y);
    ++i;
    ++i;
  }
  textSize(18);
  text("°C", X1-30, height - height * 3.25/20);
}

void drawLines() {
  float dayIndex = calendar.dayIndexForLine - 195;
  float xPosPeople = map(dayIndex, 0, 171, PX1, PX2);
  float xPosAirTemp = map(dayIndex, 0, 171, X1, X2);

  strokeWeight(3);
  line(xPosPeople, Y1, xPosPeople, Y2);
  line(xPosAirTemp, PY1, xPosAirTemp, PY2);
  //text(currentPeopleAverage, x2, PY2+5);
}
