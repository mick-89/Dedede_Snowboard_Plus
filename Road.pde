int numSegs = 0;


float SEGMENT_LENGTH = 10;
int SEGMENT_WIDTH = 60;
ArrayList<Float> sPointsX = new ArrayList<Float>();
ArrayList<Float> sPointsY = new ArrayList<Float>();
ArrayList<Float> sPointsZ = new ArrayList<Float>();
ArrayList<Float> sPointsC = new ArrayList<Float>(); // curve

ArrayList<Integer> sSpriteSrc = new ArrayList<Integer>();
ArrayList<Float> sSpriteOff = new ArrayList<Float>();

void addSprite(int segId, int src, float offset) {
  sSpriteSrc.set(segId, src);
  sSpriteOff.set(segId, offset);
}

float lastY = 0;
void addSegment(float y, float c) {
  sPointsX.add(0.0f);
  sPointsY.add(y);
  sPointsZ.add(SEGMENT_LENGTH * numSegs);
  sPointsC.add(c);
  
  sSpriteSrc.add(-1);
  sSpriteOff.add(0.0f);
  
  numSegs++;

}

void addCurve(int enter, int hold, int leave, float curve) {
  float y = 50;
  int total = enter + hold + leave; 
  for (int i = 0; i < enter; i++)
    addSegment(easeInOut(lastY, y, (float)i / total), easeIn(0, curve, (float)i / enter));
  for (int i = 0; i < hold; i++) 
    addSegment(easeInOut(lastY, y, (float)(i + enter) / total), curve);
  for (int i = 0; i < leave; i++)
    addSegment(easeInOut(lastY, y, (float)(i + enter + hold) / total), easeInOut(curve, 0, (float)i /leave));
  lastY = y;
}

void makeRoad() {
  addCurve(5,5,5,-1);
  
  for (int i = 0; i < 300; i++) {
    addSegment(0, 0);
  }
  for (int i = 3; i < 100; i++) {
    addSprite(i, 0, random(-1, 1) > 0 ? 1 : -1);
  }
}


int DRAW_DISTANCE = 100;
float[] sCameraX = new float[DRAW_DISTANCE];
float[] sCameraY = new float[DRAW_DISTANCE];
float[] sCameraZ = new float[DRAW_DISTANCE];
float[] sCurve = new float[DRAW_DISTANCE];

float[] sScreenScale = new float[DRAW_DISTANCE];
int[] sScreenX = new int[DRAW_DISTANCE];
int[] sScreenY = new int[DRAW_DISTANCE];
int[] sScreenW = new int[DRAW_DISTANCE];









// TODO: add fog




void drawRoad() {
  int cameraSeg = floor(cameraZ/SEGMENT_LENGTH);
  
  float xOffset = 0;
  float positionInSegment = (cameraZ - cameraSeg * SEGMENT_LENGTH) / SEGMENT_LENGTH;
  printSc("posinseg: "+positionInSegment);
  float dXOffset = -positionInSegment * sPointsC.get(cameraSeg);
  //float dXOffset = 0;
  int horizonY = scHeight;

  for (int i = 0; i < DRAW_DISTANCE; i++) {
    int segId = (cameraSeg + i) % numSegs;
    sCameraX[i] = sPointsX.get(segId) - cameraX - xOffset;
    sCameraY[i] = sPointsY.get(segId) - cameraY;
    sCameraZ[i] = sPointsZ.get(segId) - cameraZ;
    
    
    dXOffset += sPointsC.get(segId);
    xOffset += dXOffset;
    
    
    
    sScreenScale[i] = 1 / tan(fov/2 * PI / 180.0f) / sCameraZ[i];
    // as it is, this is stretching a 1:1 screen, i guess you'd need to add an extra virtual world step before actually projectin to the screen to avoid that
    sScreenX[i] = round(scWidth/2 + sCameraX[i]*sScreenScale[i]*scWidth/2);
    sScreenY[i] = round(scHeight/2 - sCameraY[i]*sScreenScale[i]*scHeight/2);
    sScreenW[i] = round(sScreenScale[i] * SEGMENT_WIDTH * scWidth/2);
    
    if (sCameraZ[i] <=  1 / tan(fov/2 * PI / 180.0f)) continue;
    horizonY = min(horizonY, sScreenY[i]);

    
  }
    display.stroke(40); display.strokeCap(SQUARE); display.strokeWeight(1);
  //display.fill(40);
  display.noFill();
  display.line(0,horizonY - 1, scWidth,horizonY - 1);
  
  for (int j = DRAW_DISTANCE - 1; j > 0; j--) {
    int i = j - 1;
    if (sCameraZ[i] <=  1 / tan(fov/2 * PI / 180.0f)) continue;
    // display.stroke(200);
    display.noStroke();
    display.fill(60);
    //trapezoid(0, scWidth, 0, scWidth, sScreenY[j], sScreenY[i]);
    
    display.strokeWeight(2);
    display.stroke(40); display.strokeCap(ROUND);
    display.fill(255);
    //display.noFill();
    
    int segId = (cameraSeg + i) % numSegs;
    if (segId == 3) display.fill(100);
    trapezoid4(sScreenX[j]-sScreenW[j], sScreenX[j] + sScreenW[j], sScreenX[i] - sScreenW[i], sScreenX[i] + sScreenW[i], sScreenY[j], sScreenY[i], 0);
    
    // sharp edge detection
    if (j < DRAW_DISTANCE - 1)
      if (sCameraY[j + 1] - sCameraY[j] < -40) {
        display.stroke(0);
        display.line(0, sScreenY[j]+1, scWidth, sScreenY[j] - 1);
      }
      
      
    
    
    if (sSpriteSrc.get(segId) != -1) {
      float w = sScreenScale[i] * tree.width * scWidth/32;
      float h = sScreenScale[i] * tree.height * scHeight/32;
      
      int sprScreenX = round(scWidth/2 +(sScreenScale[i]*(sCameraX[i]+sSpriteOff.get(segId)*SEGMENT_WIDTH))*scWidth/2);
      int sprScreenY = round(sScreenY[i] - h / 2);
      
      display.imageMode(CENTER);
      display.image(tree, sprScreenX, sprScreenY,w,h);      
      display.fill(0);
      //printSc("sc"+sScreenScale[i]+ " "+segId);
    }
  }
  
  
  
}
