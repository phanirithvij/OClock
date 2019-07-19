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

class Gear{
  int numSp = 6;
  float iR = 10;
  float oR = 30;
  PVector pos;
  float offAngle = PI / 180;
  Gear(float x, float y, float ir, float or, int spkes){
    println("new Gear");
    this.pos = new PVector(CENTERX + x, CENTERY + y);
    this.iR = ir;
    this.oR = or;
    this.numSp = spkes;
    initSpikes();
  }

  private void initSpikes(){
    //spikes = new Spike[this.numSp];
    //for (int i=0; i< this.numSp; i++){
    //  this.spikes[i] = new Spike(this.pos, this.oR, i*(2 * PI / this.numSp));
    //}
  }

  void update(){
    //for(int t=0; t<numSp; t++){
    //  //this.spikes[t].update(this.offAngle);
    //}
  }
  
  void draw(){
    //strokeWeight(8);
    //stroke(255);
    //fill(10, 2, 130);
    //circle(this.pos.x, this.pos.y, this.oR * 2);
    fill(82, 82, 73);
    circle(this.pos.x, this.pos.y, this.iR * 2);
    //for (int i=0; i< this.numSp; i++){
    //  this.spikes[i].draw();
    //}
  }
}

class OGear extends Gear{
  PShape slice;
  PShape teeth;
  int numSlices = 12;
  float f = 0;
  float sliceR;
  float ya = (4*PI/360);
  float xa = (PI/numSlices - ya);
  float b = 8;
  float rx;
  OGear(float x, float y, float ir, float or, int spkes){
    super(x, y, ir, or, spkes);
    this.sliceR = this.iR * 50/54;
    slice = loadShape("assets/slices.svg");
    teeth = loadShape("assets/ogears.svg");
  }

  private void drawInterior(){
    this.sliceR = (this.iR * 50)/54;
    this.rx = (8* this.iR)/54;

    push();
    stroke(255, 230, 99);
    //stroke(0);
    translate(this.pos.x, this.pos.y);
    fill(247, 144, 24);
    strokeWeight(4);

    push();
    //float ang = map(mouseX, 0, width, 0, 1);
    //rotate(0.9523);
    //println(mouseX-1000, mouseY-1000);
    translate(-48, -48);

    push();
    //translate(mouseX-1000, mouseY-1000);
    translate(-20, -18);
    scale(0.42);
    shape(teeth);
    pop();
    
      push();
      translate(48, 48);
      //translate(mouseX-1000, mouseY-1000);
      fill(255, 230, 99);
      circle(0, 0, (this.iR-2) * 2);
      pop();

    scale(0.30);
    shape(slice);
    pop();

    pop();

  }

  void draw(){
    // r - 50 inner slices
    // r - 8  innermost light orange circle
    // r - 54 outer light orange circle
    // r - 67 outermost radius containing spikes inside
    // offsetAngle - 0.55850565 to align with image
    /*
      color middle - 255, 230, 99
      thick orange - 247, 144, 24
    */
    for (int i=0; i< this.numSp; i++){
      //this.spikes[i].draw();
    }
    drawInterior();
  }
}
