float no1(float[] _d, float _c, float _t) {
  float[] dists = _d;
  float count = _c;
  float time = _t;

  maxValue = max(dists);

  if (count >= time) {
    for (int i = 0; i < amount; i++) {
      if (cs.get(i).pdist() == maxValue) {
        if (maxValueIndex != i) {
          maxValueIndex = i;
          count = 0;
        }
      }
    }
  }

  if (count < time) {
    cs.get(maxValueIndex).reset(count);
  }
  return count;
}


float no2(float[] _d, float _t) {
  float[] dists = _d;
  float time = _t;

  for (int i = 0; i < amount; i++) {
    if (lCount[i] >= time) {

      lCount[i] = 0;
      reset[i] = false;
    }

    if (dists[i] > 50 && reset[i] == false) {

      reset[i] = true;
    }

    if (reset[i] == true) {

      cs.get(i).reset(lCount[i]);
      lCount[i]++;
    }
  }
  return 0;
}


float no3(float[] _d, float _t) {
  float[] dists = _d;
  float time = _t;
  float f = 0;

  for (int i = 0; i < amount; i++) {
    if (elCount[i] >= time * exploCount[i]) {

      elCount[i] = 0;
      explode[i] = false;
      reset[i] = true;
      
    }
    if (lCount[i] >= time) {

      lCount[i] = 0;
      //reset[i] = false;
    }


    if (dists[i] <= 10 && explode[i] == false) {

      explode[i] = true;
      exploCount[i] += 1;
    }

    if (explode[i] == true) {

      cs.get(i).explode(exploCount[i], elCount[i]);
      elCount[i]++;
      reset[i] = false;
      
    } else if (explode[i] == false && reset[i] == true) {
      
      cs.get(i).reset(lCount[i]);
      lCount[i]++;
    }
  }
  return 0;
}