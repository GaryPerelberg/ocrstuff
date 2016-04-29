String dataType = ".png";
int[][][] data = new int[10][][];
File currentDir;
MachineLearning program;

void setup() 
{
  size(50,50);
 loadFiles();
 program = new MachineLearning();
}

void loadFiles()
{
  currentDir = new File(sketchPath() + "/data");
  //println(currentDir.toString());
  String[] fileNames = currentDir.list();
  int[] numEntriesPerChar = new int[10];
  
  for(int i = 0; i < fileNames.length; i++)
    if (fileNames[i].indexOf(dataType) > -1)
    {
     int charValue = int(fileNames[i].split(" ")[0]);
     numEntriesPerChar[charValue]++;
    }
  
  for(int i = 0; i < numEntriesPerChar.length; i++)
     data[i] = new int[numEntriesPerChar[i]][];
  
  
  for(int i = 0; i < fileNames.length; i++)
  {
     int charValue = int(fileNames[i].split(" ")[0]);
     if(fileNames[i].indexOf(dataType) > -1)
     {
       PImage image = loadImage(fileNames[i]);
       image(image, 0, 0);
       image.loadPixels();
       //println("Char: " + charValue);
       //println("Char value: " + numEntriesPerChar[charValue]);
       data[charValue][numEntriesPerChar[charValue] - 1] = image.pixels;
       numEntriesPerChar[charValue]--;
     }
     
  }
  
  // Convert color integers into 0s and 1s where 0 = white and 1 = black
  for(int i = 0; i < data.length; i++)
     for(int j = 0; j < data[i].length; j++)
       for(int k = 0; k < data[i][j].length; k++)
          if(data[i][j][k] == -1)
              data[i][j][k] = 0;
          else
              data[i][j][k] = 1; //<>// //<>//
}

int B_MASK = 255;
int G_MASK = 255<<8;
int R_MASK = 255<<16;

color getColorFromInt(int i) {

  // then : 
  int r = i & R_MASK;
  int g = i & G_MASK;
  int b = i & B_MASK;

  return (color(r,g,b)); //<>//
}

void draw()
{
  background(255);
}

class NeuralNetwork 
{
  
}

class MachineLearning {
  // Bayesian program uses several different factors
  // We can use the arrays to make a "vector" out of these
  // Want to create a vector that is for each 
  
  // Also want it to classify things into 10 different categories
  int numTypes = 10;
  HashMap<Integer, ArrayList<int[]>> categories = new HashMap<Integer, ArrayList<int[]>>();
  IntList cats = new IntList();
  
  ArrayList<int []> arrays = new ArrayList<int[]>();
  IntList indexes = new IntList();
  
  int [][] total;
  int [] total1;
  int [][] negTotal;
  int [][] overlapTotal;
  
  MachineLearning() {
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        arrays.add(new int [50 * 50]);
        indexes.append(i * data[i].length + j);
        for (int k = 0; k < data[i][j].length; k++) {
          arrays.get(i * data[i].length + j)[k] = data[i][j][k];
        }
      }
    }
    
    indexes.shuffle();
    
    total = new int [indexes.size()][indexes.size()];
    total1 = new int [indexes.size()];
    negTotal = new int [indexes.size()][indexes.size()];
    overlapTotal = new int [indexes.size()][indexes.size()];
    
    for (int i = 0; i < indexes.size(); i++) {
      total1[i] = total(arrays.get(i));
      
      int one = indexes.get(i);
      for (int j = 0; j < indexes.size(); j++) {
        int two = indexes.get(j);
        if (i != j) {
          total[i][j] = totalTotal(arrays.get(one), arrays.get(two));
          negTotal[i][j] = totalUnderlap(arrays.get(one), arrays.get(two));
          overlapTotal[i][j] = totalOverlap(arrays.get(one), arrays.get(two));
        } else {
          total[i][j] = -1;
          negTotal[i][j] = -1;
          overlapTotal[i][j] = -1;
        }
      }
    }
    StringList badPairs = new StringList();
    StringList goodPairs = new StringList();
    for (int i = 0; i < indexes.size(); i++) {
      for (int j = i + 1; j < indexes.size(); j++) {
        int tot = total[i][j];
        
        int t1 = total1[i];
        int t2 = total1[j];
        
        float over = overlapTotal[i][j];
        float under = negTotal[i][j];
        float over1 = over / t1;
        float over2 = over / t2;
        over /= tot;
        under /= tot;
        if (withinRange(over1, over2) && over > .5 && over != -1 && under != -1) {
          int n1 = indexes.get(i);
          int n2 = indexes.get(j);
          
          int remainder1 = n1 % data[0].length;
          int remainder2 = n2 % data[0].length;
          int num1 = round(float(n1 - remainder1) / data[0].length);
          int num2 = round(float(n2 - remainder2) / data[0].length);
          String pair = "(" + num1 + ", " + num2 + ")";
          if (num1 != num2) {
            badPairs.append(pair);
          } else {
            goodPairs.append(pair);
          }
          println("Num1, Num2: " + pair + "  N1, N2: (" + n1 + ", " + n2 + ")\tOver: " + over);
          if (categories.containsKey(num1)) {
            categories.get(num1).add(arrays.get(indexes.get(j)));
          } else {
            cats.appendUnique(num1);
            categories.put(num1, new ArrayList<int[]>());
            categories.get(num1).add(arrays.get(indexes.get(i)));
            categories.get(num1).add(arrays.get(indexes.get(j)));
          }
        }
      }
    }
    printArray(badPairs);
    printArray(goodPairs);
    println(pow(indexes.size(), 2) - indexes.size());
  }
  
  boolean withinRange(float num1, float num2) {
    if (num1 < num2) {
      return(num1 + .1 > num2);
    } else if (num1 > num2) {
      return(num1 - .1 < num2);
    }
    return(num1 + .05 > num2 && num1 - .05 < num2);
  }
  
  int end = millis() + 1000;
  int count = 0;
  void draw() {
    if (end > millis()) {
      
    } else {
      end = millis() + 1000;
      count++;
      count %= cats.size();
    }
  }
  
  int total(int [] one) {
    int total = 0;
    for (int i = 0; i < one.length; i++) {
      total += one[i];
    }
    return(total);
  }
  
  int totalOverlap(int [] one, int [] two) {
    int total = 0;
    for (int i = 0; i < one.length; i++) {
        total += one[i] * two[i];
    }
    return(total);
  }
  
  int totalTotal(int [] one, int [] two) {
    int total = 0;
    for (int i = 0; i < one.length; i++) {
      if (one[i] == 1 || two[i] == 1) {
        total ++;
      }
    }
    return(total);
  }
  
  int totalUnderlap(int [] one, int [] two) {
    int negTotal = 0;
    for (int i = 0; i < one.length; i++) {
      if ((one[i] == 0 && two[i] == 1) || (one[i] == 1 && two[i] == 0)) {
        negTotal ++;
      }
    }
    return(negTotal);
  }
  
  int [] combinedArray(int [] one, int [] two) {
    int [] array = new int [one.length];
    for (int i = 0; i < array.length; i++) {
      array[i] = one[i] * two[i];
    }
    return(array);
  }
}