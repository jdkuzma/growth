/**
  Line class
  Animates a white line between two three dimensional vector locations
*/

class Line
{
  // Add a small line over the thicker line?
  boolean ADD_INNER_LINE = false;
  
  // Vectors to indicate the line position
  PVector startVector;
  PVector endVector;
  PVector directionUnitVector;
  
  // Time valuse
  float timeValue = 0;
  float timeStep = 0.05; // Amount to change the time every frame
  float animationTime; // Macimum
  
  // Boolean values to describe the state of the line
  boolean isGrowing = true;      // Is the line growing?
  boolean isShrinking = false;   // Is the line shrinking?
  boolean isComplete = false;    // Is the animation complete?
  boolean beginNextLine = false; // Should the animator start the next line?

  Line(PVector startPoint, PVector endPoint, float timeValue)
  { 
    // Set the animation time
    animationTime = timeValue;
    
    // Create the start and end vectors
    startVector = new PVector(startPoint.x, startPoint.y, startPoint.z);
    endVector = new PVector(endPoint.x, endPoint.y, endPoint.z);
    
    // Scale the vectors to match the triangle positions
    startVector.mult(9.25);
    endVector.mult(9.25);
    
    // Apply a z offset to prevent lines intersecting the model
    startVector.z = startVector.z + 3; 
    endVector.z = endVector.z + 3;
  } 
  
  /**
    Set the "beginNextLine" variable
  */
  void setBeginNextLine(boolean value)
  {
    beginNextLine = value;
  }

  /**
    Update the line - call every frame
  */
  void updateTheLine()
  {
    // if the line is complete, dont draw anything
    if (isComplete) { return; }
    
    // New end and start vectors
    PVector lineEnd;
    PVector lineStart;
   
    // GROWING
    if (isGrowing) { 
      timeValue += timeStep; 
      directionUnitVector = new PVector(endVector.x - startVector.x, endVector.y - startVector.y, endVector.z - startVector.z);
      directionUnitVector.normalize();
    }
    // SHRINKING
    else if (isShrinking) {
      timeValue -= timeStep;
      if (timeValue < 0) { timeValue = 0; };
      directionUnitVector = new PVector(startVector.x - endVector.x, startVector.y - endVector.y, startVector.z - endVector.z);
      directionUnitVector.normalize();
    }
    else { 
      return; // not shrinking or growing, no need to draw
    }
    
    // Get the maximum length of the line
    float maxLineLength = endVector.dist(startVector);
    
    // Calclate the new direction vector to be added to the start vector
    PVector newDirectionVector = new PVector(directionUnitVector.x, directionUnitVector.y, directionUnitVector.z);
    newDirectionVector.mult( maxLineLength * (timeValue/animationTime));
    
    // Check for growing to determine the start vector
    if (isGrowing) {
      lineEnd = new PVector(startVector.x + newDirectionVector.x, startVector.y + newDirectionVector.y, startVector.z + newDirectionVector.z);
      lineStart = new PVector(startVector.x, startVector.y, startVector.z);
    }
    else {
      lineEnd = new PVector(endVector.x + newDirectionVector.x, endVector.y + newDirectionVector.y, endVector.z + newDirectionVector.z);
      lineStart = new PVector(endVector.x, endVector.y, endVector.z);
    }
    
    // Make sure the new vector is not larger than the total distance
    if (isGrowing && (newDirectionVector.mag() >= maxLineLength)) {
      isGrowing = false;
      isShrinking = true;
      beginNextLine = true;
    }
    else if (isShrinking && (newDirectionVector.mag() <= 0))
    {
      isShrinking = false;
      isComplete = true;
    }
    
    hint(ENABLE_STROKE_PURE);
    
    // Draw the line
    pushMatrix();
    
    stroke(255, 255, 255, 255);
    strokeWeight(2.0);
    beginShape(LINES);
    vertex(lineStart.x, lineStart.y, lineStart.z);
    vertex(lineEnd.x, lineEnd.y, lineEnd.z);
    endShape();
    
    if(ADD_INNER_LINE) {
      stroke(25, 235, 185, 255);
      strokeWeight(1.0);
      beginShape(LINES);
      vertex(lineStart.x, lineStart.y, lineStart.z);
      vertex(lineEnd.x, lineEnd.y, lineEnd.z);
      endShape();
    }
    
    popMatrix();
  }
}
