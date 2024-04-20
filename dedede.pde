int shakeLen = 0, shake = 0;
float shakeStr = 0;

int freeze = 0;

float dT = 0;
int scWidth = 600, scHeight = 600;
//int scWidth = 128, scHeight = 128;
PGraphics display;

PImage dedede;
PImage tree;

void setup() {
  // main window
  frameRate(60);
  size(600,600, P2D);
  surface.setTitle("De-de-de that's the name you should know");
  
  
  dedede = loadImage("data/DEDEDE.png");
  tree = loadImage("data/tree.png");
  
  display = createGraphics(scWidth, scHeight);


  
  makeRoad();
}

void _update() {
  updateInput();
  
  updatePlayer();
}

void _draw() {
  display.background(255);
    
  
  drawRoad();
  drawPlayer();
  printSc(cameraZ);
  inputTest();
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
    float strength = easeInOut(shakeStr, shakeStr/2, (float)shake/shakeLen);
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
