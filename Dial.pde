class Dial {
  PFont mono;
  // roman numerals
  Dial(){
    mono = loadFont("fonts/Trajan_Pro_Bold.ttf");
  }

  void draw(){
    textFont(mono);
    text("word", 12, 60);
  }
}
