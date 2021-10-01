class Button {
  float x, y;
  String type;
  CalendarTimelapse parent;
  float detranslatedX;
  float detranslatedY;
  float buttonWidth = 50;
  float buttonHeight = 20;

  public Button(String type, CalendarTimelapse parent, float x, float y) {
    this.type = type;
    this.parent = parent;

    this.x = x;
    this.y = y;

    detranslatedX = parent.detranslateCoordinate(x, y)[0];
    detranslatedY = parent.detranslateCoordinate(x, y)[1];
  }

  float getDetranslatedX() {
    return detranslatedX;
  }

  float getDetranslatedY() {
    return detranslatedY;
  }

  float getWidth() {
    return buttonWidth;
  }

  float getHeight() {
    return buttonHeight;
  }

  void handleButton() {
    System.out.println("worked");
    if (this.type == "NEXT") parent.viewNextMonth();
    if (this.type == "PREV") parent.viewPreviousMonth();
    if (this.type == "CLOSE") parent.toggleDate();
  }

  void drawButton() {
    fill(240);
    rect(x, y, buttonWidth, buttonHeight);
    fill(0);
    textSize(10);
    text(type, x - 14, y + 3);
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }
}
