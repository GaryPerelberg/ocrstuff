/***************** Things That Don't Actually Work *********************/
// AKA the old code that Audrey came up with in her spare time/messing around.

void labelImage(PImage img) {
  int w = 23;
  int h = 37;
  img.loadPixels();

  color red = color(255, 0, 0);
  color green = color(0, 255, 0);
  color blue = color(0, 0, 255);
  color yellow = color(255, 255, 0);
  for (int i = 1; i < w - 1; i++) {
    for (int j = 1; j < h - 1; j++) {
      // The eight neighbors of the pixel at (i, j)
      int c11 = img.pixels[newIndex(i - 1, j - 1)];
      int c12 = img.pixels[newIndex(i, j - 1)];
      int c13 = img.pixels[newIndex(i + 1, j - 1)];
      int c21 = img.pixels[newIndex(i - 1, j)];
      int c23 = img.pixels[newIndex(i + 1, j)];
      int c31 = img.pixels[newIndex(i - 1, j + 1)];
      int c32 = img.pixels[newIndex(i, j + 1)];
      int c33 = img.pixels[newIndex(i + 1, j + 1)];
      int redMatches = matches(red, c11, c12, c13, c21, c23, c31, c32, c33);
      int greenMatches = matches(green, c11, c12, c13, c21, c23, c31, c32, c33);
      int blueMatches = matches(blue, c11, c12, c13, c21, c23, c31, c32, c33);
      int yellowMatches = matches(yellow, c11, c12, c13, c21, c23, c31, c32, c33);

      boolean reds = redMatches > 0;
      boolean greens = greenMatches > 0;
      boolean blues = blueMatches > 0;
      boolean yellows = yellowMatches > 0;
      if (reds) {
        float prob = random(1);
        if (blues && yellows && greens) {
          img.pixels[index(i, j)] = (prob < .25) ? red : ((prob < .5) ? blue : ((prob < .75) ? yellow : green));
        } else if (blues && yellows) {
          img.pixels[index(i, j)] = (prob < .33) ? red : ((prob < .67) ? blue : yellow);
        } else if (blues && greens) {
          img.pixels[index(i, j)] = (prob < .33) ? red : ((prob < .67) ? blue : green);
        } else if (yellows && greens) {
          img.pixels[index(i, j)] = (prob < .33) ? red : ((prob < .67) ? yellow : green);
        } else if (yellows) {
          img.pixels[index(i, j)] = (prob < .5) ? red : yellow;
        } else if (blues) {
          img.pixels[index(i, j)] = (prob < .5) ? red : blue;
        } else if (greens) {
          img.pixels[index(i, j)] = (prob < .5) ? red : green;
        } else {
          img.pixels[index(i, j)] = red;
        }
      } else if (blues) {
        float prob = random(1);
        if (yellows && greens) {
          img.pixels[index(i, j)] = (prob < .33) ? blue : ((prob < .67) ? yellow : green);
        } else if (greens) {
          img.pixels[index(i, j)] = (prob < .5) ? blue : green;
        } else if (yellows) {
          img.pixels[index(i, j)] = (prob < .5) ? blue : yellow;
        } else {
          img.pixels[index(i, j)] = blue;
        }
      } else if (greens) {
        if (yellows) {
          float prob = random(1);
          img.pixels[index(i, j)] = (prob < .5) ? green : yellow;
        } else {
          img.pixels[index(i, j)] = green;
        }
      } else if (yellows) {
        img.pixels[index(i, j)] = yellow;
      }
    }
  }
  img.updatePixels();
}

int matches(color ref, color one, color two, color three, color four, color five, color six, color seven, color eight) {
  int count = 0;
  if (ref == one) count++;
  if (ref == two) count++;
  if (ref == three) count++;
  if (ref == four) count++;
  if (ref == five) count++;
  if (ref == six) count++;
  if (ref == seven) count++;
  if (ref == eight) count++;
  return(count);
}

void extractConnectedComponents(int x, int y) {
  int [] points = data[x][y];

  ArrayList<int []> components = new ArrayList<int []>();
  int [] component1 = new int [points.length];
  Arrays.fill(component1, -1);
  
  int randomx = 13; //int(random(20, 30));
  int randomy = 14;
  
  findConnectedComponents(randomy * 37 + randomx, component1, points);
  println("");
  print("\t");
  for (int i = 0; i < 23; i++) {
    print(" " + (i % 10) + " ");
  }
  println("");
  print("  ");
  for (int i = 0; i < 37; i++) {
    print(i + "\t");
    for (int j = 0; j < 23; j++) {
      int num = component1[newIndex(i, j)];
      String result = (num < 0) ? "  " : " 0";
      
      print(result + " ");
    }
    println("");
  }
  
  println("");
  print("\t");
  for (int i = 0; i < 23; i++) {
    print(" " + (i % 10) + " ");
  }
  println("");
  print("  ");
  for (int i = 0; i < 37; i++) {
    print(i + "\t");
    for (int j = 0; j < 23; j++) {
      int num = points[newIndex(j, i)];
      //num = (num < 0) ? 0 : 1;
      String result = (num < 0) ? " 0" : "  ";
      print(result + " ");
    }
    println("");
  }
}

void findConnectedComponents(int start, int [] result, int [] points) {
  int contained = points[start];
  result[start] = contained;
  int x = xcomponent(start);
  int y = ycomponent(start);
  int [][] check = {{x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}, {x - 1, y}, {x + 1, y}, {x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1}};
  for (int i = 0; i < check.length; i++) {
    if (check[i][0] >= 0 && check[i][1] >= 0 && check[i][0] < 50 && check[i][1] < 50) {
      int here = newIndex(check[i][1], check[i][0]);
      if (points[here] == contained && (start < here)) {
        findConnectedComponents(here, result, points);
      }
    }
  }
}

int ycomponent(int index) {
  int remainder = index % 23;
  int leftover = index - remainder;
  return(int(float(leftover) / 37));
}

int xcomponent(int index) {
  return(index % 23);
}