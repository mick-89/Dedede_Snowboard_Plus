float fov = 100;

float cameraHeight = 21;
float cameraX = 0;
float cameraY = 0;
float cameraZ = 0;


int pShake = 0;

float pWidth = 5, pHeight = 5;
float playerX = 0, playerY = 0, playerZ = 0;
float playerDY = 0;
int var_jump;

int jumpbuf = 0;
boolean prevc = false;


void updatePlayer() {
  pShake = max(pShake - 1, 0);

  int cameraSeg = floor(cameraZ/SEGMENT_LENGTH);
  int playerSeg = floor(playerZ/SEGMENT_LENGTH);
  float camPositionInSegment = (cameraZ - cameraSeg * SEGMENT_LENGTH) / SEGMENT_LENGTH;
  float pPositionInSegment = (playerZ - playerSeg * SEGMENT_LENGTH) / SEGMENT_LENGTH;


  //cameraY = max(cameraY - .5f, lerp(sPointsY.get(cameraSeg),sPointsY.get(cameraSeg+1), camPositionInSegment +.1f) + cameraHeight);
  if (i) cameraHeight+=0.1f;
  if (k) cameraHeight-=0.1f;
  if (right) cameraX +=1f;
  if (left) cameraX-=1f;
  if (up) cameraZ +=1f;
  if (down) cameraZ-=1f;
  /*if (rightp) {
   shakeLen = 40;
   shakeStr = 124;
   pShake = 40;
   }*/


  float ground = lerp(sPointsY.get(playerSeg), sPointsY.get(playerSeg+1), pPositionInSegment + .1f);
  playerY = max(playerY + playerDY, ground);


  if (c && !prevc) {
    jumpbuf = 10;
  } else if (c && prevc) {
    jumpbuf = max(jumpbuf - 1, 0);
  } else jumpbuf = 0;

  boolean jump = jumpbuf > 0;


  if (playerY <= ground) {
    playerDY = 0;
    if (jump) {
      playerDY = 5;
      var_jump = 5;
    }
  } else {
    if (playerDY > 1)
      playerDY = max(playerDY - .5f, -3.5f);
    else
      playerDY = max(playerDY- .25f, -3.5f);
    if (c && var_jump > 0) {
      var_jump = max(var_jump - 1, 0);
      playerDY = 5;
    } else var_jump = 0;
  }
  prevc = c;

  cameraY = playerY + cameraHeight;
  playerZ = cameraZ + 2*SEGMENT_LENGTH;
  playerX = cameraX;


  if (sCoinExists.get(playerSeg + 1) != null && sCoinExists.get(playerSeg + 1)) {
    if (abs(sCoinX.get(playerSeg + 1) * SEGMENT_WIDTH - playerX) < coinHitbox
      && abs(sPointsY.get(playerSeg+1) - playerY) < coinHitbox) {
      flash = 10;
      sCoinExists.put(playerSeg + 1, false);
    }
  }
}


float pCameraX, pCameraY, pCameraZ;
int pScreenX, pScreenY, pScreenW;

void drawPlayer() {
  if (true)
    return;
  pCameraX = playerX - cameraX;
  pCameraY = playerY - cameraY;
  pCameraZ = playerZ - cameraZ;

  float pScale = CAMERA_DEPTH / pCameraZ;

  pScreenX = round(scWidth / 2 + pCameraX * pScale * scWidth/2);
  pScreenY = round(scHeight / 2 - pCameraY * pScale * scHeight/2);

  float pScW = pScale * pWidth * scWidth / 2;
  float pScH = pScale * pHeight * scHeight / 2;

  display.imageMode(CENTER);
  display.tint((mouseX * 3 / scWidth) * 85 + 85);
  display.image(dedede, pScreenX + random(-pShake, pShake), pScreenY - pScH/2, pScW, pScH);
  display.tint(255, 255);
  display.imageMode(CORNER);

  display.fill(0);
  printSc("cam y:"+cameraY);
  printSc("p y:"+playerY);
}
