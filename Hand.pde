
enum HandType {
  HOUR, MIN, SEC
}

final float MIN_HAND_LEN = 290;
final float SEC_HAND_LEN = 300;
final float HOUR_HAND_LEN = 180;

class Hand {
  PVector start;
  Gear org;
  float value;
  float angle;
  HandType type;
  Hand(Gear org, HandType type) {
    println("new Hand");
    this.start = org.pos;
    this.type = type;
    this.org = org;
  }

  private void showBounds(float handLength) {
    pushStyle();
    noFill();
    stroke(255);
    strokeWeight(5);
    rect(0, -10, handLength, 20);
    popStyle();
  }

  void draw() {
    if (this.type == HandType.MIN || this.type == HandType.SEC) {
      this.angle = map(this.value, 0, 60, 0, 2*PI);
    } else {
      this.angle = map(this.value % 12, 0, 12, 0, 2*PI);
    }

    pushMatrix();
    pushStyle();
    // disable Hand outline
    strokeWeight(0);
    translate(this.start.x, this.start.y);
    rotate(angle - PI/2);
    if (this.type == HandType.MIN) {
      fill(handgrey);
      triangle(0, 10, 0, -10, MIN_HAND_LEN, 0);

      if (bounds) showBounds(MIN_HAND_LEN);

      fill(0);
      ellipse(0, 0, 30, 30);
    } else if (this.type == HandType.SEC) {
      fill(handgrey);
      triangle(0, 10, 0, -10, SEC_HAND_LEN, 0);

      if (bounds) showBounds(SEC_HAND_LEN);

      fill(100);
      ellipse(0, 0, 20, 20);
    } else if (this.type == HandType.HOUR) {
      fill(this.org.dialcolor);
      triangle(0, 10, 0, -10, HOUR_HAND_LEN, 0);

      if (bounds) showBounds(HOUR_HAND_LEN);

      fill(0);
      ellipse(0, 0, 10, 10);
    }
    popStyle();
    popMatrix();
  }
}
