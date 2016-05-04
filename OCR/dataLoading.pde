/***************** All of This Stuff Actually Works *********************/

void loadFiles()
{
  currentDir = new File(sketchPath() + "/data");
  //println(currentDir.toString());
  String[] fileNames = currentDir.list();
  int[] numEntriesPerChar = new int[10];

  for (int i = 0; i < fileNames.length; i++)
    if (fileNames[i].indexOf(dataType) > -1)
    {
      int charValue = int(fileNames[i].split(" ")[0]);
      numEntriesPerChar[charValue]++;
    }

  for (int i = 0; i < numEntriesPerChar.length; i++)
    data[i] = new int[numEntriesPerChar[i]][];


  for (int i = 0; i < fileNames.length; i++)
  {
    int charValue = int(fileNames[i].split(" ")[0]);
    if (fileNames[i].indexOf(dataType) > -1)
    {
      PImage image = loadImage(fileNames[i]);
      //image(image, 0, 0);
      image.loadPixels();
      //println("Char: " + charValue);
      //println("Char value: " + numEntriesPerChar[charValue]);
      data[charValue][numEntriesPerChar[charValue] - 1] = image.pixels;
      numEntriesPerChar[charValue]--;
    }
  }

  cleanUp();

  correctImageDistribution();

  convertingIntArraytoImages();
}

// Makes the image binary and gets rid of unwanted pixels
void cleanUp() {
  // Convert color integers into 0s and 1s where 0 = white and 1 = black
  for (int i = 0; i < data.length; i++)
    for (int j = 0; j < data[i].length; j++)
      for (int k = 0; k < data[i][j].length; k++)
        if (data[i][j][k] == -1)
          data[i][j][k] = 0;
        else
          data[i][j][k] = 1;




  // Want to try something different
  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data[i].length; j++) {
      //This actually works really well
      erode(data[i][j]);
      dilate(data[i][j]);
    }
  }
}

// Finds the distribution of pixels throughout all of the images so that we can
// get rid of the pixels we don't need/want.
void correctImageDistribution() {
  int [] hDistribution = new int [50];
  int [] vDistribution = new int [50];
  
  // store the x start, the x end, the y start, and the y end in here
  int [][][] starts = new int [data.length][data[0].length][4];

  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data[i].length; j++) {
      for (int n = 0; n < 50; n++) {
        if (rowFilled(i, j, n)) vDistribution[n]++;
        if (colFilled(i, j, n)) hDistribution[n]++;
        
        if (!rowFilled(i, j, n - 1) && rowFilled(i, j, n)) starts[i][j][0] = n;
        else 
        if (!colFilled(i, j, n-1) && colFilled(i, j, n)) starts[i][j][2] = n;
      }
    }
  }
  //printArray(hDistribution);
  //printArray(vDistribution);

  int [][] reframe = new int [50][50];

  int vcount = 0;
  int hcount = 0;
  int minx = 0;
  int miny = 0;

  for (int i = 0; i < reframe.length; i++) {
    for (int j = 0; j < reframe[i].length; j++) {
      if (hDistribution[i] < 11 || vDistribution[j] < 11) {
        reframe[i][j] = 0;
        if (i < 25 && hDistribution[i] < 11) minx = i;
        if (j < 25 && vDistribution[j] < 11) miny = j;
      } else {
        reframe[i][j] = 1;
        if (hDistribution[i] > 11 && i == 25) vcount++;
        if (vDistribution[j] > 11 && j == 25) hcount++;
      }
    }
  }

  //println("");
  //for (int i = 0; i < reframe.length; i++) {
  //  for (int j = 0; j < reframe.length; j++) {
  //    print(reframe[j][i] + " ");
  //  }
  //  println("");
  //}

  println(minx);
  println(miny);
  println(vcount);
  println(hcount);
  
  arrayHeight = vcount;
  arrayWidth = hcount;

  for (int x = 0; x < data.length; x++) {
    for (int y = 0; y < data[x].length; y++) {
      int [] points = new int [vcount * hcount];
      for (int i = 0; i < hcount; i++) {
        for (int j = 0; j < vcount; j++) {
          points[newIndex(j, i)] = data[x][y][index(j + miny + 1, i + minx + 1)];
        }
      }
      data[x][y] = points;
    }
  }
}

int index(int j, int i) {
  return(constrain(j * 50 + i, 0, (50 * 50) - 1));
}

int newIndex(int j, int i) {
  return(constrain(j * arrayWidth + i, 0, (arrayWidth * arrayHeight) - 1));
}

// Returns whether a given row has any of its cells filled,
// i.e. contains a number other than 0
boolean rowFilled(int x, int y, int row) {
  int [] points = data[x][y];
  int count = 0;
  for (int i = 0; i < 50; i++) {
    int index = index(row, i);
    if (points[index] > 0) count++;
  }
  return(count > 0);
}

// Returns whether a given column has any of its cells filled,
// i.e. contains a number other than 0
boolean colFilled(int x, int y, int col) {
  int [] points = data[x][y];
  int count = 0;
  for (int i = 0; i < 50; i++) {
    int index = index(i, col);
    if (points[index] > 0) count++;
  }
  return(count > 0);
}