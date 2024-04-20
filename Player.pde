float fov = 90;

float cameraX = 0;
float cameraY = 21;
float cameraZ = 0;



int playerSeg = 0;

int playerX = 0, playerY = 0;

void updatePlayer() {
  playerX = scWidth/2;
  if (i) cameraY+=0.1f;
  if (k) cameraY-=0.1f;
  if (right) cameraX +=0.1f;
  if (left) cameraX-=0.1f;
  if (up) cameraZ +=.5f;
  if (down) cameraZ-=.1f;
  playerSeg = 0;  
  if (upp) { shakeLen = 35; shakeStr = 124;}
  
}

void drawPlayer() {
  display.imageMode(CENTER);
  display.image(dedede, scWidth/2, scHeight*3/4);
  display.imageMode(CORNER);
}
