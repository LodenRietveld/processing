//function that calculates the acceleration each object should have. 
void checkNeighbours(int _i, obj.Obj _obj) {

  int i = _i;
  PVector _acc = new PVector(0, 0);
  PVector dir = new PVector(0, 0);
  Obj obj = _obj;


  for (int j = 0; j < objects.size (); j++) {
    if (j != i) {
      Obj otherObj = objects.get(j);

      //ACCELERATION

      dir = PVector.sub(obj.loc, otherObj.loc);
      dir.normalize();
      dir.mult(0.5 / (dist(obj.loc.x, obj.loc.y, otherObj.loc.x, otherObj.loc.y) * sqrt(abs(obj.mass / otherObj.mass))));
      _acc.add(dir);
    }
  }


  _acc.x *= -1.;
  _acc.y *= -1.;

  obj.acc.set(_acc);
}

//function that sends an osc message to target
void oscMsg(int _val, NetAddress target) {
  OscMessage note = new OscMessage("/note");
  note.add(_val);
  oscp5.send(note, target);
}


void coordMsg(float _x, float _y, int dest) {
  OscMessage x = new OscMessage("/x" + str(dest));
  x.add(map(_x, 0, width, 0, 1));
  oscp5.send(x, max);

  OscMessage y = new OscMessage("/y" + str(dest));
  y.add(map(_y, 0, height, 0, 1));
  oscp5.send(y, max);

  if (troubleShoot) {
    text(_x, 50, 100 + (20 * dest));
    text(_y, 100, 100 + (20 * dest));
  }
}

void coordMsg(float _x, float _y, String dest) {
  OscMessage x = new OscMessage("/x" + dest);
  x.add(map(_x, 0, width, 0, 1));
  oscp5.send(x, max);

  OscMessage y = new OscMessage("/y" + dest);
  y.add(map(_y, 0, height, 0, 1));
  oscp5.send(y, max);
}


//F = G * ((m1 * m2) / sq(dist))
//Collision -> 25% van mass kleinere planeet bij de grotere planeet. onder een grens .destroy() je een planeet