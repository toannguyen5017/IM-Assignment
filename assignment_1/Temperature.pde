import java.util.LinkedList;

float temp;
//float prev;

float r = 150;
float g = 100;
float b = 150;

LinkedList<Float> list = new LinkedList<Float>();

void backgroundColour() { 

  temp = calendar.airTempAverage;
  //list.add(temp);

  //if (list.size() == 2) {

  //  list.remove(0);

  //}

  //println(list); 
  //prev = list.get(0);

  background(r, g, b);

  if (temp > 25) {
    r = r + 1;
    b = b - 1;
  } else {
    r = r - 1;
    b = b + 1;
  }


  if ( r > 200) {
    r = 200;
  } else if (r < 100) {
    r = 100;
  }

  if ( b > 255) {
    b = 255;
  } else if (b < 100) {
    b = 100;
  }




  textSize(18);
  textAlign(CORNER);
  text("Average No. People Entering B11 a Day Per 30 minutes: "+ calendar.peopleCountAverage, width/2 - width/2.5, height/2 + height/5);
  textAlign(CENTER);
  text("Average Temp of the Day: "+ round(calendar.airTempAverage) + "°C", width/2 + width/4.5, height/2 + height/5);
  textAlign(CORNER);
}
