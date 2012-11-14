class Element {
  
  PVector ePosInit;
  PVector ePos;
  float eSize;
  color eColor;
  
  float eTheta;
  float eVel;
  float eXVariance;
  float eYVariance;
  int eGlowSelect;
  
  Element(float x, float y, float z, float theta, float xVariance, float yVariance){
    ePosInit = new PVector(x, y, z);
    ePos = new PVector(0, 0, 0);
    eSize = 15;
    eColor = color(cp.colors[(int)random(cp.colors.length)]);
    
    eTheta = theta;
    eVel = random(PI/100.0);
    eXVariance = xVariance;
    eYVariance = yVariance;
    eGlowSelect = (int)random(2);
  }
  
  void update() {
    ePos.x = ePosInit.x + discRadius * cos(eTheta) + eXVariance; // 
    ePos.y = ePosInit.y + discRadius * sin(eTheta) + eYVariance;
    ePos.z = 0;
    
    if(ePos.x > width/2)
      ePos.x = -width/2;
    else if(ePos.x < -width/2)
      ePos.x = width/2;
      
    if(ePos.y > height/2)
      ePos.y = -height/2;
    else if(ePos.y < -height/2)
      ePos.y = height/2;
      
    if(ePos.z > zBoundary)
      ePos.z = -zBoundary;
    else if(ePos.z < -zBoundary)
      ePos.z = zBoundary;
      
    eTheta += eVel;
  }
  
  void paintVetrices () {
    pushMatrix();
    stroke(eColor);
    strokeWeight(eSize);
//    noStroke();
//    vertex(ePos.x, ePos.y, ePos.z);

  //bill boarding to face camera at all times
    float[] rot = cam.getRotations();
    rotateX(rot[0]);
    rotateY(rot[1]);
    rotateZ(rot[2]);

    if(eGlowSelect == 0)
      image(glow1, ePos.x - 4, ePos.y - 4, 8, 8);
    else 
      image(glow2, ePos.x - 16, ePos.y - 16, 32, 32);    
    popMatrix();
  }
  
  void paintPoints () {
    stroke(255, 0, 0, 128);
    strokeWeight(5);
    point(ePos.x, ePos.y, ePos.z);
  }
  
  void reset() {
    ePos.x = 0;
    ePos.y = 0;
    ePos.z = 0;
  }
}

