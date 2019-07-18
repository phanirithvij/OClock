class Dial{
  PVector start;
  Spike[] spikes;
  float offAngle = PI / 180;
  float initAngle;
  float angle;
  float r;
  float value;
  PVector end;
  int type;
  Dial(PVector orange, float r, float angle, int type){
    println("new Dial");
    this.start = orange;
    this.r = r;
    this.initAngle = angle;
    this.angle = angle;
    this.type = type;
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
  
  private int getColor(){
    switch(this.type){
      case MIN:
        return 50;
      case HOUR:
        return 100;
      case SEC:
        return 200;
      default:
        return 0;
    }
  }

  void draw(){
    int col = getColor();
    println(this.type, col);
    fill(col);
    float angle;
    if (this.type == MIN || this.type == SEC){
      angle = map(this.value, 0, 60, 0, 2*PI);
    } else {
      angle = map(this.value % 12, 0, 12, 0, 2*PI);
    }
    
    push();
    strokeWeight(8);
    stroke(200);
    translate(this.start.x, this.start.y);
    circle(0, 0, 20);
    rotate(angle - PI/2);
    if (this.type == MIN)
      line(0, 0, 200, 0);
    else if (this.type == SEC)
      line(0, 0, 210, 0);
    else
      line(0, 0, 100, 0);
    pop();
  }
}
