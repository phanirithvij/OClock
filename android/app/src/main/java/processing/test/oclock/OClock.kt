package processing.test.oclock

import processing.core.*

class OClock : PApplet() {

    private lateinit var oclock: PImage

    private lateinit var gears: Array<Gear>
    private lateinit var og: OGear

    private lateinit var min: Hand
    private lateinit var hour: Hand
    private lateinit var sec: Hand

    private lateinit var dial: Dial

    private val orange = color(247, 144, 24)
    //private int yellow = color(255, 230, 99);
    private val grey = color(82, 82, 73)
    private val handgrey = color(48, 48, 42)
    private val handorange = color(247, 100, 24)
    private val watermelon = color(214, 76, 83)
    private val tomato = color(255, 72, 0)
    private val kiwi = color(100, 195, 125)

    private var displayClock = true
    private var doUpdate = true
    private var order = false
    private var bounds = false

    var version = "v0.0.4-alpha"

    // will be set to (displayWidth/2, displayHeight/2) in draw
    private var centerx = 961f
    private var centery = 540f

    private val minHandLen = 290f
    private val secHandLen = 300f
    private val hourHandLen = 180f

    override fun settings() {
        fullScreen(PConstants.P2D)
    }

    override fun setup() {
        oclock = loadImage("o'clock.png")

        initGears()
        initHands()
        setHands()

        dial = Dial(og)
    }

    private fun initGears() {
        og = OGear(0f, 0f, 67f, 18, 1, arrayOf("ogears"))
        og.dialcolor = handorange
        gears = Array(9) { Gear(0f,0f,0f,0,1, arrayOf("")) }
        gears[0] = Gear(-12f, -240f, 55f, 8, 1, arrayOf("ninja"))
        gears[1] = Gear(-47.2f, -176.2f, 20f, 4, -1, arrayOf("plus"))
        gears[2] = Gear(-78.6f, -115.4f, 55f, 14, 1, arrayOf("four"))
        gears[3] = Gear(3.0f, -97.0f, 36f, 9, -1, arrayOf("pokemon"))
        gears[4] = og
        gears[5] = Gear(-75.4f, 78f, 48f, 12, -1, arrayOf("wheel"))
        gears[6] = Gear(61.8f, 56.4f, 23f, 6, -1, arrayOf("mine"))
        gears[7] = Gear(-29f, 164f, 56f, 15, 1, arrayOf("sharingan"))
        gears[8] = Gear(-98.2f, 209.6f, 34f, 9, -1, arrayOf("three"))
    }

    private fun initHands() {
        min = Hand(og, HandType.MIN)
        hour = Hand(og, HandType.HOUR)
        sec = Hand(og, HandType.SEC)
    }

    override fun draw() {
        // must have a background in draw to clear canvas
        background(0)
        if (doUpdate) setHands()
        if (displayClock) {
            translate(og.pos.x, og.pos.y)
            scale(2.02f)
            translate(-og.pos.x, -og.pos.y)
            dial.draw()
            if (order) {
                drawHands()
            }
            for (i in 0..8) {
                gears[i].draw()
            }
            if (!order) {
                drawHands()
            }
        }
    }

    private fun setHands() {
        min.value = PApplet.minute().toFloat()
        sec.value = PApplet.second().toFloat()
        hour.value = PApplet.hour().toFloat()
    }

    private fun drawHands() {
        min.draw()
        sec.draw()
        hour.draw()
    }

    override fun mousePressed() {
        println(mouseX, mouseY)
        if (mouseX > 3 * displayWidth / 4) {
            og.loadAssets(arrayOf("ogears"))
            og.dialcolor = handorange
        } else if (mouseX < displayWidth / 4) {
            og.loadAssets(arrayOf("watermelon"))
            og.dialcolor = watermelon
        } else if (mouseX > displayWidth / 4 && mouseX < 2 * displayWidth / 4) {
            og.loadAssets(arrayOf("kiwi"))
            og.dialcolor = kiwi
        } else if (mouseX > 2 * displayWidth / 4 && mouseX < 3 * displayWidth / 4) {
            og.loadAssets(arrayOf("tomato"))
            og.dialcolor = tomato
        }
        gears[4] = og
    }

    // roman numerals
    internal inner class Dial(var org: Gear) {
        private var mono: PFont = createFont("fonts/Trajan_Pro_Bold.ttf", 32f)

        init {
            textFont(mono)
            textAlign(PConstants.CENTER)
        }

        fun draw() {
            pushMatrix()
            pushStyle()
            fill(grey)
            translate(this.org.pos.x, this.org.pos.y)
            for (i in 1..12) {
                if (i == 6 || i == 12) {
                    pushMatrix()
                    pushStyle()
                    rotate(i * PConstants.TWO_PI / 12 - PConstants.PI / 2)
                    fill(og.dialcolor)
                    ellipse(217f, 0f, 30f, 30f)
                    popStyle()
                    popMatrix()
                    continue
                }
                // deal with i == 7
                // deal with roman rotations
                pushMatrix()
                rotate(i * PConstants.TWO_PI / 12 - PConstants.PI / 2)
                translate(217f, 0f)
                rotate(PConstants.PI / 2)
                translate(-217f, 0f)
                text(getRoman(i), 217f, 0f)
                popMatrix()
            }
            popStyle()
            popMatrix()
        }
    }


    private fun getRoman(number: Int): String {
        return when (number) {
            1 -> "I"
            2 -> "II"
            3 -> "III"
            4 -> "IV"
            5 -> "V"
            6 -> "VI"
            7 -> "VII"
            8 -> "VIII"
            9 -> "IX"
            10 -> "X"
            11 -> "XI"
            12 -> "XII"
            else -> "D"
        }
    }

    internal open inner class Gear(
        x: Float,
        y: Float,
        private var oR: Float,
        private var numSp: Int,
        private var Direction: Int,
        namess: Array<String>
    ) {
        private var names: Array<String>
        private lateinit var assets: Array<PShape>
        private var driverTeeth = 18
        var pos: PVector
        private var initPos: PVector
        private var imwidth: Float = 0.toFloat()
        private var imheight: Float = 0.toFloat()
        var boundcolor = color(255)
        var dialcolor = watermelon
        private var currangle = PConstants.PI / 360

        init {
            println("new Gear")
            this.pos = PVector(centerx + x, centery + y)
            this.initPos = PVector(x, y)
            this.names = Array(namess.size) { "" }
            var i = 0
            while (i < namess.size){
                this.names[i] = namess[i]
                kotlin.io.println("fuck this ${this.names[i]}")
                i++
            }
            this.loadAssets()
        }

        private fun loadAssets() {
            // to load or refresh assets
            this.assets = Array(this.names.size) { PShape() }
            for (i in this.assets.indices) {
                kotlin.io.println("$i, ${this.names[i]}.svg")
                if (this.names[i].isNotEmpty())
                    this.assets[i] = loadShape("assets/" + this.names[i] + ".svg")
                println("orig: name: " + this.names[i], this.assets[i].width, this.assets[i].height)
            }
            this.imwidth = this.assets[0].width
            this.imheight = this.assets[0].height
        }

        fun loadAssets(namess: Array<String>) {
            val timenow = millis().toFloat()
            this.names = Array(namess.size) { "" }
            System.arraycopy(namess, 0, this.names, 0, namess.size)
            loadAssets()
            println("time:", millis() - timenow)
        }

        private fun showBounds() {
            pushStyle()
            noFill()
            stroke(boundcolor)
            strokeWeight(10f)
            rect(0f, 0f, imwidth, imheight)
            popStyle()
        }

        fun draw() {
            centerx = (width shr 1).toFloat()
            centery = (height shr 1).toFloat()
            this.pos.x = this.initPos.x + centerx
            this.pos.y = this.initPos.y + centery

            pushMatrix()
            pushStyle()

            translate(this.pos.x, this.pos.y)
            this.currangle += PConstants.PI / 360 * this.driverTeeth / this.numSp

            rotate(this.Direction * this.currangle)
            scale(this.oR * 0.0022037036f)

            // translate to svg's center
            for (asset in this.assets) {
                pushMatrix()
                translate(-asset.width / 2, -asset.height / 2)
                shape(asset, 0f, 0f)
                popMatrix()
            }

            // debug bounds
            if (bounds) showBounds()

            popStyle()
            popMatrix()
        }
    }

    internal inner class OGear(
        x: Float,
        y: Float,
        or: Float,
        spkes: Int,
        d: Int,
        namess: Array<String>
    ) : Gear(x, y, or, spkes, d, namess) {
        init {
            boundcolor = orange
        }
    }

    internal enum class HandType {
        HOUR, MIN, SEC
    }

    internal inner class Hand(var org: Gear, var type: HandType) {
        private var start: PVector
        var value: Float = 0.toFloat()
        private var angle: Float = 0.toFloat()

        init {
            println("new Hand")
            this.start = org.pos
        }

        private fun showBounds(handLength: Float) {
            pushStyle()
            noFill()
            stroke(255)
            strokeWeight(5f)
            rect(0f, -10f, handLength, 20f)
            popStyle()
        }

        fun draw() {
            if (this.type == HandType.MIN || this.type == HandType.SEC) {
                this.angle = map(this.value, 0f, 60f, 0f, 2 * PConstants.PI)
            } else {
                this.angle = map(this.value % 12, 0f, 12f, 0f, 2 * PConstants.PI)
            }

            pushMatrix()
            pushStyle()
            // disable Hand outline
            strokeWeight(0f)
            translate(this.start.x, this.start.y)
            rotate(angle - PConstants.PI / 2)
            when {
                this.type == HandType.MIN -> {
                    fill(handgrey)
                    triangle(0f, 10f, 0f, -10f, minHandLen, 0f)

                    if (bounds) showBounds(minHandLen)

                    fill(0)
                    ellipse(0f, 0f, 30f, 30f)
                }
                this.type == HandType.SEC -> {
                    fill(handgrey)
                    triangle(0f, 10f, 0f, -10f, secHandLen, 0f)

                    if (bounds) showBounds(secHandLen)

                    fill(100)
                    ellipse(0f, 0f, 20f, 20f)
                }
                this.type == HandType.HOUR -> {
                    fill(og.dialcolor)
                    triangle(0f, 10f, 0f, -10f, hourHandLen, 0f)

                    if (bounds) showBounds(hourHandLen)

                    fill(0)
                    ellipse(0f, 0f, 10f, 10f)
                }
            }
            popStyle()
            popMatrix()
        }
    }
}
