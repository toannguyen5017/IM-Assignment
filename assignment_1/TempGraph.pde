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

  int m = 0;
  for (int i=0; i<mm.length; i++) {
    if (mm[i] == m) continue;
    m = mm[i];
    float x = map(i, 0, mm.length, X1, X2);
    text(m, x, Y2+10);
    strokeWeight(0.3);
    line(x, Y2, x, Y1);
  }
  textSize(18);
  textAlign(CENTER, TOP);
  text("Time", width/2, Y2+10);
}

void drawYLabels() {
  fill(255);
  textSize(10);
  textAlign(RIGHT);
  stroke(255);
  for (float i=minamount; i <= maxamount; i += 10) {
    float y = map(i, minamount, maxamount, Y2, Y1);
    text(floor(i), X1-10, y);
    line(X1, y, X1-5, y);
  }
  textSize(18);
  text("units", X1-40, height/2 + 300);
} // drawYLabels()
