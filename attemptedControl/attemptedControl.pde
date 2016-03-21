ArrayList<C> cs = new ArrayList<C>();
C c = new C(200, 200, 300, 300);

float amount = 200;
float size = 300;
float count = 0;
float time = 15;
int r = 0;
float[] exploCount = new float[int(amount)];

float[] dists = new float[int(amount)];
float maxValue = 0;
int maxValueIndex = 0;

float[] lCount = new float[int(amount)];
float[] elCount = new float[int(amount)];
boolean[] reset = new boolean[int(amount)];
boolean[] explode = new boolean[int(amount)];

int selector = 0;

void setup() {
  size(displayWidth, displayHeight);
  for (float i = 0; i < amount; i++) {
    cs.add(new C(sin((i / amount) * TWO_PI) * size, cos((i / amount) * TWO_PI) * size, sin(((i + 1) / amount) * TWO_PI) * size, cos(((i + 1) / amount) * TWO_PI) * size));
    
    lCount[int(i)] = 0.0;
    elCount[int(i)] = 0.0;
    reset[int(i)] = false;
    explode[int(i)] = false;
    exploCount[int(i)] = 0.0;
  }
}



void draw() {
  background(35);
  for (int i = 0; i < cs.size(); i++) {
    if (i != r) {
      cs.get(i).move();
      // check max dist from original position and move that back instead of a random line?
      //float dif = dist(cs.get(i).p1.x, cs.get(i).p1.y, cs.get(i).or1P1.x, 
      //if (
    }
    dists[i] = cs.get(i).pdist();
  }
  
  switch(selector){
    case 0:
      count = no1(dists, count, time);
      break;
    
    case 1:
      count = no2(dists, time);
      break;
      
    case 2:
      count = no3(dists, time);
      break;
  }
  //count = no1(dists, count, time);
  //count = no2(dists, time);
  //count = no3(dists, time);
  count++;
}

void keyPressed(){
  switch (key){
    case '1':
      selector = 0;
      break;
    
    case '2':
      selector = 1;
      break;
    
    case '3':
      selector = 2;
      for (int i = 0; i < amount; i++){
        reset[i] = false;
        exploCount[i] = 0;
        elCount[i] = 0;
        explode[i] = false;
      }
      break;
  }
}