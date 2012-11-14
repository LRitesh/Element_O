// Element O
// Thousands of elements that come together and form concentric rings/discs

import processing.opengl.*;
import javax.media.opengl.*;

import peasy.*;
PeasyCam cam;

PGraphicsOpenGL pgl;
GL gl;

// element properties
Element[] elements;
int elementCount = 500;
float zBoundary = 500;

// disc properties
float discRadius = 50;
float elementPosVariance = 0;

ColorPalette cp;
color bgColor = color(0);//color(242, 31, 12);

PImage glow1;
PImage glow2;

void setup() {  
  size(screen.width, screen.height, OPENGL);
  
  // peasy cam
  cam = new PeasyCam(this, 200);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(1500);

  smooth();
  
//  translate(width, height, zBoundary);
  cp = new ColorPalette();
  
  // create elements along a disc
  elements = new Element[elementCount];
  
  for (int i = 0; i < elements.length; i++) {
    float xVariance = random(-elementPosVariance, elementPosVariance);
    float yVariance = random(-elementPosVariance, elementPosVariance);
    float theta = TWO_PI*i/elementCount;
    float x = discRadius * cos(theta) + xVariance;
    float y = discRadius * sin(theta) + yVariance;
    float z = 0;
    
    elements[i] = new Element(x, y, z, theta, xVariance, yVariance);
  }
  
  background(bgColor);
  
  glow1 = loadImage("star.png");
  glow2 = loadImage("glow_blue.png");  
}

void draw() {
  
  // setup blending for OpenGL state machine
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.beginGL();
  
  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
  gl.glEnable(GL.GL_POINT_SMOOTH);
//  gl.glHint(GL.GL_POINT_SMOOTH_HINT, GL.GL_NICEST);
  
  pgl.endGL();
  
  // start drawing
  background(bgColor);

//  drawBoundingBox();

//  noStroke();
  beginShape(POINTS);
  for (int i = 0; i < elements.length; i++) {
    elements[i].update();
    elements[i].paintVetrices();
  }
  endShape();
  
//  for (int i = 0; i < elements.length; i++) {
//    elements[i].paintPoints();
//  }
}

void keyPressed() {
  println("reset required");
    if(key == 'r' || key == 'R' ) {
      resetElements();
    }

    else if(key == 'c' || key == 'C') {
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
  for (int i = 0; i < elements.length; i++) {
    float xVariance = random(-elementPosVariance, elementPosVariance);
    float yVariance = random(-elementPosVariance, elementPosVariance);
    float theta = TWO_PI*i/elementCount;
    float x = discRadius * cos(theta) + xVariance;
    float y = discRadius * sin(theta) + yVariance;
    float z = 0;
    
    elements[i] = new Element(x, y, z, theta, xVariance, yVariance);
  }
}
