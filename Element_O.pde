// Element O
// Thousands of elements that come together and form concentric rings/discs
import processing.opengl.*;
import javax.media.opengl.*;

import oscP5.*;
import netP5.*;
OscP5 oscP5;

import peasy.*;
PeasyCam cam;

PGraphicsOpenGL pgl;
GL gl;

// element properties
Element[] elements;
boolean drawElementStars = true;
boolean drawElementLines = false;
float elementLineAlpha = 0;
int thetaD = 25;
int elementCount = (int)pow(thetaD, 2);
int phiD = thetaD;
float velS = 1.0;
float zBoundary = 1100;

// floaters
Floater[] floaters;
boolean drawFloaters = false;
int minFloaters = 500;
int maxFloaters = 500;

// sphere properties
float sphereR = 10;
int glowS = 2;
int elementBehavior = 0;
boolean pulsate = true;

// Bunch of 3D Arcs
Arc3D[] arcs;
boolean drawArcs = true;
int arcCount = 35;

ColorPalette cp;
int cpSelect = 0;
color bgColor = color(0);//color(242, 31, 12);

PImage glowBright;
PImage glowLite;
PImage star;

// other props
boolean rotateCam = false;
boolean showCursor = true;

void setup() {  
  size(screen.width, screen.height, OPENGL);
  
  // peasy cam
  cam = new PeasyCam(this, 600);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(zBoundary - 200);

  smooth();
  background(bgColor);

  glowBright = loadImage("glow_white_bright.png");
  glowLite = loadImage("glow_white_lite.png"); 
  star = loadImage("white_star_lite.png");

  //  translate(width, height, zBoundary);
  cp = new ColorPalette();

  // create elements along a sphere
  elements = new Element[elementCount];

  for (int i = 0; i < thetaD; i++) {
    for (int j = 0; j < phiD; j++) {
      float theta = TWO_PI*i/thetaD;
      float phi = PI*j/phiD;
      
      float x = sphereR * cos(theta) * sin(phi);
      float y = sphereR * sin(theta) * sin(phi);
      float z = sphereR * cos(phi);

      elements[i*phiD+j] = new Element(x, y, z, theta, phi);
    }
  }
  
  // create randomly floating floaters
  floaters = new Floater[(int) random(minFloaters, maxFloaters)]; 
  
  for (int i = 0; i < floaters.length; i++) {
    float x = random(-width/2, width/2);
    float y = random(-height/2, height/2);
    float z = random(-zBoundary, zBoundary);
    
    floaters[i] = new Floater(x, y, z, 1, 5);
  }
  
  // create arcs
  arcs = new Arc3D[arcCount];
  for(int i = 0; i < arcCount; i++) {
    float angleStart = random(HALF_PI);
    float angleWidth = random(TWO_PI);
    float radius = 20 + random(3)*i;
    float speed = random(PI/100, PI/50);
    float orientation = random(TWO_PI);
    float elevation = 10;
    
    arcs[i] = new Arc3D(angleStart, angleWidth, radius, speed, orientation, elevation, cp.colors[cpSelect][(int)random(cp.colors[cpSelect].length)]);
  }
  
  /* start oscP5, listening for incoming messages at port 8000 */
  oscP5 = new OscP5(this,8000);
}

void draw() {
  // setup blending for OpenGL state machine
  setupGL();

  // start drawing
  background(bgColor);

  if(rotateCam) {
    cam.rotateX(PI/200);
    cam.rotateY(PI/200);
  }

  // draw floaters
  if(drawFloaters) {
    for (int i = 0; i < floaters.length; i++) {
      floaters[i].update();
      floaters[i].paintVetrices();
    }
  }
  // draw elements

  if(drawElementStars) {
    for (int i = 0; i < elements.length; i++) {
      elements[i].update();
      elements[i].paintVetrices();
    }
  }
    
  if(drawElementLines || elementLineAlpha > 0) {
    beginShape(LINES);
    for (int i = 0; i < elements.length; i++) {
      elements[i].paintLines();
    }
    endShape();
  }

  if(drawArcs) {
    for(int i = 0; i < arcCount; i++){
      arcs[i].display();
      arcs[i].aAngleStart += arcs[i].aSpeed;
      arcs[i].aOrientation += arcs[i].aSpeed;
    }
  }
}

// setup OpenGL state machine
void setupGL() {
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.beginGL();

  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);

  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);

  pgl.endGL();
}

// handle osc events
void oscEvent(OscMessage theOscMessage) {

    String addr = theOscMessage.addrPattern();
    float  val  = theOscMessage.get(0).floatValue();

    if(addr.equals("/1/thetaD"))        { thetaD = (int)val; }
    else if(addr.equals("/1/phiD"))   { phiD = (int)val; }
    else if(addr.equals("/1/velS"))   { velS = val; }
    else if(addr.equals("/1/glowS"))   { mapGlowSValue((int)val); }
    else if(addr.equals("/1/sphereR"))   { sphereR = val; }
    else if(addr.equals("/1/behavior/2/1"))  { if(val == 1.0) elementBehavior = 0; }
    else if(addr.equals("/1/behavior/2/2"))  { if(val == 1.0) elementBehavior = 1; }
    else if(addr.equals("/1/behavior/1/1"))  { if(val == 1.0) elementBehavior = 2; }
    else if(addr.equals("/1/behavior/1/2"))  { if(val == 1.0) elementBehavior = 3; }
    else if(addr.equals("/1/lines"))  { if(val == 1.0) drawElementLines = true; else drawElementLines = false;}
    else if(addr.equals("/1/pulse"))  { if(val == 1.0) pulsate = true; else pulsate = false;}
}

void mapGlowSValue(int val) {
  if(val > 0) {
    int powVal = (int)(log(val) / log(2));
    glowS = (int)pow(2, powVal);
  }
  else glowS = 0;
}

void keyPressed() {
  
  // reset points o/n the sphere
  if (key == 'r' || key == 'R' ) {
    resetElements();
  }
  
  // show/hide lines between points
  else if(key == 'l' || key == 'L' ) {
    drawElementLines = !drawElementLines;
  }
  
  else if(key == 'a' || key == 'A') {
    drawArcs = !drawArcs;
    
    if(!drawArcs) {
      glowS = 32;
      sphereR = 100;
    }
    else {
      sphereR = 10;
      glowS = 2;
    }
  }
  
  else if(key == 'c' || key == 'C') {
    rotateCam = !rotateCam;
  }
  
  // select color palette
  else if(key == '1' || key == '2' || key == '3') {
    cpSelect = key - '1';
  }
  
  else if(key == '+' || key == '=') {
    elementBehavior++;
    
    if(elementBehavior > 3)
      elementBehavior = 3;
  }
  
  else if(key == '-' || key == '_') {
    elementBehavior--;
    
    if(elementBehavior < 0)
      elementBehavior = 0;
  }
  
  else if(key == 'v' || key == 'V'){
    showCursor = !showCursor;
    
    if(showCursor) {
      cursor();
    }
    else {
      noCursor();
    }
  }
  
  else if(key == 'f' || key == 'F'){
    drawFloaters = !drawFloaters;
  }
}

void drawBoundingBox() {
  pushMatrix();
  translate(0, 0, 0);
  stroke(255);
  strokeWeight(2);
  noFill();
  box(width, height, zBoundary*2);
  popMatrix();
}

void resetElements() {
  int thetaD = 20;
  int elementCount = (int)pow(thetaD, 2);
  int phiD = thetaD;

  elements = new Element[elementCount];
  for (int i = 0; i < thetaD; i++) {
    for (int j = 0; j < phiD; j ++) {
      float theta = TWO_PI*i/thetaD;
      float phi = PI*j/phiD;
      float x = sphereR * cos(theta) * sin(phi);
      float y = sphereR * sin(theta) * sin(phi);
      float z = sphereR * cos(phi);

      elements[i*phiD+j] = new Element(x, y, z, theta, phi);
    }
  }
    
  // create arcs
  arcs = new Arc3D[arcCount];
  for(int i = 0; i < arcCount; i++) {
    float angleStart = random(HALF_PI);
    float angleWidth = random(TWO_PI);
    float radius = 20 + random(3)*i;
    float speed = random(PI/100, PI/50);
    float orientation = random(TWO_PI);
    float elevation = 10;
  
    arcs[i] = new Arc3D(angleStart, angleWidth, radius, speed, orientation, elevation, cp.colors[cpSelect][(int)random(cp.colors[cpSelect].length)]);
  }
    
  // create randomly floating floaters
  floaters = new Floater[(int) random(minFloaters, maxFloaters)]; 
  
  for (int i = 0; i < floaters.length; i++) {
    float x = random(-width/2, width/2);
    float y = random(-height/2, height/2);
    float z = random(-zBoundary, zBoundary);
    
    floaters[i] = new Floater(x, y, z, 1, 5);
  }
}

