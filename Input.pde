int input = 0;

boolean up = false;
boolean left = false;
boolean down = false;
boolean right = false;
boolean i = false;
boolean k = false;
boolean c = false;


boolean upp = false;
boolean leftp = false;
boolean downp = false;
boolean rightp = false;
boolean cp = false;

int axisX = 0;
int axisY = 0;
void updateInput() {
  // socd override+reactivate
  if (axisX == 0) {
    if (right) {
      axisX = 1;
    }
    else if (left) {
      axisX = -1;
    }
  }
  else {
    if (axisX == 1 && !right) {
      axisX = 0;
      if (left) {
        axisX = -1;
      }
    }
    else if (axisX == -1 && !left) {
      axisX = 0;
      if (right) {
        axisX = 1;
      }
    }
    else if (rightp) {
      axisX = 1;
    }
    else if (leftp) {
      axisX = -1;
    }
  }

  
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if (!up) upp = true;
      up = true;
    }
    if (keyCode == LEFT) {
      if (!left) leftp = true;
      left = true;
    }
    if (keyCode == DOWN) {
      if (!down) downp = true;
      down = true;
    }
    if (keyCode == RIGHT) {
      if (!right) rightp = true;
      right = true;
    }
  }
  if (key == 'w' || key == 'W') {
    if (!up) upp = true;
    up = true;
  }
  if (key == 'a' || key == 'A') {
    if (!left) leftp = true;
    left = true;
  }
  if (key == 's' || key == 'S') {
    if (!down) downp = true;
    down = true;
  }
  if (key == 'd' || key == 'D') {
    if (!right) rightp = true;
    right = true;
  }
  if (key == 'i' || key == 'I') {
    i = true;
  }
  if (key == 'k' || key == 'K') {
    k = true;
  }
  
  if (key == 'c' || key == 'C') {
    c = true;
  }
}
 
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP)
      up = false;
    if (keyCode == LEFT)
      left = false;
    if (keyCode == DOWN)
      down = false;
    if (keyCode == RIGHT)
      right = false;
  }
  if (key == 'w' || key == 'W')
    up = false;
  if (key == 'a' || key == 'A')
    left = false;
  if (key == 's' || key == 'S')
    down = false;
  if (key == 'd' || key == 'D')
    right = false;
  if (key == 'i' || key == 'I')
    i = false;
  if (key == 'k' || key == 'K')
    k = false;
  if (key == 'c' || key == 'C')
    c = false;
 
}
