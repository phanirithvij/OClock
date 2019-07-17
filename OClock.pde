PImage oclock;
Gear[] gears;
Gear og;
Dial min;
Dial hour;
Dial sec;
boolean displayClock = true;
boolean doUpdate = true;

float posX=0, posY=0;

void setup (){
  fullScreen();
  //size(displayWidth, displayHeight);
  background(0);
  oclock = loadImage("o'clock.png");
  //og = new Gear(displayWidth/2, displayHeight/2, 55, 65, 18);
  og = new Gear(961, 540, 50, 67, 18);
  gears = new Gear[9];
  gears[0] = new Gear(949, 300, 43, 49, 8);
  gears[1] = new Gear(913.8, 363.8, 10, 20, 4);
  gears[2] = new Gear(882.4, 424.6, 44, 55, 14);
  gears[3] = new Gear(964, 443, 22, 36, 9);
  gears[4] = og;
  gears[5] = new Gear(885.6, 618, 30, 48, 12);
  gears[6] = new Gear(1022.8, 596.4, 13, 23, 6);
  gears[7] = new Gear(932, 704, 38, 49, 15);
  gears[8] = new Gear(862.8, 749.6, 19, 24, 9);
  
  min = new Dial(og.pos, 272, PI/6);
  hour = new Dial(og.pos, 171, 5*PI/6);
  sec = new Dial(og.pos, 272, -PI/2);
}

// orange circle
// r - 50 inner slices
// r - 8  innermost light orange circle
// r - 54 outer light orange circle
// r - 67 outermost radius containing spikes inside
// offsetAngle - 0.55850565 to align with image

// clock
// r - 217 inner roman numeral touching circle
// r - 231 circle passing through center of X in "XII"
// r - 242 circle containing roman numerals inside
// r - 272 minute hand radius
// r - 171 small hand radius

// r - 295 outermost radius that contains the whole clock

void draw(){
  background(0);
  //image(oclock, posX, posY);
  //image(oclock, 2, -11.4);
  if (displayClock){
    for (int i=0; i< 9; i++){
      gears[i].draw();
    }
  }
  if (doUpdate)
    og.update();

  min.draw();
  hour.draw();
  sec.draw();
}

void keyPressed(){
  if (key == 'd'){
    og.pos.x+=5;
    println("posx", og.pos.x);
  } else if (key == 'a'){
    og.pos.x-=5;
    println("posx", og.pos.x);
  }
  if (key == 'w'){
    og.pos.y-=5;
    println("posy", og.pos.y);
  } else if (key == 's'){
    og.pos.y+=5;
    println("posy", og.pos.y);
  }
  if (key == 'o'){
    og.iR ++;
    og.oR ++;
    for(int i=0; i < og.numSp; i++){
      og.spikes[i].r = og.oR;
    }
    println(og.iR);
  } else if (key == 'p'){
    og.iR --;
    og.oR --;
    for(int i=0; i < og.numSp; i++){
      og.spikes[i].r = og.oR;
    }
    println(og.iR);
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
  
  if (key == 'x'){
    saveFrame("images/line-######.png");
  }

}

void mousePressed(){
  println(mouseX, mouseY);
}

// 949, 300 - topmost gear (s - 8) (innerR - 4, innerR - 43, innerSpikeR - 49, outerSpikeR - 57)
// 913.8, 363.8 - next small gear (s - 4) (innerR - 3, innerR - 10, outerSpikeR - 20)
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
