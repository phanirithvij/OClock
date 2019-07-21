package com.rithvij.oclock;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class OClock extends PApplet {

PImage oclock;
Gear[] gears;
Gear og;
Hand min;
Hand hour;
Hand sec;
boolean displayClock = true;
boolean displayImage = false;
boolean doUpdate = true;
boolean order = false;
boolean bounds = false;

// <enum>
final int HOUR = 312334;
final int MIN  = 321867;
final int SEC  = 318783;
//

final float MIN_HAND_LEN = 290;
final float SEC_HAND_LEN = 300;
final float HOUR_HAND_LEN = 180;

float CENTERX = 961, CENTERY = 540;
//final float CENTERX = 500, CENTERY = 500;

public void settings() {
  size(displayWidth, displayHeight, P2D);
}

public void setup () {
  //fullScreen();
  //surface.setResizable(true);
  oclock = loadImage("o'clock.png");

  initGears();
  initHands();
  setHands();
}

public void initGears() {
  //og = new OGear(0, 0, 54.0, 67, 18, "drawing");
  og = new OGear(0, 0, 54.0f, 67, 18, "ogears");
  gears = new Gear[9];
  gears[0] = new Gear(-12, -240, 43, 49, 8, "ninja");
  gears[1] = new Gear(-47.2f, -176.2f, 10, 20, 4, "plus");
  gears[2] = new Gear(-78.6f, -115.4f, 44, 55, 14, "four");
  gears[3] = new Gear(3.0f, -97.0f, 22, 36, 9, "pokemon");
  gears[4] = og;
  gears[5] = new Gear(-75.4f, 78, 30, 48, 12, "wheel");
  gears[6] = new Gear(61.8f, 56.4f, 13, 23, 6, "mine");
  gears[7] = new Gear(-29, 164, 38, 56, 15, "sharingan");
  gears[8] = new Gear(-98.2f, 209.6f, 19, 34, 9, "three");
}

public void initHands() {
  min = new Hand(og.pos, 272, PI/6, MIN);
  hour = new Hand(og.pos, 171, 5*PI/6, HOUR);
  sec = new Hand(og.pos, 272, -PI/2, SEC);
}

// clock
// r - 217 inner roman numeral touching circle
// r - 231 circle passing through center of X in "XII"
// r - 242 circle containing roman numerals inside
// r - 272 minute hand radius
// r - 171 small hand radius

// r - 295 outermost radius that contains the whole clock

public void draw() {
  // must have a background in draw to clear canvas
  background(0);
  //background(255, 204, 0);
  if (doUpdate) setHands();

  if (displayImage) {
    //println(oclock);
    //image(oclock, 0, -52);
    image(oclock, 2, -11.4f);
  }


  if (displayClock) {
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
}

public void setHands() {
  min.value = minute();
  sec.value = second();
  hour.value = hour();
  //println(hour.value, min.value, sec.value);
}

public void drawHands() {
  min.draw();
  sec.draw();
  hour.draw();
}

public void keyPressed() {
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
    saveFrame("images/line-######.png");
  }
}

public void mousePressed() {
  println(mouseX, mouseY);
}
// 949, 300 - topmost gear (s - 8) (innerR - 4, innerR - 43, innerSpikeR - 49, outerSpikeR - 57)
// 913.8, 363.8 - next small gear (s - 4) (innerR - 3, innerR - 10, outerSpikeR - 20) (scale - 0.62812495)
// 882.4, 424.6 - next gear 4 circle thing (s - 14) (innerR - 4, innerR - 44, outerSpikeR - 55)
// 4 circle thing small circles - (r - 14) (856.4, 424.2) centers seperation - 26
// 964, 443 - next (pokemon) (s - 9) (innerR - 4, outerR - 9, innerR - 22, outerSpikeR - 36)
// above center
// 961, 540 - center (s - 18)
// below orange
// 885.6, 618 - next left (s - 12) (innerR - 4, outerR - 15, innerR - 30, innerSpikeR - 38, outerSpikeR - 48)
// 1022.8, 596.4 - next right small (s - 6) (innerSpikeR - 13, outerSpikeR - 23))
// 932, 704 - next sharingan (s - 15) (innerR - 4, outerR - 17, innerR - 38, innerSpikeR - 49, outerSpikeR - 56)
// 862.8, 749.6 - last gear (s - 9) (innerR - 4, outerR - 19, innerSpikeR - 24, outerSpikeR - 34)
// last gear circles - (r - 5) (872, 758.2 - bottom right), (865.8, 738 - top), (850.8, 753.2 - bottom left)

class Gear {
  String name;
  PShape asset;
  int numSp = 6;
  float iR = 10;
  float oR = 30;
  PVector pos;
  PVector initPos;
  float imwidth, imheight;
  int grey = color(82, 82, 73);
  int boundcolor = color(255);
  Gear(float x, float y, float ir, float or, int spkes, String name) {
    println("new Gear");
    this.pos = new PVector(CENTERX + x, CENTERY + y);
    this.initPos = new PVector(x, y);
    //this.pos = new PVector(mouseX + x, mouseY + y);
    this.iR = ir;
    this.oR = or;
    this.numSp = spkes;
    this.name = name;
    this.asset = loadShape("assets/"+this.name+".svg");
    println("orig: name: "+name, this.asset.width, this.asset.height);
    this.imwidth = this.asset.width;
    this.imheight = this.asset.height;
    //println("upda: name: "+name, );
  }

  public void update() {
  }

  private void showBounds() {
    //pushMatrix();
    pushStyle();
    noFill();
    stroke(boundcolor);
    strokeWeight(10);
    rect(0, 0, imwidth, imheight);
    popStyle();
    //popMatrix();
  }

  public void draw() {
    CENTERX = width/2;
    CENTERY = height/2;
    this.pos.x = this.initPos.x + CENTERX;
    this.pos.y = this.initPos.y + CENTERY;

    pushMatrix();
    pushStyle();
    fill(grey);
    translate(this.pos.x, this.pos.y);
    //circle(0,0,this.oR * 2);
    //line(0, 0, mouseX-this.pos.x, mouseY-this.pos.y);
    popStyle();
    popMatrix();

    pushMatrix();
    pushStyle();
    //translate(mouseX + 240, mouseY - 240);
    float ang = map(mouseX, 0, width, 0, TWO_PI);
    //float scl = map(mouseY, 0, height, 0, 0.02);
    //println(this.oR * scl);

    translate(this.pos.x, this.pos.y);
    rotate(ang);
    //scale(scl);
    scale(this.oR * 0.0022037036f);
    //scale(this.oR * scl);

    translate(-this.asset.width/2, -this.asset.height/2);

    // these two
    //translate(49, -62.6);
    //scale(0.224);
    // are dependant

    shape(this.asset, 0, 0);

    if (bounds) showBounds();

    popStyle();
    popMatrix();
  }
}

class OGear extends Gear {
  int numSlices = 12;
  int orange = color(247, 144, 24);
  int yellow = color(255, 230, 99);
  OGear(float x, float y, float ir, float or, int spkes, String name) {
    super(x, y, ir, or, spkes, name);
    boundcolor = orange;
  }

  public void draw() {
    // r - 50 inner slices
    // r - 8  innermost light orange circle
    // r - 54 outer light orange circle
    // r - 67 outermost radius containing spikes inside
    // offsetAngle - 0.55850565 to align with image

    //push();
    //translate(this.pos.x, this.pos.y);
    ////float ang = map(mouseX, 0, width, 0, 2*PI);
    ////println(ang);
    ////rotate(ang);
    ////push();
    //translate(116, -149);
    //scale(0.535);
    //shape(this.asset, 0, 0);
    ////pop();
    ////shape(this.asset, 0, 0, mouseX, mouseY);
    //push();
    //noFill();
    //rect(0,0, imwidth, imheight);
    //pop();
    //pop();

    super.draw();
  }
}
class Hand {
  PVector start;
  float offAngle = PI / 180;
  float initAngle;
  float angle;
  float r;
  float value;
  PVector end;
  int type;
  Hand(PVector orange, float r, float angle, int type) {
    println("new Hand");
    this.start = orange;
    this.r = r;
    this.initAngle = angle;
    this.angle = angle;
    this.type = type;
    end = new PVector(this.start.x + this.r * cos(this.angle), this.start.y + this.r * sin(-this.angle));
  }

  public void update(float offsetAngle) {
    this.angle = this.initAngle + offsetAngle;
    end.x = this.start.x + this.r * cos(this.angle);
    end.y = this.start.y + this.r * sin(-this.angle);
  }
  public void update() {
    end.x = this.start.x + this.r * cos(this.angle);
    end.y = this.start.y + this.r * sin(-this.angle);
  }

  private void showBounds(float handLength) {
    pushStyle();
    noFill();
    stroke(255);
    strokeWeight(5);
    rect(0, -10, handLength, 20);
    popStyle();
  }

  public void draw() {
    float angle;
    if (this.type == MIN || this.type == SEC) {
      angle = map(this.value, 0, 60, 0, 2*PI);
    } else {
      angle = map(this.value % 12, 0, 12, 0, 2*PI);
    }

    pushMatrix();
    pushStyle();
    // disable Hand outline
    strokeWeight(0);
    //stroke(200);
    translate(this.start.x, this.start.y);
    rotate(angle - PI/2);
    if (this.type == MIN) {
      fill(48, 48, 42);
      triangle(0, 10, 0, -10, MIN_HAND_LEN, 0);

      if (bounds) showBounds(MIN_HAND_LEN);

      fill(0);
      ellipse(0, 0, 30, 30);
      //line(0, 0, MIN_HAND_LEN, 0);
    } else if (this.type == SEC) {
      fill(48, 48, 42);
      triangle(0, 10, 0, -10, SEC_HAND_LEN, 0);

      if (bounds) showBounds(SEC_HAND_LEN);

      fill(100);
      ellipse(0, 0, 20, 20);
      //line(0, 0, SEC_HAND_LEN, 0);
    } else if (this.type == HOUR) {
      fill(247, 100, 24);
      triangle(0, 10, 0, -10, HOUR_HAND_LEN, 0);

      if (bounds) showBounds(HOUR_HAND_LEN);

      fill(0);
      ellipse(0, 0, 10, 10);
      //line(0, 0, HOUR_HAND_LEN, 0);
    }
    popStyle();
    popMatrix();
  }
}
}
