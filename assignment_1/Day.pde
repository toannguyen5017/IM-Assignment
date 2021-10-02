class Day {
  String date;
  float x, y;
  float deTranslatedX, deTranslatedY;
  float widthHeight;
  int dayIndex;
  int monthIndex;
  CalendarTimelapse parent;
  boolean isCurrentTime = false;
  boolean isHovered = false;
  color fill = color(0, 0, 255);

  public Day(int dayIndex, int monthIndex, float x, float y, float widthHeight, CalendarTimelapse parent) {
    this.x = x;
    this.y = y;
    this.parent = parent;
    this.dayIndex = dayIndex;
    this.monthIndex = monthIndex;
    this.widthHeight = widthHeight;
    this.deTranslatedX = parent.detranslateCoordinate(x, y)[0];
    this.deTranslatedY = parent.detranslateCoordinate(x, y)[1];

    if (parent.getCalendar().get(Calendar.DAY_OF_MONTH) == dayIndex) {
      isCurrentTime = true;
    }

    drawDay();
  }

  float getWidth() {
    return widthHeight;
  }

  float getHeight() {
    return widthHeight;
  }

  float getDetranslatedX() {
    return deTranslatedX;
  }

  float getDetranslatedY() {
    return deTranslatedY;
  }

  void handleClick() {
    parent.handleDateChange(dayIndex, monthIndex);
  }

  void handleHover() {
    isHovered = true;
  }

  void handleUnhover() {
    isHovered = false;
  }

  void drawDay() {
    if (parent.getCalendar().get(Calendar.DAY_OF_MONTH) == dayIndex) {
      isCurrentTime = true;
    }
    else isCurrentTime = false;
    
    if (isCurrentTime && !parent.getIsBrowse()) fill = color(255, 0, 0);
    else fill = color(255);
    
    fill(fill);
    rect(x, y, widthHeight, widthHeight);
    fill(0);

    textAlign(CENTER);
    text(dayIndex, x + widthHeight/2, y + widthHeight/2);
    textAlign(CORNER);
  }
}
