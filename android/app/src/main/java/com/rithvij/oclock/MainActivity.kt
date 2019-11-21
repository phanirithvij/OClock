package com.rithvij.oclock

import android.app.WallpaperManager
import android.content.ActivityNotFoundException
import android.content.ComponentName
import android.content.Intent
import android.os.Bundle
import android.util.Log
//import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        // Taken from Muzei
        // https://github.com/romannurik/muzei/blob/master/main/src/main/java/com/google/android/apps/muzei/IntroFragment.kt#L48
        // Which was taken from S.O.
        // https://stackoverflow.com/a/13240311/8608146
        start_action.setOnClickListener{
            try {
                startActivity(Intent(WallpaperManager.ACTION_CHANGE_LIVE_WALLPAPER)
                    .putExtra(WallpaperManager.EXTRA_LIVE_WALLPAPER_COMPONENT,
                        ComponentName(applicationContext,
                            MainService::class.java))
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
            } catch (e: ActivityNotFoundException) {
                Log.d("Oclock-MainActivity", "Not Changeable")
                try {
                    startActivity(Intent(WallpaperManager.ACTION_LIVE_WALLPAPER_CHOOSER)
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                } catch (e2: ActivityNotFoundException) {
                    Log.d("Oclock-MainActivity", "No HOPE")
                }
            }
        }
    }


}
