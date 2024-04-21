// drawing -----------------------------------------------------------------------------------------------------------
int cursorPosition = 0;


void printSc(Object s) {
  display.text(s.toString(), cursorPosition % scWidth, cursorPosition / scWidth);
  cursorPosition += scWidth * (int)display.textSize;
}
void printSc(Object s, int x, int y) {
  display.text(s.toString(), x, y);
  cursorPosition = (int)(y + display.textSize) * scWidth + x;
}
void trapezoid4(int tlx, int trx, int blx, int brx, int ty, int by, color c) {
  display.noStroke();
  display.beginShape();
  display.vertex(tlx, ty);
  display.vertex(trx, ty);
  display.vertex(brx, by);
  display.vertex(blx, by);  
  display.endShape(CLOSE);
  
  display.stroke(c);
  display.line(brx, by, trx, ty);
  display.line(blx, by, tlx, ty);
}
void trapezoid3(int tlx, int trx, int blx, int brx, int ty, int by) {
  display.line(brx, by, trx, ty);
  display.line(blx, by, tlx, ty);
}
void trapezoid2(int tlx, int trx, float blx, float brx, int ty, int by) {
  // top is the smaller y
  if (ty > by)
    return;
    
  if (ty - by + 1 == 1)
    line(blx, ty, brx, ty);
  else {
    float m1 = (float)(tlx - blx) / (float)(by - ty);
    printSc(m1);
    float m2 = (float)(trx - brx) / (float)(by - ty);
    for (int y = by; y >= ty; y--) {
      display.line(round(blx), y, round(brx), y);
      blx += m1;
      brx += m2;
    }
  }
}

void trapezoid(int tlx, int trx, int blx, int brx, int ty, int by) {
  display.beginShape();
  display.vertex(tlx, ty);
  display.vertex(trx, ty);
  display.vertex(brx, by);
  display.vertex(blx, by);  
  display.endShape(CLOSE);
}


void inputTest() {
  display.strokeWeight(1);
  if (up)
    display.fill(255);
  else
    display.fill(100);
  display.rect(8,0,8,8);
  
  if (left)
    display.fill(255);
  else
    display.fill(100);
  display.rect(0,8,8,8);
  
  if (down)
    display.fill(255);
  else
    display.fill(100);
  display.rect(8,8,8,8);
  
  if (right)
    display.fill(255);
  else
    display.fill(100);
  display.rect(16,8,8,8);
  
}

// logic -------------------------------------------------------------------------------------------------------------
int sign(float a) {
  if (a == 0) return 0;
  return a < 0 ? -1 : 1;
}

float appr(float val, float tar, float dval) {
  return tar > val ? min(val + dval, tar) : max(val - dval, tar);
}
float easeIn(float a, float b, float t) {
  return a + (b - a) * t * t;
}
float easeOut(float a, float b, float t) {
  return a + (b - a) * (1-(t-1)*(t-1));
}

float easeInOut(float a, float b, float t) {
  return a + (b - a) * ((-cos(t*PI)/2)+.5f);
}
