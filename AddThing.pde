void addCoins(int segId, int amount, int shapeMode){
  if (shapeMode == 1){
    float x = random(-.70f, .70f);
    for (int i = 0; i < amount; i++) {
      sCoinExists.put(segId + i, true);
      sCoinX.put(segId + i, x);
    }
  }
}


void addSprite(int segId, int src, float offset) {
  sSpriteSrc.put(segId, src);
  sSpriteOff.put(segId, offset);
}

float lastY = 0;
void addSegment(float y, float c) {
  sPointsX.add(0.0f);
  sPointsY.add(y);
  sPointsZ.add(SEGMENT_LENGTH * numSegs);
  sPointsC.add(c);
  
  numSegs++;

}

void addCurve(int enter, int hold, int leave, float curve) {
  float y = 75;
  int total = enter + hold + leave; 
  for (int i = 0; i < enter; i++)
    addSegment(easeInOut(lastY, y, (float)i / total), easeIn(0, curve, (float)i / enter));
  for (int i = 0; i < hold; i++) 
    addSegment(easeInOut(lastY, y, (float)(i + enter) / total), curve);
  for (int i = 0; i < leave; i++)
    addSegment(easeInOut(lastY, y, (float)(i + enter + hold) / total), easeInOut(curve, 0, (float)i /leave));
  lastY = y;
}
