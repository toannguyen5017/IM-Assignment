import java.util.Calendar; //<>//
import java.util.Date;
import java.text.SimpleDateFormat;



class CalendarTimelapse {
  Calendar calendar = (Calendar) Calendar.getInstance();
  Calendar calendarForBrowsing = (Calendar) Calendar.getInstance();
  
  Calendar calMinLimit = (Calendar) Calendar.getInstance();
  Calendar calMaxLimit = (Calendar) Calendar.getInstance();
  
  SimpleDateFormat sdf;
  int monthIndex;
  boolean isDateText = true;
  boolean isBrowse = false;

  float translateX = 2.75;
  float translateY = 10;

  Button nextButton = new Button("NEXT", this, 235, -50);
  Button prevButton = new Button("PREV", this, 5, -50);
  Button closeButton = new Button("CLOSE", this, 235, 235);


  CalendarTimelapse() {
    calendar.set(2019, 6, 13, 0, 0);
    calendarForBrowsing.set(2019, 6, 13, 0, 0);
    calMinLimit.set(2019, 7, 12);
    calMaxLimit.set(2019, 10, 31);

    sdf = new SimpleDateFormat("d/M/y");

    System.out.println(getTextOfDate() + " " + getTextOfDay());
    System.out.println(calendar.get(Calendar.MONTH));

    monthIndex = calendarForBrowsing.get(Calendar.MONTH);
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

  String getTextOfDate() {
    return sdf.format(calendar.getTime());
  }

  void drawDate() {
    textSize(30);
    text(getTextOfDate(), 0 + 55, 0 + 20);
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
    fill(0);
    textSize(15);
    text(getTextOfMonth(calendarForBrowsing.get(Calendar.MONTH)), 0 + 80, 0 - 50);
  }

  int track = 1;

  void drawDays() {
    textSize(10);
    fill(255);
    stroke(0);

    int numberOfDays = isBrowse ? calendarForBrowsing.getActualMaximum(Calendar.DAY_OF_MONTH) :  calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
    int dayIndex = 1;

    int widthHeight = 40;
    int x = 0;
    int y = 0;

    Calendar calendarTemp;
    if (isBrowse) calendarTemp = calendarForBrowsing;
    else calendarTemp = calendar;

    for (int i = 0; i < 6; ++i) {
      for (int j = 1; j <= 7; ++j, ++track) {
        rect(x, y, widthHeight, widthHeight);
        stroke(0);
        fill(0);

        if (getDayOfWeek(calendarTemp.get(Calendar.DAY_OF_WEEK)) <= track) {
          if (dayIndex <= numberOfDays) {
            text(dayIndex, x - widthHeight/6, y + widthHeight/6);
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
    float xDay = x - widthHeight/4;

    text("Sun", xDay, -25);
    text("Mon", xDay + widthHeight, -25);
    text("Tues", xDay + widthHeight*2, -25);
    text("Wed", xDay + widthHeight*3, -25);
    text("Thurs", xDay + widthHeight*4, -25);
    text("Fri", xDay + widthHeight*5, -25);
    text("Sat", xDay + widthHeight*6, -25);

    fill(255);
  }


  void drawCalendar() {
    pushMatrix();
    translate(width/translateX, height/translateY);
    if (isDateText) drawDate(); 
    else {
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
    translatedXY[0] = width/translateX  + x - 24;
    translatedXY[1] = width/translateY + y - 8;


    return translatedXY;
  }

  void viewNextMonth() {
    if (calendarForBrowsing.before(calMaxLimit)) {
      calendarForBrowsing.add(Calendar.MONTH, 1);
    }
    isBrowse = true;
  }

  void viewPreviousMonth() {
    isBrowse = true;
    if(calendarForBrowsing.after(calMinLimit))
    calendarForBrowsing.add(Calendar.MONTH, -1);
    if (calendarForBrowsing.get(Calendar.MONTH) == calendar.get(Calendar.MONTH)) isBrowse = false;
  }
}
