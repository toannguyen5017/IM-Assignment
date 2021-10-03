import java.util.Calendar; //<>// //<>//
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.LinkedList;


class CalendarTimelapse {
  float dayIndexForLine;

  boolean isPaused = false;

  int peopleCountAverage;
  float airTempAverage;

  Table peopleCounter = loadTable("peopleCount.csv");
  Table airTemp = loadTable("airTemp.csv");

  Table peopleTimelapse = new Table();

  Calendar calendar = (Calendar) Calendar.getInstance();
  Calendar calendarForBrowsing = (Calendar) Calendar.getInstance();

  Calendar calMinLimit = (Calendar) Calendar.getInstance();
  Calendar calMaxLimit = (Calendar) Calendar.getInstance();

  SimpleDateFormat sdf;
  SimpleDateFormat sdfAirTemp;
  int monthIndexForBrowsing;
  boolean isDateText = true;
  boolean isBrowse = false;
  int calendarSize = 280;

  float translateX = width/2 - calendarSize/2;
  float translateY = 50;

  int timelapseModulo = 250;
  int timelapseIncrement = 1;

  LinkedList<Day> dayObjects = new LinkedList<Day>();


  Button nextButton = new Button("NEXT", this, calendarSize - calendarSize/7, 0 - calendarSize/7);
  Button prevButton = new Button("PREV", this, 0, 0 - calendarSize/7);
  Button closeButton = new Button("CLOSE", this, calendarSize - calendarSize/7, calendarSize - 35);

  CalendarTimelapse() {
    calendar.set(2019, 6, 14, 0, 0);
    calendarForBrowsing.set(2019, 6, 14, 0, 0);
    calMinLimit.set(2019, 7, 12);
    calMaxLimit.set(2019, 11, 31, 0, 0);

    sdf = new SimpleDateFormat("d/MM/y");
    sdfAirTemp = new SimpleDateFormat("y-MM-d");

    System.out.println(getTextOfDate(sdf) + " " + getTextOfDay());
    System.out.println(calendar.get(Calendar.MONTH));

    monthIndexForBrowsing = calendarForBrowsing.get(Calendar.MONTH);

    updatePeopleCounter();

    updateAirTemp();

    dayIndexForLine = calendar.get(Calendar.DAY_OF_YEAR);
  }

  void timelapse() {
    if ((timelapseIncrement % timelapseModulo) == 0) {
      if (calendar.get(Calendar.DAY_OF_YEAR) != 365) {
        calendar.add(Calendar.DAY_OF_MONTH, 1);
        calendarForBrowsing.add(Calendar.DAY_OF_MONTH, 1);
        updatePeopleCounter();
        updateAirTemp();
        dayIndexForLine = calendar.get(Calendar.DAY_OF_YEAR);
        timelapseIncrement = 1;
      }
    } else {
      if (!isPaused) timelapseIncrement++;
    }
  }

  void drawPausePlay() {
    fill(0);
    if (!isPaused) {
      rect(width - width/16.5, 50, 10, 30);
      rect(width - width/20, 50, 10, 30);
    } else {
      beginShape();
      vertex(width - width/16.5, 50);
      vertex(width - width/20 + 15, 65);
      vertex(width - width/16.5, 80);
      endShape(CLOSE);
    }
  }

  void updatePeopleCounter() {
    int sum = 0;
    int numberOfRows = 0;
    int average = 0;

    for (TableRow row : peopleCounter.matchRows(getTextOfDate(sdf) + ".*", 0)) {
      sum += Integer.parseInt((row.getString(1)));
      ++numberOfRows;
    }

    if (sum != 0) average = sum/numberOfRows;
    peopleCountAverage = average;

    System.out.println(getTextOfDate(sdf));
    System.out.println("People counter average: " + peopleCountAverage);


    //System.out.println("People count: " + getTextOfDate(sdf) + " " + sum + " " + numberOfRows + " " + average);
  }

  void updateAirTemp() {
    float sum = 0;
    int numberOfRows = 0;
    float average = 0;

    for (TableRow row : airTemp.matchRows(getTextOfDate(sdfAirTemp) + ".*", 0)) {
      sum += Double.parseDouble((row.getString(1)));
      ++numberOfRows;
    }

    if (sum != 0) average = sum/numberOfRows;
    airTempAverage = average;
    dayIndexForLine = calendar.get(Calendar.DAY_OF_YEAR);


    System.out.println(getTextOfDate(sdf));
    System.out.println("Air temp average: " + airTempAverage);

    //System.out.println("Air temp: " + getTextOfDate(sdf) + " " + sum + " " + numberOfRows + " " + average);
  }

  Boolean getIsBrowse() {
    return isBrowse;
  }

  Calendar getCalendar() {
    return calendar;
  }

  Button getButton(String type) {
    switch(type) {
    case "NEXT": 
      return nextButton;
    case "PREV": 
      return prevButton;
    case "CLOSE": 
      return closeButton;
    default: 
      return null;
    }
  }

  String getTextOfDate(SimpleDateFormat sdf) {
    return sdf.format(calendar.getTime());
  }

  void drawDate() {
    textSize(30);
    textAlign(CENTER);
    text(getTextOfDate(sdf), width/2, translateY);
  }

  String getTextOfMonth(int monthIndex) {
    switch(monthIndex) {
    case 0:
      return "January";
    case 1:
      return "February";
    case 2:
      return "March";
    case 3:
      return "April";
    case 4:
      return "May";
    case 5:
      return "June";
    case 6:
      return "July";
    case 7:
      return "August";
    case 8:
      return "September";
    case 9:
      return "October";
    case 10:
      return "November";
    case 11:
      return "December";
    }

    return "";
  }

  String getTextOfDay() {

    int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);

    if (dayOfWeek == Calendar.SUNDAY) return "Sunday";
    if (dayOfWeek == Calendar.MONDAY) return "Monday";
    if (dayOfWeek == Calendar.TUESDAY) return "Tuesday";
    if (dayOfWeek == Calendar.WEDNESDAY) return "Wednesday";
    if (dayOfWeek == Calendar.THURSDAY) return "Thursday";
    if (dayOfWeek == Calendar.FRIDAY) return "Friday";
    if (dayOfWeek == Calendar.SATURDAY) return "Saturday";

    return "";
  }

  int getDayOfWeek(int dayOfWeek) {

    if (dayOfWeek == Calendar.SUNDAY) return Calendar.SUNDAY;
    if (dayOfWeek == Calendar.MONDAY) return Calendar.MONDAY;
    if (dayOfWeek == Calendar.TUESDAY) return Calendar.TUESDAY;
    if (dayOfWeek == Calendar.WEDNESDAY) return Calendar.WEDNESDAY;
    if (dayOfWeek == Calendar.THURSDAY) return Calendar.THURSDAY;
    if (dayOfWeek == Calendar.FRIDAY) return Calendar.FRIDAY;
    if (dayOfWeek == Calendar.SATURDAY) return Calendar.SATURDAY;

    return -1;
  }


  void drawMonth() {
    drawDays(); 
    if (calendar.get(Calendar.MONTH) == calendarForBrowsing.get(Calendar.MONTH)) isBrowse = false;
    else isBrowse = true;
    textAlign(CENTER);
    fill(0);
    textSize(15);
    if (isBrowse) text(getTextOfMonth(calendarForBrowsing.get(Calendar.MONTH)), calendarSize/2, 0 - 30);
    else {
      text(getTextOfMonth(calendar.get(Calendar.MONTH)), calendarSize/2, 0 - 30);
    }
    textAlign(CORNER);
  }

  int track = 1;

  void drawDays() {
    textSize(10);
    fill(255);
    stroke(0);

    dayObjects.clear();

    int numberOfDays = isBrowse ? calendarForBrowsing.getActualMaximum(Calendar.DAY_OF_MONTH) :  calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
    int dayIndex = 1;

    int widthHeight = calendarSize/7;
    int x = 0;
    int y = 0;

    Calendar firstDayOfMonthCal = Calendar.getInstance();
    Calendar calendarTemp;
    if (isBrowse) calendarTemp = calendarForBrowsing;
    else calendarTemp = calendar;

    firstDayOfMonthCal.set(2019, calendarTemp.get(Calendar.MONTH), 1);
    if (calendar.get(Calendar.DAY_OF_MONTH) == 1) {
      dayObjects.clear();
    }

    for (int i = 0; i < 6; ++i) {
      for (int j = 1; j <= 7; ++j, ++track) {
        rect(x, y, widthHeight, widthHeight);
        stroke(0);
        fill(0);

        if (getDayOfWeek(firstDayOfMonthCal.get(Calendar.DAY_OF_WEEK)) <= track ) {
          if (dayIndex <= numberOfDays) {
            if (dayObjects.size() < numberOfDays) dayObjects.push(new Day(dayIndex, monthIndexForBrowsing, x, y, widthHeight, this));
            for (Day day : dayObjects) {
              day.drawDay();
            }
            ++dayIndex;
          }
        }
        fill(255);
        x += widthHeight;
      }
      x = 0;
      y += widthHeight;
    }
    track = 1;
    fill(0);
    float xDay = x + widthHeight/4;
    float yDay = -5;

    text("Sun", xDay, yDay);
    text("Mon", xDay + widthHeight, yDay);
    text("Tues", xDay + widthHeight*2, yDay);
    text("Wed", xDay + widthHeight*3, yDay);
    text("Thurs", xDay + widthHeight*4, yDay);
    text("Fri", xDay + widthHeight*5, yDay);
    text("Sat", xDay + widthHeight*6, yDay);

    fill(255);
  }


  void drawCalendar() {
    timelapse();
    drawLines();
    if (isDateText) drawDate(); 

    drawPausePlay();
    pushMatrix();
    translate(translateX, translateY);
    if (!isDateText)
    {
      drawMonth();
      nextButton.drawButton();
      prevButton.drawButton();
      closeButton.drawButton();
    }
    popMatrix();
  }

  void toggleDate() {
    isDateText = !isDateText;
    if (!isDateText) calendarForBrowsing.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));
  }


  float[] detranslateCoordinate(float x, float y) {
    float translatedXY[] =  new float[2];

    translatedXY[0] = translateX  + x;
    translatedXY[1] = translateY + y;

    return translatedXY;
  }

  void handleDateChange(int dayIndex, int monthIndex) {
    calendar.set(2019, monthIndex, dayIndex);
    calendarForBrowsing.set(2019, monthIndex, dayIndex);

    isBrowse = false;
    timelapseIncrement = 1;

    updatePeopleCounter();
    updateAirTemp();
  }

  void viewNextMonth() {
    dayObjects.clear();
    if (calendarForBrowsing.get(Calendar.MONTH) + 1 != 12) {
      calendarForBrowsing.add(Calendar.MONTH, 1);
      monthIndexForBrowsing = calendarForBrowsing.get(Calendar.MONTH);
    }
  }

  void viewPreviousMonth() {
    dayObjects.clear();
    if (calendarForBrowsing.after(calMinLimit)) {
      System.out.println("YES I AM");
      calendarForBrowsing.add(Calendar.MONTH, -1);
      monthIndexForBrowsing = calendarForBrowsing.get(Calendar.MONTH);
      System.out.println(calendarForBrowsing.getTime());
    }
  }
}
