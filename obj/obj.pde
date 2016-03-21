// created by Loden Rietveld for an octophonics assignment
// intended to simulate gravity, but eventually became a more abstract collision/location system,
// used to trigger sounds and move them around a room

import oscP5.*;
import netP5.*;

OscP5 oscp5;
NetAddress ableton;
NetAddress max;

float dist=0, pdist, ddist;
ArrayList<Obj> objects = new ArrayList<Obj>();
float size = 10;
float G = pow(6.674, -11);
boolean clicked = false;
boolean pen = false;
int prevmx = 0, prevmy = 0;
int[] sizeNum = new int[10];
PVector[] tempVal = new PVector[10];
PVector[] avgCoords = new PVector[10];
int selectedKey = 1;

boolean troubleShoot = false;

void setup() {
  //background(0);
  size(displayWidth, displayHeight);

  for (int i = 0; i < avgCoords.length; i++) {
    sizeNum[i] = 0;
    tempVal[i] = new PVector(0, 0);
    avgCoords[i] = new PVector(0, 0);
  }

  oscp5 = new OscP5(this, 9001);
  ableton = new NetAddress("127.0.0.1", 9000);
  max = new NetAddress("127.0.0.1", 12000);
}

void draw() {
  // reset the arrays  
  for (int i = 0; i < avgCoords.length; i++) {
    avgCoords[i].set(0, 0);
    tempVal[i].set(0, 0);
  }

  // follow the current mouse position when mouse isn't pressed  
  if (!mousePressed) {
    prevmx = mouseX;
    prevmy = mouseY;
  }

  // MAIN LOOP

  for (int i = 0; i < objects.size(); i++) {

    // CREATE DISTANCE AND RETURNS ARRAY
    float[] dists = new float[objects.size()];
    int[] returns = new int[objects.size()];

    // initiate obj, check acceleration and move obj
    Obj obj = objects.get(i);
    checkNeighbours(i, obj);
    obj.move();

    //check collision, add 0 or 1 to returns, depending on whether there was a collision or not
    for (int j = 0; j < objects.size(); j++) {
      if (j != i) {
        returns[j] = obj.checkCollisionOSC(objects.get((j) % objects.size()), j);
      }
    }

    // if no collisions are taking place this frame, set the boolean for having sent a message to false
    if (max(returns) == 0) {
      obj.sent = false;
    }

    // if an object goes out of bounds, remove that object
    if (objects.get(i).checkBounds() == 0) {
      objects.remove(i);
    }

    // add all the x and y values for every object with size j * 10 to its respective place in the array
    for (int j = 0; j < avgCoords.length; j++) {
      if (obj.size == j * 10) {
        avgCoords[j].add(obj.loc.x, obj.loc.y);
      }
    }
  }

  // END MAIN LOOP

  //divide every place in the average coordination array by the number of objects with that size
  for (int i = 0; i < avgCoords.length; i++) {
    avgCoords[i].div(sizeNum[i]);


    // check for the initial condition where there are no coordinates yet. use Double's .isNaN() method to check for NaN
    double _x = avgCoords[i].x, 
      _y = avgCoords[i].y;

    //if the value of a coordinate goes to infinity or NaN, set it to the middle of the screen, else set it to the average positions
    if (Double.isNaN(_x) || Double.isNaN(_y) || Double.isInfinite(_x) || Double.isInfinite(_y) || (_x == 0.0 && _y == 0.0)) {
      tempVal[i].set(width/2, height/2);
    } else {
      tempVal[i].set(avgCoords[i]);
    }

    //send an osc message to Max with the average x and y values and the index (size of the object) 
    if (i == 2 && sizeNum[2] == 0) {
      continue;
    }

    if (i == 9 && sizeNum[2] == 0) {
      coordMsg(tempVal[i].x, tempVal[i].y, 2);
    } else {

      coordMsg(tempVal[i].x, tempVal[i].y, i);
    }
  }
  
  text(selectedKey, 100, 100);
  //make a nice juicy fading out tail  
  noStroke();
  fill(0, 0, 0, 50);
  rect(0, 0, width, height);
}


void mouseReleased() {

  //on releasing the left mouse button, create a new object with the given size, and add 1 to the corresponding index of the size array
  if (mouseButton == LEFT) {
    objects.add(new Obj(prevmx, prevmy, size, new PVector((mouseX - prevmx) / 100, (mouseY - prevmy) / 100), objects.size()));
    sizeNum[int(size / 10)] += 1;
  }
  clicked = false;

  // on releasing the right mouse button, remove the object under your mouse cursor

  if (mouseButton == RIGHT) {
    for (int i = 0; i < objects.size(); i++) {
      if (dist(mouseX, mouseY, objects.get(i).loc.x, objects.get(i).loc.y) < objects.get(i).size) {
        sizeNum[int(objects.get(i).size / 10)] -= 1;
        objects.remove(i);
      }
    }
  }
}

void keyPressed() {

  //set the size to the number you typed * 10 (to get around gigantic switch case)
  size = float(parseInt(str(key)) * 10);
  if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '0') {
    selectedKey = parseInt(str(key));
  }

  //regular letters will parse to 0, so set the size to the minimum size when that's the case
  if (size == 0) {
    size = 10;
  }

  //start playing
  if (key == 's') {
    OscMessage GO = new OscMessage("/live/play");
    oscp5.send(GO, ableton);
  } else if (key == 't') {
    troubleShoot = !troubleShoot;

    //clears all objects
  } else if (key == 'q') {
    for (int i = 0; i < objects.size(); i++) {
      if (int(objects.get(i).size) == selectedKey * 10) {
        objects.remove(i);
      } else if (selectedKey == 0) {
        objects.clear();
      }
    }
  }
}