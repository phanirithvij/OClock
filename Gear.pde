class Gear{
  int numSp = 6;
  float iR = 10;
  float oR = 30;
  PVector pos;
  Spike[] spikes;
  float offAngle = PI / 180;
  Gear(float x, float y, float ir, float or, int spkes){
    println("new Gear");
    this.pos = new PVector(x, y);
    this.iR = ir;
    this.oR = or;
    this.numSp = spkes;
    initSpikes();
  }

  private void initSpikes(){
    spikes = new Spike[this.numSp];
    for (int i=0; i< this.numSp; i++){
      this.spikes[i] = new Spike(this.pos, this.oR, i*(2 * PI / this.numSp));
    }
  }

  void update(){
    for(int t=0; t<numSp; t++){
      this.spikes[t].update(this.offAngle);
    }
  }
  
  void draw(){
    //strokeWeight(8);
    //stroke(255);
    //fill(10, 2, 130);
    //circle(this.pos.x, this.pos.y, this.oR * 2);
    fill(243, 163, 42);
    circle(this.pos.x, this.pos.y, this.iR * 2);
    for (int i=0; i< this.numSp; i++){
      //this.spikes[i].draw();
    }
  }
}
