/*
  Triangle class
  Used to create each individual triangle on the Tree
*/

class Triangle {
   
  boolean CALIBRATION_STROKE = false; // Apply a stroke to the triangles to help with the mapping
  
  // Array of vectors to position the triangle vertices
  PVector[] v = new PVector[3];
  PVector center;
  float scaleFactor = 2.1; // scale factor to grow to fill the screen (2.1)
  
  // PointFetcher object to get the triangle points
  PointFetcher point = new PointFetcher();
  
  // "Growth value" determines the "health" of a triangle - the higher the value, thedarker the triangle
  // As th "growth value" increases, the colr of the triangle transisitions from the RGB min values, to the RGB max values
  float growthValue = 0; // Start with a "growth value" of 0
  float growthMax = 10; // Maximum "growth value" of 10
  
  // Color variables to determing the min/max RBG colors
  float redValue;
  int redMin = 10; // 80
  int redMax = 0; 
  
  float greenValue;
  int greenMin = 130; // 192
  int greenMax = 0;
  
  float blueValue;
  int blueMin = 40; // 136
  int blueMax = 0;
  
  int pulseAmp = 40; // Amplitude of the natural sinusoidal color variation
  float pulseValue;  // This value changes linearly with time to determine the amount of color variation
  
  boolean isSelected = false;
  int tag;
  
  // Flashing parameters for when a hand is first seen after the delay time determined in the main file
  float flashValue = 0;
  boolean flash = false;
  float flashMax = 255;
  float flashMin = 0;
  float flashTimer = 0;
  
  // Create a triangle with an index number
  Triangle(int index) {
    flash = false;
    createTriangle(index);
    
    // Scale the points to fit the screen
    for (PVector vector : v) {
        v[0].mult(scaleFactor);
        v[1].mult(scaleFactor);
        v[2].mult(scaleFactor);
    } 
    calculateCenter();
    pulseValue = random(0, PI); // start with a random pulse value
  }
  
  /**
    Set the "isSelected" variable
  */
  void setSelected(boolean selected) 
  {
     if (selected) {
       isSelected = true;
     }
     else {
       isSelected = false;
     }
  }
  
  /**
    set the "flash" variable
  */
  void setFlash(boolean shouldFlash)
  {
    flash = shouldFlash;
  }
  
  /**
    Calculate the center of the triangle
  */
  void calculateCenter() 
  {
    //  C = (P1+P2+P3)/3 = ((x1+x2+x3)/3,(y1+y2+y3)/3,(z1+z2+z3)/3)
    float centerX = (v[0].x + v[1].x + v[2].x) / 3;
    float centerY = (v[0].y + v[1].y + v[2].y) / 3;
    float centerZ = (v[0].z + v[1].z + v[2].z) / 3;
    
    center = new PVector(centerX, centerY, centerZ);
  }
  
  /**
    Update the view
  */
  void updateTheView() 
  {
    pulseValue += 0.005;
    
    // If selected?
    if (isSelected) {
      growthValue += 1;
    }
    else {
      growthValue -= 0.1; // 0.01
    }
    
    if (growthValue >= growthMax) { growthValue = growthMax; }
    if (growthValue <= 0) { growthValue = 0; } 
    
    // Adjust the flash value
    if (flash) {
      flashValue += 30;
      if (flashValue > flashMax) {
        flash = false;
        flashValue = flashMax;
      }
    }
    else {
      flashValue -= 7;
      if (flashValue < 0) { 
        flashValue = 0;
      }
    }
    
    // If the triangle is flashing, adjust the stroke
    if (flashValue > 0) {
      float newWeight = map(flashValue, flashMin, flashMax, 0, 5);
      strokeWeight(newWeight);
      stroke(255);
    }
    else {
     noStroke(); 
    }
      
    // Calculat new RGB values
    redValue = map(growthValue, 0, growthMax, redMin, redMax);
    redValue += sin(pulseValue) * pulseAmp;

    greenValue = map(growthValue, 0, growthMax, greenMin, greenMax);
    greenValue += sin(pulseValue) * pulseAmp;
        
    blueValue =  map(growthValue, 0, growthMax, blueMin, blueMax);
    blueValue += sin(pulseValue + (PI/2)) * pulseAmp;

    // Push/Pop Matrix to avoid messing up other triangles
    pushMatrix();

    // Apply the new RGB value
    fill(redValue, greenValue, blueValue);
    if (CALIBRATION_STROKE) {
      stroke(255);
      strokeWeight(1.0);
    }
    else {
      noStroke(); 
    }
    
    // Create the triangle shape with its vertex positions
    beginShape(TRIANGLE);
    for ( int i = 0; i < 3; i++) {
       vertex(v[i].x, v[i].y, v[i].z); 
    }
    endShape();
    
    popMatrix();
  }
  
  /**
   Creates the triangle vertices based on the index number of the triangle being created
  */
  void createTriangle(int index) 
  {
    // Set the tag
    tag = index;
    
    // Get the points for the index
    switch (index) {
      case 0: {
       v[0] = point.getPoint(0);
       v[1] = point.getPoint(1);
       v[2] = point.getPoint(2);
       break;  
      }
      case 1: 
      {
       v[0] = point.getPoint(0);
       v[1] = point.getPoint(2);
       v[2] = point.getPoint(7);
       break;
      }
      case 2:
      {
       v[0] = point.getPoint(0);
       v[1] = point.getPoint(7);
       v[2] = point.getPoint(3);
       break; 
      }
      case 3:
      {
       v[0] = point.getPoint(0);
       v[1] = point.getPoint(3);
       v[2] = point.getPoint(4);
       break; 
      }
      case 4:
      {
       v[0] = point.getPoint(1);
       v[1] = point.getPoint(5);
       v[2] = point.getPoint(2);
       break; 
      }
      case 5:
      {
       v[0] = point.getPoint(2);
       v[1] = point.getPoint(5);
       v[2] = point.getPoint(6);
       break; 
      }
      case 6:
      {
       v[0] = point.getPoint(2);
       v[1] = point.getPoint(6);
       v[2] = point.getPoint(10);
       break; 
      }
      case 7:
      {
       v[0] = point.getPoint(2);
       v[1] = point.getPoint(10);
       v[2] = point.getPoint(7);
       break; 
      }
      case 8:
      {
       v[0] = point.getPoint(3);
       v[1] = point.getPoint(7);
       v[2] = point.getPoint(8);
       break; 
      }
      case 9:
      {
       v[0] = point.getPoint(4);
       v[1] = point.getPoint(3);
       v[2] = point.getPoint(8);
       break; 
      }
      case 10:
      {
       v[0] = point.getPoint(7);
       v[1] = point.getPoint(10);
       v[2] = point.getPoint(11);
       break; 
      }
      case 11:
      {
       v[0] = point.getPoint(7);
       v[1] = point.getPoint(11);
       v[2] = point.getPoint(8);
       break;
      }
      case 12:
      {
       v[0] = point.getPoint(8);
       v[1] = point.getPoint(11);
       v[2] = point.getPoint(16);
       break;
      }
      case 13:
      {
       v[0] = point.getPoint(4);
       v[1] = point.getPoint(8);
       v[2] = point.getPoint(12);
       break;
      }
      case 14:
      {
       v[0] = point.getPoint(4);
       v[1] = point.getPoint(12);
       v[2] = point.getPoint(9);
       break;
      }
      case 15:
      {
       v[0] = point.getPoint(9);
       v[1] = point.getPoint(12);
       v[2] = point.getPoint(13);
       break;
      }
      case 16:
      {
       v[0] = point.getPoint(8);
       v[1] = point.getPoint(16);
       v[2] = point.getPoint(12);
       break;
      }
      case 17:
      {
       v[0] = point.getPoint(12);
       v[1] = point.getPoint(17);
       v[2] = point.getPoint(13);
       break;
      }
      case 18:
      {
       v[0] = point.getPoint(12);
       v[1] = point.getPoint(16);
       v[2] = point.getPoint(29);
       break;
      }
      case 19:
      {
       v[0] = point.getPoint(12);
       v[1] = point.getPoint(29);
       v[2] = point.getPoint(17);
       break;
      }
      case 20:
      {
       v[0] = point.getPoint(17);
       v[1] = point.getPoint(29);
       v[2] = point.getPoint(23);
       break;
      }
      case 21:
      {
       v[0] = point.getPoint(23);
       v[1] = point.getPoint(29);
       v[2] = point.getPoint(30);
       break;
      }
      case 22:
      {
       v[0] = point.getPoint(23);
       v[1] = point.getPoint(30);
       v[2] = point.getPoint(31);
       break;
      }
      case 23:
      {
       v[0] = point.getPoint(16);
       v[1] = point.getPoint(28);
       v[2] = point.getPoint(29);
       break;
      }
      case 24:
      {
       v[0] = point.getPoint(16);
       v[1] = point.getPoint(22);
       v[2] = point.getPoint(28);
       break;
      }
      case 25:
      {
       v[0] = point.getPoint(11);
       v[1] = point.getPoint(22);
       v[2] = point.getPoint(16);
       break;
      }
      case 26:
      {
       v[0] = point.getPoint(11);
       v[1] = point.getPoint(21);
       v[2] = point.getPoint(22);
       break;
      }
      case 27:
      {
       v[0] = point.getPoint(22);
       v[1] = point.getPoint(27);
       v[2] = point.getPoint(28);
       break;
      }
      case 28:
      {
       v[0] = point.getPoint(21);
       v[1] = point.getPoint(27);
       v[2] = point.getPoint(22);
       break;
      }
      case 29:
      {
       v[0] = point.getPoint(10);
       v[1] = point.getPoint(21);
       v[2] = point.getPoint(11);
       break;
      }
      case 30:
      {
       v[0] = point.getPoint(10);
       v[1] = point.getPoint(15);
       v[2] = point.getPoint(21);
       break;
      }
      case 31:
      {
       v[0] = point.getPoint(15);
       v[1] = point.getPoint(27);
       v[2] = point.getPoint(21);
       break;
      }
      case 32:
      {
       v[0] = point.getPoint(6);
       v[1] = point.getPoint(14);
       v[2] = point.getPoint(10);
       break;
      }
      case 33:
      {
       v[0] = point.getPoint(10);
       v[1] = point.getPoint(14);
       v[2] = point.getPoint(15);
       break;
      }
      case 34:
      {
       v[0] = point.getPoint(15);
       v[1] = point.getPoint(26);
       v[2] = point.getPoint(27);
       break;
      }
      case 35:
      {
       v[0] = point.getPoint(15);
       v[1] = point.getPoint(20);
       v[2] = point.getPoint(26);
       break;
      }
      case 36:
      {
       v[0] = point.getPoint(15);
       v[1] = point.getPoint(14);
       v[2] = point.getPoint(20);
       break;
      }
      case 37:
      {
       v[0] = point.getPoint(14);
       v[1] = point.getPoint(18);
       v[2] = point.getPoint(20);
       break;
      }
      case 38:
      {
       v[0] = point.getPoint(20);
       v[1] = point.getPoint(25);
       v[2] = point.getPoint(26);
       break;
      }
      case 39:
      {
       v[0] = point.getPoint(18);
       v[1] = point.getPoint(19);
       v[2] = point.getPoint(20);
       break;
      }
      case 40:
      {
       v[0] = point.getPoint(20);
       v[1] = point.getPoint(24);
       v[2] = point.getPoint(25);
       break;
      }
      case 41:
      {
       v[0] = point.getPoint(19);
       v[1] = point.getPoint(24);
       v[2] = point.getPoint(20);
       break;
      }
    }
  }
}
