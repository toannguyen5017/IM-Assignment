class Person {

  float vx = 0;
  float vy = 0;

  PVector position;

  float radius, m;
  

  Person(float x, float y, float r_) {
    position = new PVector(x, y);
    radius = r_;
  }

  void checkCollision(Building building) { //copied from bouncing balls from processing examples
    PVector distanceVect = PVector.sub(building.position, position);
    float distanceVectMag = distanceVect.mag();

    float minDistance = radius + 190;

    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      building.position.add(correctionVector);
      position.sub(correctionVector);

      float theta  = distanceVect.heading();

      float sine = sin(theta);
      float cosine = cos(theta);

      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      building.position.x = position.x + bFinal[1].x;
      building.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);
    }
  }

  void display() {
    stroke(255);
    strokeWeight(1);
    fill(100);
    ellipse(position.x, position.y, radius*2, radius*2);
  }

  void move() { //move people circles towards center
    if (abs(width/2 - position.x) > 0.1) {
      position.x = position.x + (width/2 - position.x) * easing;
    }
    if (abs(height/2 - position.y) > 0.1) {
      position.y = position.y + (height/2- position.y) * easing;
    }
  }

}
