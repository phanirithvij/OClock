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

  void update(float offsetAngle) {
    this.angle = this.initAngle + offsetAngle;
    end.x = this.start.x + this.r * cos(this.angle);
    end.y = this.start.y + this.r * sin(-this.angle);
  }
  void update() {
    end.x = this.start.x + this.r * cos(this.angle);
    end.y = this.start.y + this.r * sin(-this.angle);
  }
  
  private void showBounds(float handLength){
    //pushMatrix();
    pushStyle();
    noFill();
    stroke(255);
    strokeWeight(5);
    rect(0, -10, handLength, 20);
    popStyle();
    //popMatrix();
  }

  void draw() {
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
