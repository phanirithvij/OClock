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
  float time=millis();
  String[] names;
  PShape[] assets;
  int numSp = 6;
  float driverRadius = 67;
  int driverTeeth = 18;
  float iR = 10;
  float oR = 30;
  PVector pos;
  PVector initPos;
  int Direction;
  float imwidth, imheight;
  color boundcolor = color(255);
  color dialcolor = pink;
  float currangle = PI/360;
  Gear(float x, float y, float ir, float or, int spkes, int d, String[] namess) {
    println("new Gear");
    this.pos = new PVector(CENTERX + x, CENTERY + y);
    this.initPos = new PVector(x, y);
    this.iR = ir;
    this.oR = or;
    this.Direction = d;
    this.numSp = spkes;
    this.names = new String[namess.length];
    for (int i=0; i < namess.length; i++){
      this.names[i] = namess[i];
    }
    this.loadAssets();
  }

  void loadAssets(){
    // to load or refresh assets
    this.assets = new PShape[this.names.length];
    for (int i=0; i < this.assets.length; i++){
      this.assets[i] = loadShape("assets/"+this.names[i]+".svg");
      println("orig: name: "+ this.names[i], this.assets[i].width, this.assets[i].height);
    }
    this.imwidth = this.assets[0].width;
    this.imheight = this.assets[0].height;
  }

  void loadAssets(String[] namess){
    this.names = new String[namess.length];
    for (int i=0; i < namess.length; i++){
      this.names[i] = namess[i];
    }
    loadAssets();
  }

  void update() {
  }

  private void showBounds() {
    pushStyle();
    noFill();
    stroke(boundcolor);
    strokeWeight(10);
    rect(0, 0, imwidth, imheight);
    popStyle();
  }

  void draw() {
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
    //float ang = map(mouseX, 0, width, 0, TWO_PI);
    //float scl = map(mouseY, 0, height, 0, 0.02);
    //println(this.oR * scl);

    translate(this.pos.x, this.pos.y);
    //if (millis() > time + 1000){
    this.currangle += PI/360 * this.driverTeeth / this.numSp;
      //time = millis();
    //}
    //this.currangle += PI/360 * this.driverRadius / this.oR;

    rotate(this.Direction * this.currangle);
    //scale(scl);
    scale(this.oR * 0.0022037036);

    // translate to svg's center
    for (int i=0; i< this.assets.length; i++){
      pushMatrix();
      translate(-this.assets[i].width/2, -this.assets[i].height/2);
      shape(this.assets[i], 0, 0);
      popMatrix();
    }

    // debug bounds
    if (bounds) showBounds();

    popStyle();
    popMatrix();
  }
}

class OGear extends Gear {
  int numSlices = 12;
  OGear(float x, float y, float ir, float or, int spkes, int d, String[] namess) {
    super(x, y, ir, or, spkes, d, namess);
    boundcolor = orange;
  }
  // r - 50 inner slices
  // r - 8  innermost light orange circle
  // r - 54 outer light orange circle
  // r - 67 outermost radius containing spikes inside
}
