
//main object class, has a bunch of variables that sort of speak for themselves (I hope)
//loc = location
//acc = acceleration
//speed = velocity (used wrong terminology when I started, too lazy to change now

class Obj {
  float size;
  float mass;
  float x, y;
  boolean out_of_bounds = false;
  PVector loc, acc, speed;
  color c;
  boolean sent;
  int note = 36;
  
  // CONSTRUCTOR

  Obj(float _x, float _y, float _size, PVector _speed, int _n) {
    this.x = _x;
    this.y = _y;
    this.size = _size;
    this.mass = sq(size / 2) * PI * 100;
    this.c = color(random(20) + 200, random(20) + 200, random(20) + 200);
    this.speed = _speed;
    this.sent = false;
    this.note = _n + 36;
    loc = new PVector(x, y);
    acc = new PVector(0, 0);
    //speed = new PVector(0, 0);
  }

  // METHODS
  
  //move and draw the object
  void move() {
    if (loc.y - (size/2) > height || loc.y + (size/2) < 0 || loc.x - (size/2) > width || loc.x + (size/2) < 0) {
      out_of_bounds = true;
    }
    speed.add(acc);
    loc.add(speed);
    noStroke();
    fill(c);
    ellipse(loc.x, loc.y, size, size);
    stroke(0);
    strokeWeight(3);
  }
  
  //check to see if object is out of bounds
  int checkBounds() {
    if (out_of_bounds) {
      return 0;
    } else {
      return 1;
    }
  }

  //send an osc message, used for the collision method
  void sendMessage(float _d, Obj _1, Obj _2, int _i) {
    float dist = _d;
    int i = _i;
    if(_1.size == 10) {
      oscMsg(int(map(note, 36, 127, 0, 64)) % 64 + 36, max);
    }
  }


  //Check collisions between objects. from processing.org examples. I removed the part where the planets bounce, because it didn't look as good.
  int checkCollisionOSC(Obj other, int i) {

    // get distances between the balls components
    PVector bVect = PVector.sub(loc, other.loc);

    // calculate magnitude of the vector separating the balls
    float bVectMag = bVect.mag();

    if (bVectMag < (size / 2) + (other.size / 2) && sent) {

      return 1;
    } else if (bVectMag > (size / 2) + (other.size / 2) && sent) {

      return 0;
    } else if (bVectMag < (size / 2) + (other.size / 2) && this.sent == false) {

      this.sendMessage(bVectMag, this, other, i);
      this.sent = true;
      return 1;
    } else {
      return 0;
    }
  }
}