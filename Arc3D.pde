/**
 * An object that looks like a 3D arc
 * Arc3D class (super stripped down version) from : http://www.openprocessing.org/sketch/5452
 */
class Arc3D {
  
  float[] _tubeXi;
  float[] _tubeYi;
  float[] _tubeXo;
  float[] _tubeYo;
  
  int aResolution = 128;
  float aAngleStart, aAngleWidth;
  float aRadius, aElevation;
  float aSpeed, aOrientation, aTilt;
  color aFillColor;
  float aRoll = 0;
  
  public Arc3D(float angleStart, float angleWidth, float radius, float speed, float orientation, float elevation, color fillColor) {
    aAngleStart = angleStart;
    aAngleWidth = angleWidth;
    aRadius = radius;
    aElevation = elevation;
    aSpeed = speed;
    aOrientation = orientation;
    aFillColor = fillColor;
    aTilt = random(TWO_PI);
    
    setResolution(aResolution);
    recalculate();
  }
  
  void setResolution(int resolution) {
    aResolution = resolution;
    _tubeXi = new float[resolution];
    _tubeYi = new float[resolution];
  }
    
  void recalculate() {
    float angle = aAngleWidth / (aResolution - 1);
    for (int i = 0; i < aResolution; i++) {
      _tubeXi[i] = aRadius * cos(i * angle);
      _tubeYi[i] = aRadius * sin(i * angle);
    }
  }
  
  void display() {
//    aRadius +=  sin(frameCount * HALF_PI / frameRate);
//    recalculate();
    
    strokeWeight(5);
    stroke(aFillColor);
//    fill(aFillColor);
    pushMatrix();
    rotateX(aOrientation);
    rotateY(aAngleStart);
    rotateZ(aTilt);
    
//    noStroke();
    
    noFill();
    beginShape();
    for (int i = 0; i < aResolution; i++) {    
        vertex(_tubeXi[i], 0 , _tubeYi[i]);
//      vertex(_tubeXi[i], aElevation, _tubeYi[i]);
    }
    endShape();
    popMatrix();
  }
}

