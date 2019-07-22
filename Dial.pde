class Dial {
  PFont mono;
  float time = millis();
  Gear org;
  // roman numerals
  Dial(Gear org) {
    this.org = org;
    mono = createFont("fonts/Trajan_Pro_Bold.ttf", 32);
    textFont(mono);
    textAlign(CENTER);
  }

  void draw() {
    pushMatrix();
    pushStyle();
    fill(grey);
    //translate(displayWidth/2, displayHeight/2);
    translate(this.org.pos.x, this.org.pos.y);
    for (int i = 1; i< 13; i++) {
      if (i == 6 || i == 12) {
        pushMatrix();
        pushStyle();
        rotate((i*TWO_PI/12) -PI/2);
        fill(og.dialcolor);
        ellipse(217, 0, 30, 30);
        popStyle();
        popMatrix();
        continue;
      }
      // deal with i == 7
      // deal with roman rotations
      pushMatrix();
      rotate((i*TWO_PI/12) -PI/2);
      translate(217, 0);
      rotate(PI/2);
      translate(-217, 0);
      text(getRoman(i), 217, 0);
      popMatrix();
    }
    popStyle();
    popMatrix();
  }
}


String getRoman(int num) {
  switch (num) {
  case 1:
    return "I";
  case 2:
    return "II";
  case 3:
    return "III";
  case 4:
    return "IV";
  case 5:
    return "V";
  case 6:
    return "VI";
  case 7:
    return "VII";
  case 8:
    return "VIII";
  case 9:
    return "IX";
  case 10:
    return "X";
  case 11:
    return "XI";
  case 12:
    return "XII";
  default:
    return "D";
  }
}
