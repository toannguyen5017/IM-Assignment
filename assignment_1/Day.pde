class Day {
  String date;
  float x, y;
  float translatedX, translatedY;
  float widthHeight;
  int dayIndex;
  CalendarTimelapse parent;
  boolean isCurrentTime = false;

  public Day(int dayIndex, float x, float y, float widthHeight, CalendarTimelapse parent) {
    this.x = x;
    this.y = y;
    this.parent = parent;
    this.dayIndex = dayIndex;
    this.widthHeight = widthHeight;
    this.translatedX = parent.detranslateCoordinate(x, y)[0];
    this.translatedY = parent.detranslateCoordinate(x, y)[1];
    
    if(parent.getCalendar().get(Calendar.DAY_OF_MONTH) == dayIndex) {
      isCurrentTime = true;
    }
    
    drawDay();
  }

  void drawDay() {
    if(isCurrentTime && !parent.getIsBrowse()) fill(255, 0, 0);
    else fill(255);
    rect(x, y, widthHeight, widthHeight);
    fill(0);
    text(dayIndex, x - widthHeight/6, y + widthHeight/6);
  }
}
