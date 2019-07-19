PImage oclock;
Gear[] gears;
Gear og;
Hand min;
Hand hour;
Hand sec;
boolean displayClock = true;
boolean displayImage = false;
boolean doUpdate = true;
boolean order = true;

final int HOUR = 312334;
final int MIN  = 321867;
final int SEC  = 318783;

final float MIN_HAND_LEN = 290;
final float SEC_HAND_LEN = 300;
final float HOUR_HAND_LEN = 180;

final float CENTERX = 961, CENTERY = 540;
//final float CENTERX = 500, CENTERY = 500;

void setup (){
  fullScreen();
  //size(displayWidth, displayHeight);
  background(0);
  oclock = loadImage("o'clock.png");
  //og = new Gear(displayWidth/2, displayHeight/2, 55, 65, 18);

  initGears();

  min = new Hand(og.pos, 272, PI/6, MIN);
  hour = new Hand(og.pos, 171, 5*PI/6, HOUR);
  sec = new Hand(og.pos, 272, -PI/2, SEC);

  setHands();
}

void initGears(){
  og = new OGear(0, 0, 54.0, 67, 18, "ogears");
  gears = new Gear[9];
  gears[0] = new Gear(-12, -240, 43, 49, 8, "ninja");
  gears[1] = new Gear(-47.2, -176.2, 10, 20, 4, "plus");
  gears[2] = new Gear(-78.6, -115.4, 44, 55, 14, "four");
  gears[3] = new Gear(3.0, -97.0, 22, 36, 9, "pokemon");
  gears[4] = og;
  gears[5] = new Gear(-75.4, 78, 30, 48, 12, "wheel");
  gears[6] = new Gear(61.8, 56.4, 13, 23, 6, "mine");
  gears[7] = new Gear(-29, 164, 38, 49, 15, "sharingan");
  gears[8] = new Gear(-98.2, 209.6, 19, 24, 9, "three");
}

// clock
// r - 217 inner roman numeral touching circle
// r - 231 circle passing through center of X in "XII"
// r - 242 circle containing roman numerals inside
// r - 272 minute hand radius
// r - 171 small hand radius

// r - 295 outermost radius that contains the whole clock

void draw(){
  // must have a background in draw to clear canvas
  background(255);
  if (doUpdate){
    og.update();
    setHands();
  }
  if (displayImage)
  image(oclock, 2, -11.4);
  if (displayClock){
    if (order){
      drawHands();
    }
    for (int i=0; i< 9; i++){
      gears[i].draw();
    }
    if (!order){
      drawHands();
    }
  }
}

void setHands(){
  min.value = minute();
  sec.value = second();
  hour.value = hour();
  //println(hour.value, min.value, sec.value);
}

void drawHands(){
  min.draw();
  sec.draw();
  hour.draw();
}

void keyPressed(){
  if (key == 'd'){
    //og.pos.x+=5;
    for(int i=0;i < 9;i++){
      gears[i].pos.x += 5;
    }
    println("posx", og.pos.x);
  } else if (key == 'a'){
    //og.pos.x-=5;
    for(int i=0;i < 9;i++){
      gears[i].pos.x -= 5;
    }
    println("posx", og.pos.x);
  }
  if (key == 'w'){
    //og.pos.y-=5;
    for(int i=0;i < 9;i++){
      gears[i].pos.y -= 5;
    }
    println("posy", og.pos.y);
  } else if (key == 's'){
    //og.pos.y+=5;
    for(int i=0;i < 9;i++){
      gears[i].pos.y += 5;
    }
    println("posy", og.pos.y);
  }
  if (key == 'o'){
    og.iR ++;
    og.oR ++;
    //for(int i=0; i < og.numSp; i++){
    //  og.spikes[i].r = og.oR;
    //}
    println(og.oR);
  } else if (key == 'p'){
    og.iR --;
    og.oR --;
    //for(int i=0; i < og.numSp; i++){
    //  og.spikes[i].r = og.oR;
    //}
    println(og.oR);
  }
  if (key == 'u'){
    sec.angle += PI/360;
    sec.update();
    println(min.angle);
    //og.offAngle+=(PI/360);
  } else if (key == 'i'){
    sec.angle -= PI/360;
    sec.update();
    println(min.angle);
    //og.offAngle-=(PI/360);
  }

  if (key == ' '){
    displayClock = !displayClock;
  }
  if (key == 'v'){
    doUpdate = !doUpdate;
    //og.update();
    println(og.offAngle);
  }
  
  if (key == 'm') order = !order;
  if (key == 'n') displayImage = !displayImage;

  if (key == 'x'){
    saveFrame("images/line-######.png");
  }

}

void mousePressed(){
  println(mouseX, mouseY);
}
