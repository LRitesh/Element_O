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
boolean drawElements = true;
int thetaD = 20;
int elementCount = (int)pow(thetaD, 2);
int phiD = thetaD;
float zBoundary = 1000;

// floaters
Floater[] floaters;
boolean drawFloaters = false;
int minFloaters = 500;
int maxFloaters = 500;

// sphere properties
float discRadius = 100;
float elementPosVariance = 0;
int elementBehavior = 0;

ColorPalette cp;
color bgColor = color(0);//color(242, 31, 12);

PImage glow1a;
PImage glow2a;

PImage glow1b;
PImage glow2b;

void setup() {  
  size(screen.width, screen.height, OPENGL);

  // peasy cam
  cam = new PeasyCam(this, 200);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(zBoundary);

  smooth();
  //  translate(width, height, zBoundary);
  cp = new ColorPalette();

  // create elements along a sphere
  elements = new Element[elementCount];

  for (int i = 0; i < thetaD; i++) {
    for (int j = 0; j < phiD; j ++) {
      float xVariance = random(-elementPosVariance, elementPosVariance);
      float yVariance = random(-elementPosVariance, elementPosVariance);
      float theta = TWO_PI*i/thetaD;
      float phi = PI*j/phiD;
      float x = discRadius * cos(theta) * sin(phi) + xVariance;
      float y = discRadius * sin(theta) * sin(phi) + yVariance;
      float z = discRadius * cos(phi);

      elements[i*phiD+j] = new Element(x, y, z, theta, phi, xVariance, yVariance);
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
  
  background(bgColor);

  glow1a = loadImage("star.png");
  glow2a = loadImage("glow_red.png"); 

  glow1b = loadImage("star.png");
  glow2b = loadImage("glow_blue.png");  

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
      .setRange(50, 255)
        .setHeight(18);
  ; 
  cp5.setAutoDraw(false);
}

void draw() {
  // setup blending for OpenGL state machine
  setupGL();

  // start drawing
  background(bgColor);

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
//  beginShape(POINTS);
  if(drawElements) {
    for (int i = 0; i < elements.length; i++) {
      elements[i].update();
      elements[i].paintVetrices();
    }
  }
//  endShape();

  //  if(frameCount % 128 == 0)
  //    elementBehavior++;

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
      float xVariance = random(-elementPosVariance, elementPosVariance);
      float yVariance = random(-elementPosVariance, elementPosVariance);
      float theta = TWO_PI*i/thetaD;
      float phi = PI*j/phiD;
      float x = discRadius * cos(theta) * sin(phi) + xVariance;
      float y = discRadius * sin(theta) * sin(phi) + yVariance;
      float z = discRadius * cos(phi);

      elements[i*phiD+j] = new Element(x, y, z, theta, phi, xVariance, yVariance);
    }
  }
}

