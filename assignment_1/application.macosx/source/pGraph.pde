int pCount = 0;

float pAvg;

float Px; 

Table accuratePeopleCount = new Table();


String getTextOfDate(SimpleDateFormat sdf, Calendar calendar) {
  return sdf.format(calendar.getTime());
}

void setUpPersonGraph() {

  PX1 = 0 + width * 2/20; 

  PY1 = height/2 + height * 5/20;

  PX2 = width/2 - width * 1/20; 

  PY2 = height - height * 2/20;

  x2 = PX1;


  //pAmount = new float[161]; // how many days there are betweem july 14th and january 1st. Has to be hard coded as the amount of rows in each day is different between days

  Calendar calendarForPeople = Calendar.getInstance();
  calendarForPeople.set(2019, 6, 14);

  SimpleDateFormat sdf = calendar.sdf;

  accuratePeopleCount = new Table();
  accuratePeopleCount.addColumn("date");
  accuratePeopleCount.addColumn("people");

  int sum = 0;
  int numberOfRows = 0;
  int average;

  for (int i = 0; i < 171; ++i) {
    sum = 0;
    numberOfRows = 0;
    average = 0;
    for (TableRow row : peopleCount.matchRows(getTextOfDate(sdf, calendarForPeople) + ".*", 0)) {
      sum += Integer.parseInt((row.getString(1)));
      numberOfRows++;
    }
    if (sum != 0)average = sum/numberOfRows;
    TableRow row = accuratePeopleCount.addRow();
    row.setString("date", getTextOfDate(sdf, calendarForPeople));
    row.setFloat("people", average);
    calendarForPeople.add(Calendar.DAY_OF_YEAR, 1);
  }

    pMinAmount = 100000000;
    pMaxAmount = 0;
  for (TableRow row : accuratePeopleCount.rows()) {
    if(row.getInt("people") < pMinAmount ) pMinAmount = row.getInt("people");
    if(row.getInt("people") > pMaxAmount) pMaxAmount = row.getInt("people");

  }


 // for (int i=0; i<accuratePeopleCount.getRowCount(); i++) {
    /* String[] date = split(row.getString(0), '/');
     
     //System.out.println(row.getString(0));
     
     //println(tempDate[0], " ", lastDate[0]);
     
     if (int(date[0]) == int(lastDate[0])) {
     
     //println(row.getFloat(1));
     
     pSum = pSum + row.getFloat(1);
     
     pCount++;
     } else {
     
     pAvg = pSum / pCount;
     
     pAmount[Py] = pAvg;
     
     Py++;
     
     pSum = 0;
     
     pCount = 0;
     
     lastDate[0] = date[0];
     }
     
     pIndex++; 
     
     row = peopleCount.getRow(pIndex);
     }
     
     
     pMinAmount = min(pAmount);
     
     pMaxAmount = max(pAmount);
     */
  }



  void drawPeopleGraph(float yMin, float yMax) {
    stroke(255);

    strokeWeight(1);


    beginShape();

    int i = 0;
    
    
    for (TableRow row : accuratePeopleCount.rows()) { //have to minus 4 as or else there is a 0.0 at the end
      
      float x = map(i++, 0, accuratePeopleCount.getRowCount(), PX1, PX2);

      float y = map(row.getInt("people"), yMin, yMax, PY2, PY1);

      vertex(x, y);     
    }
    endShape();

    fill(255);

    textSize(18);

    textAlign(LEFT);

    text("Average People Count (July - December 2019)", PX1, PY1 - 10);
  }


  void drawPeopleXLabels() {

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

      float x = map(xMonths[i], 0, 171, PX1, PX2);

      text(months[i], x, PY2+30);

      strokeWeight(0.3);

      line(x, PY2, x, PY1);
    }

    textSize(18);

    textAlign(CENTER, TOP);

    text("Months", width/2 - width * 4.5/20, PY2 + 40);
  }


  void drawPeopleYLabels() {

    fill(255);

    textSize(10);

    textAlign(RIGHT);

    stroke(255);

    for (float i = pMinAmount; i <= pMaxAmount; i += 5) {

      float y = map(i, pMinAmount, pMaxAmount, Y2, Y1);

      text(floor(i), PX1-10, y);
      line(PX1, y, PX1 -5, y);
    }

    textSize(18);

    text("People", PX1 - 30, height - height * 3.25/20);
  }
