class Dial{
  PVector start;
  Spike[] spikes;
  float offAngle = PI / 180;
  float initAngle;
  float angle;
  float r;
  PVector end;
  Dial(PVector orange, float r, float angle){
    println("new Dial");
    this.start = orange;
    this.r = r;
    this.initAngle = angle;
    this.angle = angle;
    end = new PVector(this.start.x + this.r * cos(this.angle), this.start.y + this.r * sin(-this.angle));
  }

  void update(float offsetAngle){
    this.angle = this.initAngle + offsetAngle;
    end.x = this.start.x + this.r * cos(this.angle);
    end.y = this.start.y + this.r * sin(-this.angle);
  }
  void update(){
    end.x = this.start.x + this.r * cos(this.angle);
    end.y = this.start.y + this.r * sin(-this.angle);
  }

  void draw(){
    strokeWeight(8);
    stroke(200);
    fill(200);
    circle(this.start.x, this.start.y, 20);
    line(this.start.x, this.start.y, end.x, end.y);
    strokeWeight(2);
    stroke(0);
  }
}
