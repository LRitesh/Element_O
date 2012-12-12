class Element {
  
  PVector ePosInit;
  PVector ePos;
  float eSize;
  float eNextSize;
  color eColor;
  float eOscillator = 0;
  
  float eRadius;
  float eTheta;
  float ePhi;
  float eVelTheta;
  float eVelPhi;
  float eVelRandom;
  float eXVariance;
  float eYVariance;
  int eGlowSelect;
  
  Element(float x, float y, float z, float theta, float phi){
    ePosInit = new PVector(x, y, z);
    ePos = new PVector(0, 0, 0);
    eColor = color(cp.colors[cpSelect][(int)random(cp.colors[cpSelect].length)]);
    eRadius = sphereR;
    
    eTheta = theta;
    ePhi = phi;
    eVelTheta = TWO_PI/(thetaD);
    eVelPhi = PI/(phiD);
    eVelRandom = random(-0.01,0.01);
    eGlowSelect = 0;//(int)random(2);
  }
  
  void update() {
    eOscillator += PI/200;
    
    if(pulsate)
      eNextSize = glowS * abs(sin(eOscillator));
    else
      eNextSize = glowS;
      
    if((int)eNextSize > (int)eSize) {
      eSize++;
    }
    else if((int)eNextSize < (int)eSize){
      eSize--;
    }
    
    eVelTheta = TWO_PI/(4*thetaD);
    eVelPhi = PI/(phiD);    
    
    switch(elementBehavior) {
     case 0: {
       eTheta += eVelTheta;
       break;
     }
     case 1: {
       eTheta += eVelTheta;
       ePhi += eVelPhi;
       break;
     }
     case 2: {
       eTheta += (eVelRandom * velS);
       ePhi += eVelPhi;
       break;
     }
     case 3: {
       eTheta += (eVelRandom * velS);
       ePhi += (eVelRandom * velS);
       break;
     }
    }

    if(sphereR > eRadius + 5)
      eRadius ++;
    else if(sphereR < eRadius - 5)
      eRadius --;
 
    ePos.x = eRadius * cos(eTheta) * sin(ePhi) ; // 
    ePos.y = eRadius * sin(eTheta) * sin(ePhi) ;
    ePos.z = eRadius * cos(ePhi);

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

    translate(ePos.x, ePos.y, ePos.z);
    
    //bill boarding to face camera at all times
    float[] rot = cam.getRotations();
    rotateX(rot[0]);
    rotateY(rot[1]);
    rotateZ(rot[2]);
  
    tint(eColor);
    image(glowBright, - eSize/2, - eSize/2, eSize, eSize);    
    image(star, - 4, - 4, 8, 8);

    popMatrix();
  }
  
  void paintLines () {
    if(drawElementLines) {
      elementLineAlpha += 0.01;
      
      if(elementLineAlpha > 128) {
        elementLineAlpha = 128;
      }
    }
    else {
      elementLineAlpha -= 0.01;
      
      if(elementLineAlpha < 0) {
        elementLineAlpha = 0;
      }
    }
    
    stroke(eColor, elementLineAlpha);
    strokeWeight(3);
    pushMatrix();

    noFill();
  
    vertex(ePos.x, ePos.y, ePos.z);

    popMatrix();
  }
  
  void reset() {
    ePos.x = 0;
    ePos.y = 0;
    ePos.z = 0;
  }
}

