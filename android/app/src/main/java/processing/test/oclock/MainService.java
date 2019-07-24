package processing.test.oclock;
        
import processing.android.PWallpaper;
import processing.core.PApplet;

public class MainService extends PWallpaper {  
  @Override
  public PApplet createSketch() {
      return new OClock();
  }
}
