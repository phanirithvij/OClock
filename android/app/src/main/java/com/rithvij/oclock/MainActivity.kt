package com.rithvij.oclock

import android.os.Bundle
import android.content.Intent
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity

import processing.android.PFragment
import processing.android.CompatUtils
import processing.core.PApplet

class MainActivity : AppCompatActivity() {
    private var sketch: PApplet? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val frame = FrameLayout(this)
        frame.id = CompatUtils.getUniqueViewId()
        setContentView(frame, ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT))

        sketch = OClock()

        val fragment = PFragment(sketch)
        fragment.setView(frame, this)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        if (sketch != null) {
            sketch!!.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    public override fun onNewIntent(intent: Intent) {
        if (sketch != null) {
            sketch!!.onNewIntent(intent)
        }
    }

    public override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        if (sketch != null) {
            sketch!!.onActivityResult(requestCode, resultCode, data)
        }
    }

    override fun onBackPressed() {
        if (sketch != null) {
            sketch!!.onBackPressed()
        }
    }
}
