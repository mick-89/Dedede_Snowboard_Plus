import java.util.Map;

int numSegs = 0;


float SEGMENT_LENGTH = 10;
int SEGMENT_WIDTH = 70;
ArrayList<Float> sPointsX = new ArrayList<Float>();
ArrayList<Float> sPointsY = new ArrayList<Float>();
ArrayList<Float> sPointsZ = new ArrayList<Float>();
ArrayList<Float> sPointsC = new ArrayList<Float>(); // curve


HashMap<Integer, Boolean> sCoinExists = new HashMap<Integer, Boolean>();
HashMap<Integer, Float> sCoinX = new HashMap<Integer, Float>();


float coinScaleX = 5;
float coinScaleY = 5;
float coinHitbox = 8;

HashMap<Integer, Integer> sSpriteSrc = new HashMap<Integer, Integer>();
HashMap<Integer, Float> sSpriteOff = new HashMap<Integer, Float>();

void makeRoad() {
  addCurve(5,5,5,-1);
  
  for (int i = 0; i < 300; i++) {
    addSegment(sin(i/5.0f)*random(7.0f,10.0f) + i*2, 0);
    //addSegment(0, 0);
  }
  for (int i = 3; i < 100; i++) {
    float rand = random(-5, 5);
   // addSprite(i, 0, 1.1f * sign(rand) + rand);
  }
  addCoins(20,100,1);
}


float CAMERA_DEPTH = 1 / tan(fov/2 * PI / 180.0f);
int DRAW_DISTANCE = 200;
float[] sCameraX = new float[DRAW_DISTANCE];
float[] sCameraY = new float[DRAW_DISTANCE];
float[] sCameraZ = new float[DRAW_DISTANCE];
float[] sCurve = new float[DRAW_DISTANCE];

float[] sScreenScale = new float[DRAW_DISTANCE];
int[] sScreenX = new int[DRAW_DISTANCE];
int[] sScreenY = new int[DRAW_DISTANCE];
int[] sScreenW = new int[DRAW_DISTANCE];



int horizonY = scHeight;
void drawRoad() {
  CAMERA_DEPTH = 1 / tan(fov/2 * PI / 180.0f);
  int cameraSeg = floor(cameraZ/SEGMENT_LENGTH);

  float xOffset = 0;
  float positionInSegment = (cameraZ - cameraSeg * SEGMENT_LENGTH) / SEGMENT_LENGTH;
  printSc("posinseg: "+positionInSegment);
  float dXOffset = -positionInSegment * sPointsC.get(cameraSeg);
  //float dXOffset = 0;
  horizonY = scHeight;

  for (int i = 0; i < DRAW_DISTANCE; i++) {
    int segId = (cameraSeg + i) % numSegs;
    sCameraX[i] = sPointsX.get(segId) - cameraX - xOffset;
    sCameraY[i] = sPointsY.get(segId) - cameraY;
    sCameraZ[i] = sPointsZ.get(segId) - cameraZ;
    
    
    dXOffset += sPointsC.get(segId);
    xOffset += dXOffset;
    
    sScreenScale[i] = CAMERA_DEPTH / sCameraZ[i];
    // as it is, this is stretching a 1:1 screen, i guess you'd need to add an extra virtual world step before actually projectin to the screen to avoid that
    sScreenX[i] = round(scWidth/2 + sCameraX[i]*sScreenScale[i]*scWidth/2);
    sScreenY[i] = round(scHeight/2 - sCameraY[i]*sScreenScale[i]*scHeight/2);
    sScreenW[i] = round(sScreenScale[i] * SEGMENT_WIDTH * scWidth/2);
  
    if (sCameraZ[i] <= CAMERA_DEPTH) continue;
    horizonY = min(horizonY, sScreenY[i]);

    
  }
    display.stroke(200); display.strokeCap(SQUARE); display.strokeWeight(1);
  //display.fill(40);
  display.imageMode(CORNER);
  display.image(background, 0, horizonY- 18, scWidth,20);
  
  display.noFill();
  display.line(0,horizonY - 1, scWidth,horizonY - 1);
  
  
  for (int j = DRAW_DISTANCE - 1; j > 0; j--) {
    int i = j - 1;
    if (sCameraZ[i] <=  CAMERA_DEPTH) continue;
    
    display.noStroke();
    display.fill(245);
    int segId = (cameraSeg + i) % numSegs;
    if (segId % 14 < 7 || i > 60) display.fill(235);
    trapezoid(0, scWidth, 0, scWidth, sScreenY[j], sScreenY[i]);
    
    
    display.strokeWeight(2);
    display.fill(245);
    if (segId % 5 < 2) display.fill(255);
    trapezoid4(sScreenX[j]-sScreenW[j], sScreenX[j] + sScreenW[j], sScreenX[i] - sScreenW[i], sScreenX[i] + sScreenW[i], sScreenY[j], sScreenY[i],0 + i *2);
    
    // sharp edge detection
    if (j < DRAW_DISTANCE - 1)
      if (sCameraY[j + 1] - sCameraY[j] < -40) {
        display.stroke(0);
        display.line(0, sScreenY[j]+1, scWidth, sScreenY[j] - 1);
      }
      
    if (round((playerZ-cameraZ)/ SEGMENT_LENGTH) == i)
      drawPlayer();
    
    if (sSpriteSrc.get(segId) != null) {
      int sprInd = sSpriteSrc.get(segId);
      float w = sScreenScale[i] * spriteScaleX.get(sprInd) * scWidth / 2;
      float h = sScreenScale[i] * spriteScaleY.get(sprInd) * scHeight/ 2;
      
      int sprScreenX = round(scWidth/2 +(sScreenScale[i]*(sCameraX[i]+sSpriteOff.get(segId)*SEGMENT_WIDTH))*scWidth/2);
      int sprScreenY = round(sScreenY[i] - h / 2);
      
      display.imageMode(CENTER);
      display.image(spriteImg.get(sprInd), sprScreenX, sprScreenY,w,h);            
    }
    
    
    // coin
    if (sCoinExists.get(segId) != null && sCoinExists.get(segId)) {
      float w = sScreenScale[i] * coinScaleX * scWidth / 2;
      float h = sScreenScale[i] * coinScaleY * scHeight/ 2;
      
      float yOff = sin(millis()/200.0f+ 5* segId)*1 + 5;
      int sprScreenX = round(scWidth/2 +(sScreenScale[i]*(sCameraX[i]+sCoinX.get(segId)*SEGMENT_WIDTH))*scWidth/2);
      int sprScreenY = round(scHeight/2 - sScreenScale[i] * scHeight/2 * (sCameraY[i] + yOff));
      sprScreenY -= h / 2;

      display.stroke(10 + i); display.strokeWeight(.2f * sScreenScale[i] * scWidth/2); display.strokeCap(ROUND);
      display.line(sprScreenX-w/2, sScreenY[i] - 2, sprScreenX + w/2, sScreenY[i] - 2);
      
      display.imageMode(CENTER);
      display.image(coin, sprScreenX, sprScreenY,w,h);     
    }
    
    
    
  }
  
  
  
}
