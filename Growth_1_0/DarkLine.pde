/**
  Dark line class
  Animates a dark line between two three dimensional vector locations
*/

class DarkLine
{
  // Add a small line over the thicker line?
  boolean ADD_INNER_LINE = false;
  
  PVector startVector; // The start position vector
  PVector endVector; // The end position vector
  PVector directionUnitVector; // Unit vector in the direction of the line animation
  int tag; // Tag value for the line

  float timeValue = 0;
  float timeScale = 0.05;
  float animationTime;
  
  int lineBranchNumber;
  
  // Boolean values to describe the state of the line
  boolean isGrowing = true;      // Is the line growing?
  boolean isComplete = false;    // Is the animation complete?
  boolean beginNextLine = false; // Should the next line start? - set to true when the line first reaches is endVector
  boolean hasBranches = false;   // Does this lind have branches added to it yet?

  DarkLine(PVector startPoint, PVector direction, float lineLength, float duration, int tagValue, int branchNumber)
  {
    animationTime = duration; // Set the time for the line animation
    tag = tagValue; // Set the tag value of the line

    // Set the start vector
    startVector = new PVector(startPoint.x, startPoint.y, startPoint.z);
    
    // Adjsut the direction vector
    PVector newDirection = direction.get();
    newDirection.y = newDirection.y * -1; // The Processing y axis is the other way 'round
    newDirection.mult(lineLength);
    
    // Calculate the end vector based on the line length and the direction
    endVector = new PVector(startPoint.x + newDirection.x, startPoint.y + newDirection.y, startPoint.z);
  }
  
  /**
    Set the "hasBranches" variable
  */
  void setHasBranches(boolean branches)
  {
    hasBranches = branches;
  }
  
  /**
    Set the "setBeginNextLine" variable
  */
  void setBeginNextLine(boolean value)
  {
    beginNextLine = value;
  }

  /**
    Update the line display - call once per frame
  */
  void updateTheLine(float thickness)
  {    
    // Calculate the initial line thickness based on its branch(tag) number
    float thicknessMultiplier = map(tag, 0, 7, 1, 0.3);
    thickness = thickness * thicknessMultiplier;
    
    PVector lineEnd;
    PVector lineStart;
   
    // Increment the timer if it's below the total animation time
    if (timeValue < animationTime) {
      timeValue += timeScale;
    }
   
    // Calculate a unit vector
    directionUnitVector = new PVector(endVector.x - startVector.x, endVector.y - startVector.y, endVector.z - startVector.z);
    directionUnitVector.normalize();
    
    // Get the maximum length of the line
    float maxLineLength = endVector.dist(startVector);
    
    // Calclate the new direction vector to be added to the start vector
    PVector newDirectionVector = directionUnitVector.get();
    newDirectionVector.mult( maxLineLength * (timeValue/animationTime));
    
    // Create the new start and end vectors
    lineEnd = new PVector(startVector.x + newDirectionVector.x, startVector.y + newDirectionVector.y, startVector.z + newDirectionVector.z);
    lineStart = new PVector(startVector.x, startVector.y, startVector.z);

    // Check to see if the line is complete
    if (isGrowing && (newDirectionVector.mag() >= maxLineLength)) {
      isGrowing = false;
      beginNextLine = true;
      isComplete = true;
    }
    
    hint(ENABLE_STROKE_PURE);
    
    // Draw the line
    pushMatrix();
    stroke(0, 0, 0, 255);
    strokeWeight(thickness);
    beginShape(LINES);
    vertex(lineStart.x, lineStart.y, lineStart.z);
    vertex(lineEnd.x, lineEnd.y, lineEnd.z);
    endShape();
    
    // Add a thin line too?
    if (ADD_INNER_LINE) {
      stroke(5, 5, 5, 180);
    
      thickness -= 4;
      if (thickness < 0) {
        thickness = 1; 
      }
    
      strokeWeight(thickness -1);
      beginShape(LINES);
      vertex(lineStart.x, lineStart.y, lineStart.z);
      vertex(lineEnd.x, lineEnd.y, lineEnd.z);
      endShape();
    }
    
    popMatrix();
  }
}
