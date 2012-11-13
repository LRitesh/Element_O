class Element {
  
  PVector ePos;
  PVector eVel;
  int eSize;
  color eColor;
  
  Element(float x, float y, float z){
    ePos = new PVector(x, y, z);
    eVel = new PVector(0, 0, 0);
    eSize = (int)random(2, 5);
    eColor = color(cp.colors[(int)random(cp.colors.length)]);
  }
  
  void update() {
//    eVel.x =  random(-1, 1);
//    eVel.y = random(-1, 1);
//    eVel.z = random(-1, 1);
//    ePos.add(eVel);
    
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

