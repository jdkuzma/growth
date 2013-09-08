/**
  Line animator class
  Creates a line that starts from the bottom of the tree and moves between vettices until reaching the top
*/

class LineAnimator
{
  // Array of lines to control
  ArrayList <Line> lineList = new ArrayList <Line> ();
  PointFetcher point = new PointFetcher();

  // Booleans to keep track of line progress
  boolean shouldBeginNextLine = false;
  boolean animationComplete = false;

  // Integers to kep track of current line position, and determine next line position
  int currentPointIndex = 0;
  int nextPointIndex = 0;
  int startCorner = 0;
  int endCorner = 0;
  
  // Variable for the duration of each individual Line
  float singleLineDuration;
  float minLineDuration = 0.3;
  float maxLineDuration = 1.3;
  
  // The tag of the LineAnimator
  int tag;
  
  LineAnimator(int tagValue)
  {
    tag = tagValue;
    
    // Pick a random duration for each line segment
    singleLineDuration = random(minLineDuration, maxLineDuration);
    
    // Get the next point for the current point (always starts from 0)
    nextPointIndex = point.getNextForPoint(currentPointIndex);
    currentPointIndex = nextPointIndex;
    
    // Add a new line
    lineList.add(new Line(point.getPoint(0), point.getPoint(nextPointIndex), singleLineDuration));
  }

  /**
    Adds a new line to continue the animation, or stops if the line has reached the top of the tree
  */
  void beginNextLineAnimation()
  {
    // Get the next point based on the current point
    nextPointIndex = point.getNextForPoint(currentPointIndex);

    // If the next point is 0, the line has reached the top of the tree
    if (nextPointIndex == 0) {
      return;
    }
    
    // Add a new line
    lineList.add(new Line(point.getPoint(currentPointIndex), point.getPoint(nextPointIndex), singleLineDuration)); 
    currentPointIndex = nextPointIndex;
  }

  /**
    Updae the animator - call every frame to advance the line animations
  */
  void updateTheAnimator()
  {
    // Update every line in the array
    for (Line line : lineList) {
      // Check if the line has reached its end and signaled to start the next line
      if (line.beginNextLine)
      {
        line.setBeginNextLine(false);
        shouldBeginNextLine = true;
      }
      line.updateTheLine();
    }
    
    // Begin the next line animation if needed
    if (shouldBeginNextLine) {
      beginNextLineAnimation();
      shouldBeginNextLine = false;
    }
    
    // Check to see if the last line is complete, if so, the animation is complete
    Line lastLine = lineList.get(lineList.size() - 1);      
    if (lastLine.isComplete) { 
      animationComplete = true;
    }
  }
}

