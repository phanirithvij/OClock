PImage oclock;

Gear[] gears;
Gear og;

Hand min;
Hand hour;
Hand sec;

Dial dial;

color orange = color(247, 144, 24);
color yellow = color(255, 230, 99);
color grey = color(82, 82, 73);
color handgrey = color(48, 48, 42);
color handorange = color(247, 100, 24);
color pink = color(214, 76, 83);
color tomato = color(255, 72, 0);
color kiwi = color(100, 195, 125);

boolean displayClock = true;
boolean displayImage = false;
boolean doUpdate = true;
boolean order = false;
boolean bounds = false;

String version  = "v0.0.4-alpha";

enum Mode {
  java, android
}

Mode mode = getMode();

// will be set to (displayWidth/2, displayHeight/2) in draw
float CENTERX = 961, CENTERY = 540;

void settings() {
  println(mode);
  fullScreen(P2D);
  //size(displayWidth, displayHeight);
}

void setup () {
  oclock = loadImage("o'clock.png");
  //surface.setResizable(true);

  initGears();
  initHands();
  setHands();

  dial = new Dial(og);

  getMode();
}

void initGears() {
  //og = new OGear(0, 0, 54.0, 67, 18, 1, "watermelon");
  //og.dialcolor = pink;
  og = new OGear(0, 0, 54.0, 67, 18, 1, "ogears");
  og.dialcolor = handorange;
  gears = new Gear[9];
  gears[0] = new Gear(-12, -240, 43, 55, 8, 1, "ninja");
  gears[1] = new Gear(-47.2, -176.2, 10, 20, 4, -1, "plus");
  gears[2] = new Gear(-78.6, -115.4, 44, 55, 14, 1, "four");
  gears[3] = new Gear(3.0, -97.0, 22, 36, 9, -1, "pokemon");
  gears[4] = og;
  gears[5] = new Gear(-75.4, 78, 30, 48, 12, -1, "wheel");
  gears[6] = new Gear(61.8, 56.4, 13, 23, 6, -1, "mine");
  gears[7] = new Gear(-29, 164, 38, 56, 15, 1, "sharingan");
  gears[8] = new Gear(-98.2, 209.6, 19, 34, 9, -1, "three");
}

void initHands() {
  min = new Hand(og, HandType.MIN);
  hour = new Hand(og, HandType.HOUR);
  sec = new Hand(og, HandType.SEC);
}

// clock
// r - 217 inner roman numeral touching circle
// r - 231 circle passing through center of X in "XII"
// r - 242 circle containing roman numerals inside
// r - 272 minute hand radius
// r - 171 small hand radius

// r - 295 outermost radius that contains the whole clock

void draw() {
  // must have a background in draw to clear canvas
  background(0);
  //background(255, 204, 0);
  if (doUpdate) setHands();

  if (displayImage) {
    //image(oclock, 0, -52);
    image(oclock, 2, -11.4);
  }

  if (displayClock) {
    pushMatrix();
    //float scl = map(mouseY, 0, height, 1, 4);
    //if (frameCount % 10 == 0)
    //  println(scl);
    translate(og.pos.x, og.pos.y);
    if (mode == Mode.android)
      scale(2.02);
    translate(-og.pos.x, -og.pos.y);
    dial.draw();
    if (order) {
      drawHands();
    }
    for (int i=0; i< 9; i++) {
      gears[i].draw();
    }
    if (!order) {
      drawHands();
    }
  }
  popMatrix();
}

void setHands() {
  min.value = minute();
  sec.value = second();
  hour.value = hour();
}

void drawHands() {
  min.draw();
  sec.draw();
  hour.draw();
}

void keyPressed() {
  if (key == 'd') {
    //og.pos.x+=5;
    for (int i=0; i < 9; i++) {
      gears[i].pos.x += 5;
    }
    println("posx", og.pos.x);
  } else if (key == 'a') {
    //og.pos.x-=5;
    for (int i=0; i < 9; i++) {
      gears[i].pos.x -= 5;
    }
    println("posx", og.pos.x);
  }
  if (key == 'w') {
    //og.pos.y-=5;
    for (int i=0; i < 9; i++) {
      gears[i].pos.y -= 5;
    }
    println("posy", og.pos.y);
  } else if (key == 's') {
    //og.pos.y+=5;
    for (int i=0; i < 9; i++) {
      gears[i].pos.y += 5;
    }
    println("posy", og.pos.y);
  }
  if (key == 'o') {
    //og.iR ++;
    //og.oR ++;
    for (int i=0; i < 9; i++) {
      gears[i].oR += 1;
    }
    println(og.oR);
  } else if (key == 'p') {
    //og.iR --;
    //og.oR --;
    for (int i=0; i < 9; i++) {
      gears[i].oR -= 1;
    }
    println(og.oR);
  }

  if (key == ' ') displayClock = !displayClock;
  if (key == 'n') displayImage = !displayImage;
  if (key == 'v') doUpdate = !doUpdate;
  if (key == 'm') order = !order;
  if (key == 'b') bounds = !bounds;

  //https://forum.processing.org/two/discussion/comment/102455/#Comment_102455
  if ( key == 'p' ) looping = !looping;
  if ( key == 'r' && looping==false ) redraw();

  if (key == 'x') {
    saveFrame("images/"+version+"-######.png");
  }
}

void mousePressed() {
  println(mouseX, mouseY);
  if (mouseX > 2*displayWidth/3) {
    og.loadAsset("ogears");
    og.dialcolor = handorange;
  } else if (mouseX < displayWidth/3) {
    og.loadAsset("watermelon");
    og.dialcolor = pink;
  } else if (mouseX > displayWidth/3 && mouseX < 2*displayWidth/3) {
    og.loadAsset("kiwi");
    og.dialcolor = kiwi;
  }
  gears[4] = og;
}

Mode getMode() {
  return (System.getProperty("java.runtime.name") == "Android Runtime") ? Mode.android : Mode.java;
}
