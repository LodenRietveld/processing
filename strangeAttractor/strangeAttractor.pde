float x = 0.1, y = 0.1, // starting point
  a = -0.966918, // coefficients for "The King's Dream"
  b = 2.879879, 
  c = 0.765145, 
  d = 0.744728;
int  initialIterations = 100, // initial number of iterations
  // to allow the attractor to settle
  iterations = 10000;     // number of times to iterate through
// the functions and draw a point

boolean running = true;

void setup() {

  frameRate(24);
  size(displayWidth, displayHeight, OPENGL);
  smooth(16);
  background(0);

  for (int i = 0; i < initialIterations; i++) {

    // compute a new point using the strange attractor equations
    float xnew = sin(y*b) + c*sin(x*b);
    float ynew = sin(x*a) + d*sin(y*a);

    // save the new point
    x = xnew;
    y = ynew;
  }
}

void draw() {
  //background(0);
  stroke(200, 200, 160);
  strokeWeight(1);
  //strangeAttractor(0);
  if (running) {
    strangeAttractor(0.01);
  }


  noStroke();
  fill(0, 0, 0, 15);
  rect(0, 0, width, height);
  
  saveFrame();


  a += 0.001;
}

void keyPressed() {
  if (key == 's') {
    running = true;
  }
}

void strangeAttractor(float aMod) {

  for (int i = 0; i < iterations; i++) {

  // compute a new point using the strange attractor equations
  float xnew = sin(y*b) + c*sin(x*b);
  float ynew = sin(x*(a + aMod)) + d*sin(y*(a + aMod));

  // save the new point
  x = xnew;
  y = ynew;

  // draw the new point
  point((x * (width / 4)) + width / 2, (y * (height / 4) * -1) + height / 2);
  }
}