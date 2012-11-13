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
int elementCount = 5000;
float zBoundary = 500;

// disc properties
float discRadius = 50;
float elementPosVariance = 2;

ColorPalette cp;

void setup() {  
  size(screen.width, screen.height, OPENGL);
  
  // peasy cam
  cam = new PeasyCam(this, 200);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(1500);

  smooth();
  
//  translate(width, height, zBoundary);
  cp = new ColorPalette();
  
  // create elements along a disc
  elements = new Element[elementCount];
  
  for (int i = 0; i < elements.length; i++) {
    float theta = TWO_PI*i/elementCount;
    float x = discRadius * cos(theta) + random(-elementPosVariance, elementPosVariance);
    float y = discRadius * sin(theta) + random(-elementPosVariance, elementPosVariance);
    float z = 0;
    
    elements[i] = new Element(x, y, z);
  }
  
  background(0);
}

void draw() {
  
  // setup blending for OpenGL state machine
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.beginGL();
  
  gl.glDisable(GL.GL_DEPTH_TEST);
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
  
  pgl.endGL();
  
  background(0);

//  noStroke();
  beginShape(POINTS);
  for (int i = 0; i < elements.length; i++) {
    elements[i].update();
    elements[i].paint();
  }
  endShape();
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
    float theta = TWO_PI*i/elementCount;
    float x = discRadius * cos(theta) + random(-elementPosVariance, elementPosVariance);
    float y = discRadius * sin(theta) + random(-elementPosVariance, elementPosVariance);
    float z = 0;
    
    elements[i] = new Element(x, y, z);
  }
}
