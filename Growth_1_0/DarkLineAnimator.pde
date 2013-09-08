/**
  Dark line animator class
  Creates dark lines to create tree-shaped branches, based in swipe direction
*/

class DarkLineAnimator
{
  // Array to hold the dark lines
  ArrayList <DarkLine> lineList = new ArrayList <DarkLine> ();
  
  PVector swipeDirection; // The direction to create the branches in
  PVector startPosition;  // The positon to start the branches
  
  float duration;
  float distance;
  
  float mainTimer = 0; // Timer to keep track of animation times
  
  float fadeTime = 4;  // The duration of the shrinking animation
  float delayTime = 3; // The time for the branch to remain shown at full width before shrinking
  
  int branchNumber = 0;         // Start the branches with index 0
  int maxNumberOfBranches = 5;  // The maximum number of branches that will be drawn
  float lineWitdhMax = 18.0;    // The maximum width of a branch
  
  float maxBranchLength = 180;  // The maximum length of a branch
  float minBranchLength = 30;   // The minimum length of a branch
  float minBranchAngle = -PI/3; // The minimum angle of a new branch
  float maxBranchAngle = PI/3;  // The maximum angle of a new branch
  
  boolean animationComplete = false;
  int tag;
    
  // Direciton in 
  DarkLineAnimator(PVector direction, PVector position, float swipeSpeed, int id)
  {    
    // Calculate the speed and length of the lines
    duration = map(swipeSpeed, 0, 3500, 1.0, 0.1);
    distance = map (duration, 0, 2, 50, 250);
    duration = 1.5;
    
    // Make a copy of the swipe direction vector and normalize it
    swipeDirection = new PVector(direction.x, direction.y);
    swipeDirection.normalize();
    
    // Calculate the start position based on the swipe direction
    startPosition = new PVector(width/2, height/2, 0);
    PVector startOffset = swipeDirection.get();
    startOffset.y = -startOffset.y;
    startOffset.mult(-670); // Create an offset so the lines start off of the tree
    startPosition.add(startOffset);
    
    // Add the initial branch
    lineList.add(new DarkLine(startPosition, swipeDirection, distance, duration/2, 0, 0));
  }
  
  /**
   Create branches for a line given a branches start position and direction of the parent branch
  */
  void createNewBranches(PVector startPosition, PVector originalDirection, int newTag) 
  {    
    PVector newStartPosition = startPosition.get();
    originalDirection.normalize();
    PVector newDirection1 = originalDirection.get();
    PVector newDirection2 = originalDirection.get();
    
    // Calculate random branch anfles
    float rotation1 = random(0, maxBranchAngle);
    float rotation2 = random(minBranchAngle, 0);
    
    // Rotate the direction vector
    newDirection1.rotate(rotation1);
    newDirection2.rotate(rotation2);
    
    // Make 3d vecvtors fo the new branches
    PVector lineDirection1 = new PVector(newDirection1.x, -newDirection1.y, 0);
    PVector lineDirection2 = new PVector(newDirection2.x, -newDirection2.y, 0);
    
    // Calculate a random branch length for each branch
    float newLength1 = random(minBranchLength, maxBranchLength);
    float newLength2 = random(minBranchLength, maxBranchLength);
    
    // Create the branches
    lineList.add(new DarkLine(newStartPosition, lineDirection1, newLength1, duration/2, newTag, branchNumber));
    lineList.add(new DarkLine(newStartPosition, lineDirection2, newLength2, duration/2, newTag, branchNumber));
  }
  
  /**
    Update the animator - call once per frame
  */
  void updateTheAnimator()
  {
    // If the animation is complete, dont draw anythign
    if (animationComplete == true) {
      return;
    }
    
    // Increment the timer
    mainTimer += 1/frameRate;
    
    float lineWidth;
    
    // If the timer is less than the delay time, draw full width lines
    // If not, scale the lines based on the timer
    if (mainTimer < delayTime) {
      lineWidth = lineWitdhMax;
    }
    else {
      lineWidth = map(mainTimer, delayTime, delayTime + fadeTime, lineWitdhMax, 0);
    }
    
    // if the new line width is 0, the animation is complete
    if (lineWidth <= 0) {
      lineWidth = 0;
      animationComplete = true;
    }
    
    // Update all of the dark lines with the new thickness
    for (DarkLine line : lineList) {
      line.updateTheLine(lineWidth);
    }

    // If any of the lines are complete, add branches to them
    for (int i = 0; i < lineList.size(); i++) {
      DarkLine line = lineList.get(i);
      
      // Check to see if the line needs bramches added to it
      if (line.beginNextLine && !line.hasBranches && (line.tag < maxNumberOfBranches)) {
        PVector directionVector = new PVector(line.endVector.x - line.startVector.x, line.endVector.y - line.startVector.y);
        createNewBranches(line.endVector, directionVector, (line.tag + 1));
        line.setHasBranches(true);
      }
    }
  }
  
}
