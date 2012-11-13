class Element {
  
  PVector ePosInit;
  PVector ePos;
  int eSize;
  color eColor;
  
  float eTheta;
  float eVel;
  
  Element(float x, float y, float z, float theta){
    ePosInit = new PVector(x, y, z);
    ePos = new PVector(0, 0, 0);
    eSize = (int)random(2, 5);
    eColor = color(cp.colors[(int)random(cp.colors.length)]);
    
    eTheta = theta;
    eVel = random(PI/100.0);
  }
  
  void update() {
    ePos.x = ePosInit.x + discRadius * cos(eTheta);
    ePos.y = ePosInit.y + discRadius * sin(eTheta);
    ePos.z = ePosInit.z;
    
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
  
  void paint () {
    pushMatrix();
    stroke(eColor);
    strokeWeight(3);
//    noFill();
    vertex(ePos.x, ePos.y, ePos.z);
    popMatrix();
  }
  
  void reset() {
    ePos.x = 0;
    ePos.y = 0;
    ePos.z = 0;
  }
}

