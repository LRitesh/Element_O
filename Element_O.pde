// Element O
// Thousands of elements that come together and form concentric rings/discs
import processing.opengl.*;
import javax.media.opengl.*;

import controlP5.*;
ControlP5 cp5;

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
float zBoundary = 1100;

// floaters
Floater[] floaters;
boolean drawFloaters = false;
int minFloaters = 500;
int maxFloaters = 500;

// sphere properties
float discRadius = 100;
int elementBehavior = 0;

// Bunch of 3D Arcs
Arc3D[] arcs;
boolean drawArcs = false;
int arcCount = 25;

ColorPalette cp;
int cpSelect = 0;
color bgColor = color(0);//color(242, 31, 12);

PImage glowBright;
PImage glowLite;
PImage star;

void setup() {  
  size(screen.width, screen.height, OPENGL);
  
  // peasy cam
  cam = new PeasyCam(this, 200);
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
      
      float x = discRadius * cos(theta) * sin(phi);
      float y = discRadius * sin(theta) * sin(phi);
      float z = discRadius * cos(phi);

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

  // slider controls
  cp5 = new ControlP5(this);
  cp5.addSlider("thetaD")
    .setPosition(100, 50)
      .setRange(1, 255)
        .setValue(180)
          .setHeight(18);
  ;
  cp5.addSlider("phiD")
    .setPosition(100, 70)
      .setRange(1, 255)
        .setValue(180)
          .setHeight(18);
  ;
  cp5.addSlider("discRadius")
    .setPosition(100, 90)
      .setRange(85, 255)
        .setHeight(18);
  ; 
  cp5.setAutoDraw(false);
}

void draw() {
  // setup blending for OpenGL state machine
  setupGL();

  // start drawing
  background(bgColor);

//  cam.rotateY(PI/200);

  //  drawBoundingBox();

  //  noStroke();

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

  if(frameCount % 128 == 0)
    elementBehavior++;

  // draw gui
  gui();
}

// draw control p5 gui here
void gui() {
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
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

void keyPressed() {
  println("reset required");
  if (key == 'r' || key == 'R' ) {
    resetElements();
  }

  else if (key == 'c' || key == 'C') {
    background(0);
    resetElements();
  }
  
  else if(key == 'l' || key == 'L' ) {
    drawElementLines = !drawElementLines;
  }
  
  else if(key == '1' || key == '2' || key == '3') {
    cpSelect = key - '1';
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
      float x = discRadius * cos(theta) * sin(phi);
      float y = discRadius * sin(theta) * sin(phi);
      float z = discRadius * cos(phi);

      elements[i*phiD+j] = new Element(x, y, z, theta, phi);
    }
  }
}

