class Element {
  
  PVector ePosInit;
  PVector ePos;
  float eSize;
  color eColor;
  
  float eTheta;
  float ePhi;
  float eVelTheta;
  float eVelPhi;
  float eVelRandom;
  float eXVariance;
  float eYVariance;
  int eGlowSelect;
  
  Element(float x, float y, float z, float theta, float phi, float xVariance, float yVariance){
    ePosInit = new PVector(x, y, z);
    ePos = new PVector(0, 0, 0);
    eSize = 15;
    eColor = color(cp.colors[(int)random(cp.colors.length)]);
    
    eTheta = theta;
    ePhi = phi;
    eVelTheta = TWO_PI/(4*thetaD);
    eVelPhi = PI/(phiD);
    eVelRandom = random(PI/100.0);
    eXVariance = xVariance;
    eYVariance = yVariance;
    eGlowSelect = (int)random(2);
  }
  
  void update() {
    eVelTheta = TWO_PI/(4*thetaD);
    eVelPhi = PI/(phiD);    
    
   if(elementBehavior % 2 ==0) {
    eTheta += eVelTheta;
    ePhi += eVelPhi;
   }
   else {
      eTheta += eVelRandom;
//      ePhi += eVelRandom;
   }
 //    ePos = ePosInit;
    ePos.x = discRadius * cos(eTheta) * sin(ePhi) ; // 
    ePos.y = discRadius * sin(eTheta) * sin(ePhi) ;
    ePos.z = discRadius * cos(ePhi);

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
      

  }
  
  void paintVetrices () {
    pushMatrix();
    stroke(eColor);
    strokeWeight(30);
//    noStroke();
//    vertex(ePos.x, ePos.y, ePos.z);

    translate(ePos.x, ePos.y, ePos.z);
  //bill boarding to face camera at all times
    float[] rot = cam.getRotations();
    rotateX(rot[0]);
    rotateY(rot[1]);
    rotateZ(rot[2]);

//    if(eGlowSelect == 0) {
      image(glow2b, - 8, -8, 16, 16);    
      image(glow1b, - 4, - 4, 8, 8);
//    }
//    else {
//      image(glow2b, - 8, - 8, 16, 16);    
//      image(glow1b, - 4, - 4, 8, 8);
//    }

    popMatrix();
  }
  
  void reset() {
    ePos.x = 0;
    ePos.y = 0;
    ePos.z = 0;
  }
}

