class Spike{
  PVector gearP;
  float initAngle;
  float angle;
  float offsetA;
  float r;
  PVector pos;
  Spike(PVector gearP, float r, float theta){
    this.r = r;
    this.gearP = gearP;
    this.angle = theta;
    this.initAngle = theta;
    this.pos = new PVector(
      this.gearP.x + this.r * cos(this.angle),
      this.gearP.y + this.r * sin(this.angle)
    );
    println("new Spike");
  }

  void update(float newOffset){
    this.offsetA = newOffset;
    this.angle = this.initAngle + this.offsetA;
    this.pos.x = this.gearP.x + this.r * cos(this.angle);
    this.pos.y = this.gearP.y + this.r * sin(this.angle);
  }
  
  void update(){
    this.pos.x = this.gearP.x + this.r * cos(this.angle);
    this.pos.y = this.gearP.y + this.r * sin(this.angle);
  }

  void draw(){
    //strokeWeight(8);
    //stroke(255);
    fill(100, 200, 30);
    circle(this.pos.x, this.pos.y, 10);
  }
}
