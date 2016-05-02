/***************** Things That Actually Work *********************/
int B_MASK = 255;
int G_MASK = 255<<8;
int R_MASK = 255<<16;

color getColorFromInt(int i) {

  // then : 
  int r = i & R_MASK;
  int g = i & G_MASK;
  int b = i & B_MASK;

  return (color(r, g, b));
}


void intArrayToScreen(int[][][] data)
{       
  for (int i = 0; i < data[0][0].length; i++)
    if (data[0][0][i] ==  1)
      data[0][0][i] = -16777216;
    else if (data[0][0][i] == 0)
      data[0][0][i] = -1;

  loadPixels();
  for (int i = 0; i < data[0][0].length; i++)
    pixels[i] = data[0][0][i];
  updatePixels();
}

void intArrayToScreen(int [] data)
{
  loadPixels();
  for (int i = 0; i < data.length; i++)
    pixels[i] = data[i];
  updatePixels();
}

void convertingIntArraytoImages() {
  IntList randIndices = new IntList();

  while (randIndices.size() < dataSample.length) {
    int max = data.length;
    int min = 0;

    int n = int(random(min * data[0].length, max * data[0].length));
    randIndices.appendUnique(n);
  }
  //printArray(randIndices);
  int n1 = data.length;
  int n2 = data[0].length;
  int n3 = data[0][0].length;

  for (int i = 0; i < randIndices.size(); i++) {
    dataSample[i] = createImage(23, 37, RGB);
    int n = randIndices.get(i);
    int i1 = int(float(n) / (n2));
    int j1 = int(float(n) / n1);
    intArraytoImage(dataSample[i], data[i1][j1]);
  }
}

void intArraytoImage(PImage img, int [] array) {
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    img.pixels[i] = (array[i] == 0) ? color(255) : color(0);
  }
  img.updatePixels();
}