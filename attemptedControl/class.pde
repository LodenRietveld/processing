class C {
  PVector p1, p2, oriP1, oriP2; //point1, point2, originPoint1, originPoint2
  float ranX, ranY; //add some nice jitter

  C(float x1, float y1, float x2, float y2) {
    p1 = new PVector(x1 + width/2, y1 + height/2);
    p2 = new PVector(x2 + width/2, y2 + height/2);
    oriP1 = new PVector(0, 0);
    oriP2 = new PVector(0, 0);
    this.oriP1.add(p1);
    this.oriP2.add(p2);
  }

  void move() {
    
    //set color to black, move random between -2 and 2, synced for x's  and y's so the line doesn't stretch
    
    stroke(0);
    strokeWeight(2);
    ranX = random(-2, 2);
    ranY = random(-2, 2);
    
    p1.x += ranX;
    p2.x += ranX;
    p1.y += ranY;
    p2.y += ranY;
    
    line(p1.x, p1.y, p2.x, p2.y);
    
    //draw a low-alpha version of the original circle as well
    
    stroke(0, 20);
    line(oriP1.x, oriP1.y, oriP2.x, oriP2.y);
  }

  // a method that returns the distance of a line from the original circle position
  
  float pdist() {
    float _val = 0;
    _val = abs(dist(oriP1.x, oriP1.y, p1.x, p1.y));
    return _val;
  }


  // a method that pulls a line back to its original position.
  
  void reset(float _c) {
    _c += 1;

    float xDif1, yDif1, xDif2, yDif2;
    float xStep1, yStep1, xStep2, yStep2;

    //if the time set to walk back is bigger than one, set the difference.
    
    if (time > 1) {
      xDif1 = p1.x - oriP1.x;
      yDif1 = p1.y - oriP1.y;
      xDif2 = p2.x - oriP2.x;
      yDif2 = p2.y - oriP2.y;
      
      //set the step size, dependent on the loop count we're on, and the given max amount of time we have to return to the circle.
      
      xStep1 = xDif1 / time * log(_c);
      yStep1 = yDif1 / time * log(_c);
      xStep2 = xDif2 / time * log(_c);
      yStep2 = yDif2 / time * log(_c);
      
      //subtract the step from the current position

      p1.sub(xStep1, yStep1);
      p2.sub(xStep2, yStep2);
    } else {
      
      // if the time is set at one or less, just return to the original position immediately.
      
      p1.set(oriP1);
      p2.set(oriP2);
    }

    stroke(255, 0, 0);
    line(p1.x, p1.y, p2.x, p2.y);
  }

  // a method that makes the lines explode outward/inward from the original circle

  void explode(float _ec, float _c) {
    
    // depends on the loop count and times it's exploded before.
    
    float explodeCount = _ec;
    float count = _c;
    
    // do some nice vector subbing to find the "direction" of the line, in order to create a perpendicular direction to explode into.
    
    PVector dir = PVector.sub(p1, p2);
    dir.set(dir.y, -dir.x);
    dir.normalize();
    
    //choose a random direction (outward/inward)
    
    if (random(1) > 0.5){
      ranX = 1;
    } else {
      ranX = -1;
    }
    
    if (random(1) > 0.5){
      ranY = 1;
    } else {
      ranY = -1;
    }
    
    //add jitter
    
    float jitX = random(-2, 2);
    float jitY = random(-2, 2);
    
    //add all that stuff to the current position
    
    p1.x += (explodeCount / 10 * count + jitX) * dir.x * ranX;
    p1.y += (explodeCount / 10 * count + jitY) * dir.y * ranY;
    p2.x += (explodeCount / 10 * count + jitX) * dir.x * ranX;
    p2.y += (explodeCount / 10 * count + jitY) * dir.y * ranY;
  }
}