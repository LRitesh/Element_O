class Floater {
  
  PVector ePos;
  PVector eVel;
  int eGlowSelect;
  
  Floater(float x, float y, float z, int minVel, int maxVel){
    ePos = new PVector(x, y, z);
    eVel = new PVector(random(minVel, maxVel), random(minVel, maxVel), random(minVel, maxVel));
    eGlowSelect = 1;
  }
  
  void update() {
    ePos.x += eVel.x; // 
    ePos.y += eVel.y;
    ePos.z += eVel.z;

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

    if(eGlowSelect == 0) {
      image(glow2b, - 16, -16, 32, 32);    
      image(glow1b, - 4, - 4, 8, 8);
    }
    else {
      image(glow2b, - 16, - 16, 32, 32);    
//      image(glow1b, - 4, - 4, 8, 8);
    }

    popMatrix();
  }
  
  void reset() {
    ePos.x = 0;
    ePos.y = 0;
    ePos.z = 0;
  }
}

