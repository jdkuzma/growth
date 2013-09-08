/**
 GROWTH
 An interactive installation
 
 Abstract tree code by: Justin D. Kuzma
 www.jdkuzma.com
 
 This program used P3D to create a virtual 3D model of a physical abstract tree sculpture. Each facet of the tree can then be colored and interacted with using the Leap Motion as the primary input device.
 - When a hand is first presented (after a set number of seconds of inactivity) all triangles pulse with a white outline
 - Move your hands to darken the triangle nearest each palm point. Triangles will natrually lighten over time
 - Finger taps create white lines that run up from the bottom of the tree - clicking the mouse will also create a line
 - Swipe gestures create dark branches that cover the scuplture, that then shrink over time. The direction of the branch is determined by the direction of the swipe
 
 Triangle.pde
   - Creates a triangle of a given index (see TreeTriangles.pdf for index references) and controls its color
 
 Line.pde
   - Creates a line that animates between two points in a given amount of time
   
 LineAnimator.pde
   - Creates and manages an array of Lines, animating them from the top of the tree to the bottom
   
 DarkLine.pde
    - Creates a line that animates between two points in a given amount of time
    
 DarkLineAnimator.pde
   - Creates and manages an array of DarkLines, creating branches that cross the screen
   
 PointFetcher.pde
   - Contains a list of all vertices in the tree: use this to adjust the position of the tree surfaces
*/

/**
  Growth_1_0.pde
  Main program File
  - Creates a Leap Motion object for getting hand date from the Leap Motion Controller
  - 
*/

// Import Leap Motion For Processing Library by Darius Morawiec
// https://github.com/voidplus/leap-motion-processing
import de.voidplus.leapmotion.*;
import development.*;

// The Leap Motion object
LeapMotion leap;

// Create a vector for referencing the position of each palm
PVector palmPosition = new PVector(0,0,0);

// Create Arrays for holding the Triangles, LineAnimators, DarkLineAnimators, and Fingers
ArrayList <Triangle> triangleList = new ArrayList <Triangle> ();
ArrayList <LineAnimator> lineAnimatorList = new ArrayList <LineAnimator> ();
ArrayList <DarkLineAnimator> darkLineAnimatorList = new ArrayList <DarkLineAnimator> ();
ArrayList <Finger> fingerArray = new ArrayList <Finger> ();

// Create a point fetcher object for retrieving the vector points on the tree
PointFetcher point = new PointFetcher();

// Indicate hand positions with a sphere?
boolean SHOW_HAND_POSITION = false;

// Timer for determining when to create a new Line
float lineTimer = 0;
float nextLineTime = 0;

// If an animator id complete, use these variblaes to indicate it should be removed from the array
int animatorToRemove = -1;
int darkLineAnimatorToRemove = -1;

// Incremented every time an animator is created to ensure that each animator has a unique id
int nextAnimatorTag = 0;

// Used to limit the number of swipes than can happen
// When a Hand is swiped, the Leap object detects a swipe for each detected finger, adding a minSwipeInterval limits the dark branches to be created one at a time
float swipeTimer = 0;
float minSwipeInterval = 0.0; // The amount of time required between swipes (seconds)

// Variables to determine if the triangles should all flash (after a period of inactivity)
float handTimer = 0;       // Initialize the value to be larger than minHandInterval to keep from waiting after the program first starts
float minHandInterval = 2; // Set this to the time of inactivity required before flashing (seconds)
int handCount = 0;
int lastHandCount = 0;
boolean shouldFlashTriangles = false;

// *** SETUP *** //
void setup()
{
  // Set the screen size
  size(1280, 800, P3D);
  
  // Run in RGB color mode
  colorMode(RGB);

  // Create a triangle for each index value, and add to the triangle array
  for (int i = 0; i < 42; i++) {
    triangleList.add(new Triangle(i));
  }
  
  // Create the leap motion object
  leap = new LeapMotion(this).withGestures("swipe, key_tap");
  // Gesture Options: LeapMotion(this).withGestures("circle, swipe, screen_tap, key_tap");
}

/**
  Run in full screen mode?
 */
boolean sketchFullScreen() {
  return true;
}

/**
  Clears the selection of all triangles
*/
void clearSelection()
{
  for (Triangle triangle : triangleList) {
    triangle.setSelected(false);
  }
}

/** 
  Selects the triangle closest to the current palm position
*/
void selectClosestTriangle()
{
  float newDistance;
  float closestDistance = 10000;
  int closestIndex = 100;
  
  // Loop through and find the closest triangle, based on the palm position and the center of the triangle
  for (Triangle triangle : triangleList) {
    newDistance = palmPosition.dist(triangle.center);
    if (newDistance < closestDistance) {
      closestDistance = newDistance;
      closestIndex =  triangle.tag;
    }
  }

  // Select the triangle that was closest by looping through them and finding the one with the matching tag
  for (Triangle triangle : triangleList) {
    if (triangle.tag == closestIndex) {
      triangle.setSelected(true);
    }
  }
}

// *** DRAW - Called once per frame *** //
void draw()
{
  // Increment the timers
  lineTimer  += 1/frameRate;
  swipeTimer += 1/frameRate;
  handTimer  += 1/frameRate;
  
  // Black background
  background(0,0,0,255); 
  
  // Ambient lighting 
  lights(); 

  // Position an orthographic camera
  ortho(0, width, 0, height);

  // Clear the selection of all triangles so that one does not remain selected after a hand moves away from it
  clearSelection();

  // Reset hand count to count number of visible hands
  handCount = 0; 
  
  // HANDS
  for (Hand hand : leap.getHands()) {
    handCount++;
    PVector hand_position = hand.getPosition();
    PVector hand_direction = hand.getDirection();
    hand_direction.normalize();
    hand_direction.mult(-30);

    hand_position.z = map(hand_position.z, -30, 115, 0, -500); // Map the z coordinate to the frame depth
    palmPosition = hand_position.get();
    selectClosestTriangle(); // Select the triangle closest to the hand

    // Draw a sphere to indicate the hand?
    if (SHOW_HAND_POSITION) {
      pushMatrix();
      fill( 0, 121, 184 ); // Set the fill color
      noStroke(); // No stroke for the sphere, a stroke slows the frame rate considerably
      translate(hand_position.x, hand_position.y, hand_position.z); // Move to the hand position
      sphere(10); // Draw a sphere to represent the palm
      popMatrix();
    }
    
    // Remove all old fingers from array
    for (int i = 0; i < fingerArray.size(); i++) {
      fingerArray.remove(0);
    }
    
    // Add new fingers to the array
    for(Finger finger : hand.getFingers()){
      fingerArray.add(finger);
    } 
  }
  
  // Max number of lights in processing is 8 (including the ambient light)
  int fingerCount = fingerArray.size();
  if (fingerCount > 6) { fingerCount = 6; }
       
  // Add a spot light at each finger location, pointing in the direction of the finger
  for (int i = 0; i < fingerCount; i++) {
     Finger nextFinger = fingerArray.get(i);
     PVector finger_position = nextFinger.getPosition();
     PVector finger_direction = nextFinger.getDirection();
     spotLight(200, 200, 255, finger_position.x, finger_position.y, finger_position.z, finger_direction.x, finger_direction.y, finger_direction.z, PI/10, 10);
   }
  
  // Check to see if the triangles should flash
  if ((lastHandCount == 0) && (handCount > 0) && (handTimer > minHandInterval)) {
    handTimer = 0;
    shouldFlashTriangles = true;
  }
  if (handCount > 0) {
    handTimer = 0;
  }
  lastHandCount = handCount; // Update the hand counr

  // Update the display of all the triangles
  for (Triangle triangle : triangleList) {
    if (shouldFlashTriangles) {
      triangle.setFlash(true);
    }
    triangle.updateTheView();
  }
  shouldFlashTriangles = false;
  
  // if the line timer has exceeded its required threshold, create a new line animator
  if (lineTimer >= nextLineTime) {
      lineAnimatorList.add(new LineAnimator(lineAnimatorList.size()));
      lineTimer = 0;
      nextLineTime = random(0.5,5); // Generate a random time for the next line to appear
  }
  
  // Update the display of all the line animators. If the animator is complete, mark it for removal
  for (LineAnimator animator : lineAnimatorList) {
     if (!animator.animationComplete) {
       animator.updateTheAnimator();
     }
     else {
       animatorToRemove = animator.tag;
     }
  }
  
  // Remove completed animator
  if (animatorToRemove != -1)
  {
    for (int i = 0; i < lineAnimatorList.size(); i++) {
      LineAnimator animator = lineAnimatorList.get(i);
      if (animator.tag == animatorToRemove) {
        lineAnimatorList.remove(i);
        animatorToRemove = -1;
      }
    }
  }
  
  // Update the display of all the dark line animators. If the animator is complete, mark it for removal
  for (DarkLineAnimator animator : darkLineAnimatorList) {
     if (!animator.animationComplete) {
       animator.updateTheAnimator();
     }
     else {
       darkLineAnimatorToRemove = animator.tag;
     }
  }
  
  // Remove completed animator
  if (darkLineAnimatorToRemove != -1)
  {
    for (int i = 0; i < darkLineAnimatorList.size(); i++) {
      DarkLineAnimator animator = darkLineAnimatorList.get(i);
      if (animator.tag == animatorToRemove) {
        darkLineAnimatorList.remove(i);
        darkLineAnimatorToRemove = -1;
      }
    }
  }
  
  noFill();
  frame.setTitle(" " + int(frameRate)); // write the fps in the top-left of the window
  
  // Create a black mask around the tree to prevent bleeding on the wall behind the sculpture
  maskOutline();
}

/**
  Draw a black shape around the tree in the foreground to prevent the light from bleeding over the sculpture
*/
void maskOutline()
{
  PointFetcher point = new PointFetcher();
  
  // The z coordinate for the mask
  float z = 10;
  
  pushMatrix();
  
  fill(0); // fill with black
  noStroke(); // no stroke
  beginShape();
  
  // Create an array to hold all of the points
  PVector[] v = new PVector[20];
  
  // Fetch the points that make up the outer edge of the tree
  v[0] = point.getPoint(0);
  v[1] = point.getPoint(4);
  v[2] = point.getPoint(9);
  v[3] = point.getPoint(13);
  v[4] = point.getPoint(17);
  v[5] = point.getPoint(23);
  v[6] = point.getPoint(31);
  v[7] = point.getPoint(30);
  v[8] = point.getPoint(29);
  v[9] = point.getPoint(28);
  v[10] = point.getPoint(27);
  v[11] = point.getPoint(26);
  v[12] = point.getPoint(25);
  v[13] = point.getPoint(24);
  v[14] = point.getPoint(19);
  v[15] = point.getPoint(18);
  v[16] = point.getPoint(14);
  v[17] = point.getPoint(6);
  v[18] = point.getPoint(5);
  v[19] = point.getPoint(1);
  
  // Start at the bottom point
  vertex(v[0].x, height, 0);
  
  // Add a vertex for every point in the array
  for (int i = 0; i < 20; i++) {
    v[i].mult(9.25);
    vertex(v[i].x, v[i].y, z);
  }
  
  // Finish the shape by adding points around the outside of the screen so the tree itself isnt filled in
  vertex(v[0].x, v[0].y, z);
  vertex(v[0].x, height, z);
  vertex(0, height, z);
  vertex(0,0,z);
  vertex(width,0,z);
  vertex(width, height, z);
  vertex(v[0].x, height, z);
  vertex(v[0].x, v[0].y, z);
  
  endShape();
  popMatrix();
}

//*** LEAP GESTURE RECOGNITION ***//

// SWIPE GESTURE - Add an industry animator
void leapOnSwipeGesture(SwipeGesture g, int state) 
{
  int       id               = g.getId();
  PVector   position         = g.getPosition();
  PVector   position_start   = g.getStartPosition();
  PVector   direction        = g.getRawDirection();
  float     speed            = g.getSpeed();

  switch(state){
    case 1: // Start
      break;
    case 2: // Update
      break;
    case 3: // Stop - the gesture has finished
    {
      if (swipeTimer > minSwipeInterval) {
        swipeTimer = 0;
        darkLineAnimatorList.add(new DarkLineAnimator(direction, position_start, speed, id));
      }
      break;
    }
  }
}

// KEY TAP GESTURE - Add a new line
void leapOnKeyTapGesture(KeyTapGesture g) 
{
  lineAnimatorList.add(new LineAnimator(nextAnimatorTag));
  nextAnimatorTag++; // Increment the animator tag
}

// MOUSE CLICKED - Add a new line
void mouseClicked()
{
  lineAnimatorList.add(new LineAnimator(nextAnimatorTag));
  nextAnimatorTag++; // Increment the animator tag
}
