/**
  Point Fetcher class
  Controls the points used for the tree
*/
class PointFetcher
{
  // The array of all the tree vertices
  PVector pointList[] = new PVector[32];
  
  PointFetcher()
  {
    // Create the points that define the tree
    // ADJUST THESE VALUES TO MAP THE PROJECTION TO THE SCULPTURE
    
     pointList[0]  = new PVector(81.3 + 9.2, 71.1 + 11.2, -43.4);   // 0 - BOTTOM CENTER
     pointList[1]  = new PVector(72.8 + 7.9, 63.5 + 4.0, -55.8);    // 1
     pointList[2]  = new PVector(71.6 + 9.4, 56.5 + 2.5, -48.3);    // 2
     pointList[3]  = new PVector(86.1 + 11.0, 54.2 + 5.0, -42.1);   // 3
     pointList[4]  = new PVector(93.8 + 9.6, 53.8 + 3.3, -51.3);    // 4
     pointList[5]  = new PVector(60.0 + 9.1, 53.7 + 2.1, -47.4);    // 5
     pointList[6]  = new PVector(58.2 + 8.7, 42.4 - 2.0, -43.5);    // 6
     pointList[7]  = new PVector(77.4 + 9.60, 49.8 + 2.45, -38.9);  // 7
     pointList[8]  = new PVector(90.6 + 11.70, 39.4 + 3.25, -37.8); // 8
     pointList[9]  = new PVector(103.2 + 12.7, 41.1 + 1.9,-36.7);   // 9
     pointList[10] = new PVector(60.7 + 8.5, 36.4 - 3.5, -35.5);    // 10
     pointList[11] = new PVector(70.5 + 9.40, 33.7 - 3.30, -35.0);  // 11
     pointList[12] = new PVector(99.1 + 13.4, 31.2 - 1.6, -32.2);   // 12
     pointList[13] = new PVector(114.0 + 16.3, 28.6 + 1.8, -30.1);  // 13
     pointList[14] = new PVector(44.3 + 6.75, 29.4 - 5.25, -32.8);  // 14
     pointList[15] = new PVector(56.8 + 7.5, 27.4 - 6.1, -28.5);    // 15
     pointList[16] = new PVector(90.7 + 12.25, 25.6 - 4.3, -28.3);  // 16
     pointList[17] = new PVector(110.2 + 16.5, 21.9 - 1.3, -28.0);  // 17
     pointList[18] = new PVector(27.6 + 2.9, 28.3 - 6.1, -24.3);    // 18
     pointList[19] = new PVector(27.3 + 3.76, 21.8 - 7.56, -23.8);  // 19
     pointList[20] = new PVector(40.0 + 4.65, 21.5 - 5.4, -24.0);   // 20
     pointList[21] = new PVector(67.4 + 8.55, 21.2 - 8.9, -19.2);   // 21
     pointList[22] = new PVector(77.7 + 10.5, 17.3 - 8.0, -20.6);   // 22
     pointList[23] = new PVector(110.7 + 18.0, 13.9 - 2.3, -13.5);  // 23
     pointList[24] = new PVector(4.4 - 2.90, 10.4 - 10, -10.6);     // 24 - UPPER LEFT
     pointList[25] = new PVector(30.7 + 2.5, 10.4 - 9.5, -17.9);    // 25
     pointList[26] = new PVector(42.4 + 3.85, 13.8 - 6.95, -17.1);  // 26
     pointList[27] = new PVector(59.0 + 6.9, 14.8 - 8.1, -7.6);     // 27
     pointList[28] = new PVector(89.2 + 12.55, 15.3 - 8.7, -18.3);  // 28
     pointList[29] = new PVector(98.9 + 14.8, 15.4 - 8.2, -12.9);   // 29
     pointList[30] = new PVector(108.3 + 19.0, 8.7 - 5.1, -7.8);    // 30
     pointList[31] = new PVector(118.9 + 19.0, 4.8 + 10.0, -3.5);   // 31 - UPPER RIGHT
  } 
  
  /** 
    Get a point for a given index (see TreePoints.pdf for index references)
  */
  PVector getPoint(int index)
  {
    PVector returnVector = new PVector(pointList[index].x, pointList[index].y, pointList[index].z);
    return returnVector;
  }
  
  /**
    Get the next point for an animating Line, based on the lines end point index
  */
  int getNextForPoint(int index)
  {
    int returnIndex = 0;          // Index to return
    int maxIndex = 0;             // The number of options in the array to choose from
    int[] indexList = new int[5]; // Array to hold choices based on input index
    
    // Create the possible next point options for the index
    switch (index)
    {
     case 0:
     {
       maxIndex = 4;
       indexList[0] = 1;
       indexList[1] = 2;
       indexList[2] = 3;
       indexList[3] = 4;
       indexList[4] = 7;
       break;
     }
     case 1:
     {
       maxIndex = 1;
       indexList[0] = 2;
       indexList[1] = 5;
       break;
     }
     case 2:
     {
       maxIndex = 3;
       indexList[0] = 5;
       indexList[1] = 6;
       indexList[2] = 7;
       indexList[3] = 10;
       break;
     }
     case 3:
     {
       maxIndex = 1;
       indexList[0] = 7;
       indexList[1] = 8;
       break;
     }
     case 4:
     {
       maxIndex = 3;
       indexList[0] = 3;
       indexList[1] = 8;
       indexList[2] = 9;
       indexList[3] = 12;
       break;
     }
     case 5:
     {
       maxIndex = 0;
       indexList[0] = 6;
       break;
     }
     case 6:
     {
       maxIndex = 1;
       indexList[0] = 14;
       indexList[1] = 10;
       break;
     }
     case 7:
     {
       maxIndex = 2;
       indexList[0] = 8;
       indexList[1] = 10;
       indexList[2] = 11;
       break;
     }
     case 8:
     {
       maxIndex = 2;
       indexList[0] = 11;
       indexList[1] = 12;
       indexList[2] = 16;
       break;
     }
     case 9:
     {
       maxIndex = 1;
       indexList[0] = 12;
       indexList[1] = 13;
       break;
     }
     case 10:
     {
       maxIndex = 3;
       indexList[0] = 11;
       indexList[1] = 14;
       indexList[2] = 15;
       indexList[3] = 21;
       break;
     }
     case 11:
     {
       maxIndex = 2;
       indexList[0] = 16;
       indexList[1] = 21;
       indexList[2] = 22;
       break;
     }
     case 12:
     {
       maxIndex = 2;
       indexList[0] = 16;
       indexList[1] = 17;
       indexList[2] = 29;
       break;
     }
     case 13:
     {
       maxIndex = 0;
       indexList[0] = 17;
       break;
     }
     case 14:
     {
       maxIndex = 2;
       indexList[0] = 15;
       indexList[1] = 18;
       indexList[2] = 20;
       break;
     }
     case 15:
     {
       maxIndex = 3;
       indexList[0] = 20;
       indexList[1] = 21;
       indexList[2] = 26;
       indexList[3] = 27;
       break;
     }
     case 16:
     {
       maxIndex = 2;
       indexList[0] = 22;
       indexList[1] = 28;
       indexList[2] = 29;
       break;
     }
     case 17:
     {
       maxIndex = 1;
       indexList[0] = 23;
       indexList[1] = 29;
       break;
     }
     case 18:
     {
       maxIndex = 1;
       indexList[0] = 19;
       indexList[1] = 20;
       break;
     }
     case 19:
     {
       maxIndex = 0;
       indexList[0] = 24;
       break;
     }
     case 20:
     {
       maxIndex = 2;
       indexList[0] = 24;
       indexList[1] = 25;
       indexList[2] = 26;
       break;
     }
     case 21:
     {
       maxIndex = 1;
       indexList[0] = 22;
       indexList[1] = 27;
       break;
     }
     case 22:
     {
       maxIndex = 1;
       indexList[0] = 27;
       indexList[1] = 28;
       break;
     }
     case 23:
     {
       maxIndex = 1;
       indexList[0] = 30;
       indexList[1] = 31;
       break;
     }
     
     // The line has reached the top of the tree, return 0 to indicate the line is done
     default: 
     { 
       return 0;
     } 
    }
    
    // Rancomly pick a point from the list of options
    int returnValue = indexList[int(random(0,maxIndex+1))];  
    
    // Return the inedex value
    return returnValue;
  }
  
}
