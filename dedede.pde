int shakeLen = 0, shake = 0;
float shakeStr = 0;

int freeze = 0;
int flash = 0;

float dT = 0;
int scWidth = 600, scHeight = 600;
//int scWidth = 128, scHeight = 128;
PGraphics display;

PImage dedede;
PImage cloud1;
PImage cloud2;
PImage coin;
PImage background;
PImage crosshair;


void setup() {
  // main window
  frameRate(60);
  size(600,600, P2D);
  surface.setTitle("De-de-de that's the name you should know");
  
  dedede = loadImage("data/DEDEDE.png");
  
  cloud1 = loadImage("data/nube1.png");
  cloud2 = loadImage("data/nube2.png");
  
  coin = loadImage("data/coin.png");
  
  background = loadImage("data/background.png");
  
  crosshair = loadImage("data/crosshair.png");
  surface.setCursor(crosshair, 8, 8);
  
  display = createGraphics(scWidth, scHeight);

  loadSprites();
  
  makeRoad();
}

void _update() {
  updateInput();
  
  updatePlayer();
}

void _draw() {
  
  
  display.background(255);
  for (int i = 0; i < scHeight / 3.0f; i++) {
    display.stroke(map(i, 0, scHeight/3.0f, 240, 255));
    display.line(0, i, scWidth, i);
  }

  

  display.image(cloud1, millis()/1000.0f + scWidth/2, 100, 100, 50);
  display.image(cloud2, millis()/750.0f + scWidth*2/3,50, 100, 50);
  drawRoad();
  //drawPlayer();
  printSc(cameraZ);
  inputTest();
  
  display.noStroke();
  display.fill(255, (float)flash * 255 / 10);
  display.rect(0, 0, scWidth, scHeight);
  flash = max(flash - 1, 0);
  
}






float prevTime = 0;
void draw() {
  float now = millis()/1000.0f;
  dT = now - prevTime;
  prevTime = now;
  
  
  cursorPosition = 0;
  
  
  // -------------------------------------------------------
  _update();
  // -------------------------------------------------------
  background(0);
  display.noSmooth();
  display.beginDraw();
  
  
  display.noStroke();
  display.textAlign(LEFT, TOP);
  display.textSize(scHeight/16.0f);
  _draw();
 
  
  // help me remember to "display."
  loadPixels();
  for (int x = 0; x < width; x++)
    for (int y = 0; y < height; y++)
      if (pixels[y * width + x] != -16777216)
        throw new RuntimeException("Don't render to surface directly, prefix with 'display.'");
      
 
  scale(width/(float)scWidth,height/(float)scHeight);
  //todo: this can be fine tuned a lot more than i thought
  // settings to add--> final strength, interpolation, frequency (how many frames between a change in x and y offsets), which axes to use
  // to define: set shake strength to be based on scW, scH pixels
  
  int xOff = 0, yOff = 0;
  if (shake < shakeLen) {
    //float strength = shakeStr;
    float strength = easeOut(shakeStr, shakeStr/2, (float)shake/shakeLen);
    //xOff = round(random(-strength, strength));
    yOff = round(random(-strength, strength));
    shake++;
    printSc("shakestr:"+strength);  
  
  
  }
  else {
    shakeLen = shake = 0;
    shakeStr = 0;
  } 
  display.endDraw();

  image(display, xOff, yOff);
    
  fill(10);
  text(frameRate,width/2,height/2);
  
  // btnp
  upp = false;
  leftp = false;
  downp = false;
  rightp = false;
}
