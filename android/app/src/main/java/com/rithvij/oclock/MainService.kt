package com.rithvij.oclock

import processing.android.PWallpaper
import processing.core.PApplet

class MainService : PWallpaper() {
    override fun createSketch(): PApplet {
        return OClock()
    }
}
