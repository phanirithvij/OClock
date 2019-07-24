package processing.test.oclock;

import processing.core.*;

public class OClock extends PApplet {

    private PImage oclock;

    private Gear[] gears;
    private Gear og;

    private Hand min;
    private Hand hour;
    private Hand sec;

    private Dial dial;

    private int orange = color(247, 144, 24);
    //private int yellow = color(255, 230, 99);
    private int grey = color(82, 82, 73);
    private int handgrey = color(48, 48, 42);
    private int handorange = color(247, 100, 24);
    private int watermelon = color(214, 76, 83);
    private int tomato = color(255, 72, 0);
    private int kiwi = color(100, 195, 125);

    private boolean displayClock = true;
    private boolean displayImage = false;
    private boolean doUpdate = true;
    private boolean order = false;
    private boolean bounds = false;

    public String version = "v0.0.4-alpha";

    enum Mode {
        java, android
    }

    private Mode mode = getMode();

    // will be set to (displayWidth/2, displayHeight/2) in draw
    private float CENTERX = 961, CENTERY = 540;

    public void settings() {
        println(mode);
        fullScreen(P2D);
        //size(displayWidth, displayHeight);
    }

    public void setup() {
        oclock = loadImage("o'clock.png");
        //surface.setResizable(true);

        initGears();
        initHands();
        setHands();

        dial = new Dial(og);

        getMode();
    }

    private void initGears() {
        og = new OGear(0, 0, 54.0f, 67, 18, 1, new String[]{"ogears"});
        og.dialcolor = handorange;
        gears = new Gear[9];
        gears[0] = new Gear(-12, -240, 43, 55, 8, 1, new String[]{"ninja"});
        gears[1] = new Gear(-47.2f, -176.2f, 10, 20, 4, -1, new String[]{"plus"});
        gears[2] = new Gear(-78.6f, -115.4f, 44, 55, 14, 1, new String[]{"four"});
        gears[3] = new Gear(3.0f, -97.0f, 22, 36, 9, -1, new String[]{"pokemon"});
        gears[4] = og;
        gears[5] = new Gear(-75.4f, 78, 30, 48, 12, -1, new String[]{"wheel"});
        gears[6] = new Gear(61.8f, 56.4f, 13, 23, 6, -1, new String[]{"mine"});
        gears[7] = new Gear(-29, 164, 38, 56, 15, 1, new String[]{"sharingan"});
        gears[8] = new Gear(-98.2f, 209.6f, 19, 34, 9, -1, new String[]{"three"});
    }

    private void initHands() {
        min = new Hand(og, HandType.MIN);
        hour = new Hand(og, HandType.HOUR);
        sec = new Hand(og, HandType.SEC);
    }

// clock
// r - 217 inner roman numeral touching circle
// r - 231 circle passing through center of X in "XII"
// r - 242 circle containing roman numerals inside
// r - 272 minute hand radius
// r - 171 small hand radius

// r - 295 outermost radius that contains the whole clock

    public void draw() {
        // must have a background in draw to clear canvas
        background(0);
        //background(255, 204, 0);
        if (doUpdate) setHands();

        if (displayImage) {
            //image(oclock, 0, -52);
            image(oclock, 2, -11.4f);
        }

        if (displayClock) {
            //float scl = map(mouseY, 0, height, 1, 4);
            //if (frameCount % 10 == 0)
            //  println(scl);
            translate(og.pos.x, og.pos.y);
            if (mode == Mode.android)
                scale(2.02f);
            else scale(1.5f);
            translate(-og.pos.x, -og.pos.y);
            dial.draw();
            if (order) {
                drawHands();
            }
            for (int i = 0; i < 9; i++) {
                gears[i].draw();
            }
            if (!order) {
                drawHands();
            }
        }
    }

    private void setHands() {
        min.value = minute();
        sec.value = second();
        hour.value = hour();
    }

    private void drawHands() {
        min.draw();
        sec.draw();
        hour.draw();
    }

    public void keyPressed() {
        if (key == 'd') {
            //og.pos.x+=5;
            for (int i = 0; i < 9; i++) {
                gears[i].pos.x += 5;
            }
            println("posx", og.pos.x);
        } else if (key == 'a') {
            //og.pos.x-=5;
            for (int i = 0; i < 9; i++) {
                gears[i].pos.x -= 5;
            }
            println("posx", og.pos.x);
        }
        if (key == 'w') {
            //og.pos.y-=5;
            for (int i = 0; i < 9; i++) {
                gears[i].pos.y -= 5;
            }
            println("posy", og.pos.y);
        } else if (key == 's') {
            //og.pos.y+=5;
            for (int i = 0; i < 9; i++) {
                gears[i].pos.y += 5;
            }
            println("posy", og.pos.y);
        }
        if (key == 'o') {
            //og.iR ++;
            //og.oR ++;
            for (int i = 0; i < 9; i++) {
                gears[i].oR += 1;
            }
            println(og.oR);
        } else if (key == 'p') {
            //og.iR --;
            //og.oR --;
            for (int i = 0; i < 9; i++) {
                gears[i].oR -= 1;
            }
            println(og.oR);
        }

        if (key == ' ') displayClock = !displayClock;
        if (key == 'n') displayImage = !displayImage;
        if (key == 'v') doUpdate = !doUpdate;
        if (key == 'm') order = !order;
        if (key == 'b') bounds = !bounds;

        //https://forum.processing.org/two/discussion/comment/102455/#Comment_102455
        if (key == 'p') looping = !looping;
        if (key == 'r' && !looping) redraw();

        if (key == 'x') {
            saveFrame("images/" + version + "-######.png");
        }
    }

    public void mousePressed() {
        println(mouseX, mouseY);
        if (mouseX > 3 * displayWidth / 4) {
            og.loadAssets(new String[]{"ogears"});
            og.dialcolor = handorange;
        } else if (mouseX < displayWidth / 4) {
            og.loadAssets(new String[]{"watermelon"});
            og.dialcolor = watermelon;
        } else if (mouseX > displayWidth / 4 && mouseX < 2 * displayWidth / 4) {
            og.loadAssets(new String[]{"kiwi"});
            og.dialcolor = kiwi;
        } else if (mouseX > 2 * displayWidth / 4 && mouseX < 3 * displayWidth / 4) {
            og.loadAssets(new String[]{"tomato"});
            og.dialcolor = tomato;
        }
        gears[4] = og;
    }

    private Mode getMode() {
        return (System.getProperty("java.runtime.name").equals("Android Runtime")) ? Mode.android : Mode.java;
    }

    class Dial {
        PFont mono;
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
            for (int i = 1; i < 13; i++) {
                if (i == 6 || i == 12) {
                    pushMatrix();
                    pushStyle();
                    rotate((i * TWO_PI / 12) - PI / 2);
                    fill(og.dialcolor);
                    ellipse(217, 0, 30, 30);
                    popStyle();
                    popMatrix();
                    continue;
                }
                // deal with i == 7
                // deal with roman rotations
                pushMatrix();
                rotate((i * TWO_PI / 12) - PI / 2);
                translate(217, 0);
                rotate(PI / 2);
                translate(-217, 0);
                text(getRoman(i), 217, 0);
                popMatrix();
            }
            popStyle();
            popMatrix();
        }
    }


    private String getRoman(int num) {
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
// 949, 300 - topmost gear (s - 8) (innerR - 4, innerR - 43, innerSpikeR - 49, outerSpikeR - 57)
// 913.8, 363.8 - next small gear (s - 4) (innerR - 3, innerR - 10, outerSpikeR - 20) (scale - 0.62812495)
// 882.4, 424.6 - next gear 4 circle thing (s - 14) (innerR - 4, innerR - 44, outerSpikeR - 55)
// 4 circle thing small circles - (r - 14) (856.4, 424.2) centers separation - 26
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
        String[] names;
        PShape[] assets;
        int numSp;
        int driverTeeth = 18;
        float iR;
        float oR;
        PVector pos;
        PVector initPos;
        int Direction;
        float imwidth, imheight;
        int boundcolor = color(255);
        int dialcolor = watermelon;
        float currangle = PI / 360;

        Gear(float x, float y, float ir, float or, int spkes, int d, String[] namess) {
            println("new Gear");
            this.pos = new PVector(CENTERX + x, CENTERY + y);
            this.initPos = new PVector(x, y);
            this.iR = ir;
            this.oR = or;
            this.Direction = d;
            this.numSp = spkes;
            this.names = new String[namess.length];
            System.arraycopy(namess, 0, this.names, 0, namess.length);
            this.loadAssets();
        }

        void loadAssets() {
            // to load or refresh assets
            this.assets = new PShape[this.names.length];
            for (int i = 0; i < this.assets.length; i++) {
                this.assets[i] = loadShape("assets/" + this.names[i] + ".svg");
                println("orig: name: " + this.names[i], this.assets[i].width, this.assets[i].height);
            }
            this.imwidth = this.assets[0].width;
            this.imheight = this.assets[0].height;
        }

        void loadAssets(String[] namess) {
            float timenow = millis();
            this.names = new String[namess.length];
            System.arraycopy(namess, 0, this.names, 0, namess.length);
            loadAssets();
            println("time:", millis() - timenow);
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
            CENTERX = width >> 1;
            CENTERY = height >> 1;
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
            this.currangle += PI / 360 * this.driverTeeth / this.numSp;
            //time = millis();
            //}
            //this.currangle += PI/360 * this.driverRadius / this.oR;

            rotate(this.Direction * this.currangle);
            //scale(scl);
            scale(this.oR * 0.0022037036f);

            // translate to svg's center
            for (PShape asset : this.assets) {
                pushMatrix();
                translate(-asset.width / 2, -asset.height / 2);
                shape(asset, 0, 0);
                popMatrix();
            }

            // debug bounds
            if (bounds) showBounds();

            popStyle();
            popMatrix();
        }
    }

    class OGear extends Gear {
        OGear(float x, float y, float ir, float or, int spkes, int d, String[] namess) {
            super(x, y, ir, or, spkes, d, namess);
            boundcolor = orange;
        }
        // r - 50 inner slices
        // r - 8  innermost light orange circle
        // r - 54 outer light orange circle
        // r - 67 outermost radius containing spikes inside
    }

    enum HandType {
        HOUR, MIN, SEC
    }

    // ignore these warnings
    private final float MIN_HAND_LEN = 290;
    private final float SEC_HAND_LEN = 300;
    private final float HOUR_HAND_LEN = 180;

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
                this.angle = map(this.value, 0, 60, 0, 2 * PI);
            } else {
                this.angle = map(this.value % 12, 0, 12, 0, 2 * PI);
            }

            pushMatrix();
            pushStyle();
            // disable Hand outline
            strokeWeight(0);
            translate(this.start.x, this.start.y);
            rotate(angle - PI / 2);
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
                fill(og.dialcolor);
                triangle(0, 10, 0, -10, HOUR_HAND_LEN, 0);

                if (bounds) showBounds(HOUR_HAND_LEN);

                fill(0);
                ellipse(0, 0, 10, 10);
            }
            popStyle();
            popMatrix();
        }
    }
}
