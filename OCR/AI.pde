class NeuralNetwork 
{
  // Based on a simple implementation of a neural network by Michael Nielsen,
  // found here: https://github.com/mnielsen/neural-networks-and-deep-learning/blob/master/src/network.py
  int num_layers;
  int [] sizes;
  float [] biases;
  float [] weights;
  
  NeuralNetwork(int [] sizes) {
    this.sizes = sizes;
    this.num_layers = sizes.length;
    
  }
  
  void feedForward() {
  }
  
  void sgd() {
  }
  
  void updateMiniBatch() {
  }
  
  void backProp() {
  }
  
  void evaluate() {
  }
  
  void costDerivative() {
  }
}

float sigmoid(float z) {
  // The sigmoid function
  return(1.0 / (1.0 + exp(-z)));
}

float sigmoid_prime(float z) {
  // The derivative of the sigmoid function
  return(sigmoid(z) * (1 - sigmoid(z)));
}

// Class for implementing some kind of machine learning
class MachineLearning {
  // Bayesian program uses several different factors
  // We can use the arrays to make a "vector" out of these
  // Want to create a vector that is for each 

  // Also want it to classify things into 10 different categories
  int numTypes = 10;
  // Hashmap for storing the different arrays that actually belong to each of
  // the categories
  HashMap<Integer, ArrayList<int[]>> categories = new HashMap<Integer, ArrayList<int[]>>();
  // The intlist of the different categories
  IntList cats = new IntList();

  // The information as stored in arrays within an arraylist
  ArrayList<int []> arrays = new ArrayList<int[]>();
  // An intlist of indexes so that we can randomize the accessation
  // of the arrays, because ArrayLists don't include a shuffle function
  // but IntLists do. Also need to split up training vs test data.
  // Indexes should hold the training data.
  IntList indexes = new IntList();
  IntList testIndexes = new IntList();

  // Arrays for holding various information. Might be replaced
  // by some kind of vector object 2D array
  int [][] total;
  int [] total1;
  int [][] negTotal;
  int [][] overlapTotal;
  int [][][] mutuallyExcl;
  int [][] totalConfusion;

  float proportionTrainingData = .5;

  MachineLearning(float proportionOfTrainingData) {
    proportionTrainingData = proportionOfTrainingData;
    totalConfusion = new int [10][10];
    formatData();
  }

  void run() {
    // Put the data into a format that is useful for us
    // Want it to be randomized, because we don't really want to
    // do any of the work for this, and it's probably best if the
    // data is presented in a random order.
    indexes.shuffle();

    generateStats();
    
    int [][] confusionMatrix = new int [10][10];
    // StringList that contains all of the mis-paired pairs
    StringList badPairs = new StringList();
    // StringList containing all of the correctly-paired pairs
    StringList goodPairs = new StringList();
    // To keep track of the total # of missed pairs
    int numMissed = 0;
    // To keep track of missed pairs, mistaken pairs, and true pairs
    int [] misses = new int [10];
    int [] mistakes = new int [10];
    int [][] mistakesBreakdown = new int [10][2];
    int [][] hitsBreakdown = new int [10][2];
    int [] hits = new int [10];
    int [] ignored = new int [10];

    // Fill them initially
    Arrays.fill(misses, 0);
    Arrays.fill(mistakes, 0);
    Arrays.fill(hits, 0);

    //printArray(data[3][4]);

    int [] counts = new int [3];

    // Now determine whether there are viable pairs by iterating
    // through all of it
    for (int i = 0; i < indexes.size(); i++) {
      for (int j = i + 1; j < indexes.size(); j++) {
        // This is the total number of boxes filled, basically by using an
        // OR boolean, as in if either or both indices were 1, then add a 1.
        // If both were 0, add nothing.
        int tot = total[i][j];

        // The individual totals # of filled/black pixels
        // for each character being compared
        int t1 = total1[i];
        int t2 = total1[j];

        // The sum of the overlapping regions
        float over = overlapTotal[i][j];
        // The sum of the opposite of the overlapping regions, the mutually
        // exclusive regions
        float under = negTotal[i][j];
        float over1 = over / t1;
        float over2 = over / t2;
        over /= tot;
        under /= tot;
        int n1 = indexes.get(i);
        int n2 = indexes.get(j);

        int remainder1 = n1 % 45;
        int remainder2 = n2 % 45;
        int num1 = round(float(n1 - remainder1) / 45);
        int num2 = round(float(n2 - remainder2) / 45);
        boolean clumpy = !clumped(mutuallyExcl[i][j]);
        

        if (withinRange(over1, over2) && over > .5 && over != -1 && under != -1) {
          counts[0]++;
          String pair = "(" + num1 + ", " + num2 + ")";
          confusionMatrix[num1][num2]++;
          boolean match = num1 == num2;

          if (!match) {
            badPairs.append(pair);
            mistakes[num1]++;
            mistakesBreakdown[num1][0]++;
          } else {
            goodPairs.append(pair);
            hits[num1]++;
            hitsBreakdown[num1][0]++;
          }
          //println(match + "\tNum1, Num2: " + pair + "  N1, N2: (" + n1 + ", " + n2 + ")\tOver: " + over);
          //if (categories.containsKey(num1)) {
          //  categories.get(num1).add(arrays.get(indexes.get(j)));
          //} else {
          //  cats.appendUnique(num1);
          //  categories.put(num1, new ArrayList<int[]>());
          //  categories.get(num1).add(arrays.get(indexes.get(i)));
          //  categories.get(num1).add(arrays.get(indexes.get(j)));
          //}
        } else if (num1 == num2 && n1 != n2 && over != -1 && under != -1) {
          counts[2]++;
          numMissed++;
          misses[num1]++;
        } else {
          ignored[num1]++;
        }
      }
    }
    //printArray(badPairs);
    //printArray(goodPairs);
    //println(numMissed);
    //println(pow(indexes.size(), 2) - indexes.size());
    //printArray(counts);

    // Record all of the results in a small summary that is easily read and parsed
    String definingString = "L";
    String date = day() + "." + month() + "." + year();
    String time = hour() + "." + minute() + "." + second();
    PrintWriter dataWriter = createWriter("samples/" + definingString + " " + date + " " + time + ".txt");
    for (int i = 0; i < 10; i++) {
      //println("Total: " + (hits[i] + mistakes[i]));
      //println("Missed: " + (misses[i]));
      float proportion = float(hits[i]) / (hits[i] + mistakes[i]);
      //println("Proportion: " + proportion);

      String breakdown = "Clumping - Hits: " + hitsBreakdown[i][1] + " Mistakes: " + mistakesBreakdown[i][1] + "\tOverlay - Hits: " + hitsBreakdown[i][0] + " Mistakes: " + mistakesBreakdown[i][0];

      String data = i + ": %: " + nfc(proportion, 2) + "\t\tCorrect: " + hits[i] + "\tMistakes: " + mistakes[i] + "\tMissed: " + misses[i] + "\tIgnored: " + ignored[i] + "\t" + breakdown;
      println(data);
      dataWriter.println(data);
    }
    //println("");
    for (int i = 0; i < confusionMatrix.length; i++) {
     //println("");
     for (int j = 0; j < confusionMatrix[i].length; j++) {
       //print(confusionMatrix[i][j] + "\t");
       totalConfusion[i][j] += confusionMatrix[i][j];
     }
    }
    
    dataWriter.flush();
    dataWriter.close();
  }

  void formatData() {
    indexes.clear();
    arrays.clear();
    int running = 0;
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        arrays.add(new int [23 * 37 + 1]);

        float probability = random(0, 1);
        if (probability < proportionTrainingData) {
          indexes.append(45 * i + j);
        } else {
          testIndexes.append(45 * i + j);
        }
        for (int k = 0; k < data[i][j].length; k++) { 
          arrays.get(running)[k] = data[i][j][k];
        }
        running++;
      }
    }
  }
  
  void reportConfusion() {
    println("");
    println("");
    print("\t");
    for (int i = 0; i < 10; i++) {
      print(i + "\t");
    }
    
    for (int i = 0; i < totalConfusion.length; i++) {
      println("");
      print(i + "\t");
      for (int j = 0; j < totalConfusion.length; j++) {
        print(totalConfusion[i][j] + "\t");
      }
    }
  }

  void generateStats() {
    total = new int [indexes.size()][indexes.size()];
    total1 = new int [indexes.size()];
    negTotal = new int [indexes.size()][indexes.size()];
    overlapTotal = new int [indexes.size()][indexes.size()];
    mutuallyExcl = new int [indexes.size()][indexes.size()][23 * 37];

    // Now calculate all of the stats that will occupy the arrays we just
    // initialized.
    for (int i = 0; i < indexes.size(); i++) {
      total1[i] = total(arrays.get(i));

      int one = indexes.get(i);
      for (int j = 0; j < indexes.size(); j++) {
        int two = indexes.get(j);
        // Don't want to compare two of the same
        if (i != j) {
          total[i][j] = totalTotal(arrays.get(one), arrays.get(two));
          negTotal[i][j] = totalUnderlap(arrays.get(one), arrays.get(two));
          overlapTotal[i][j] = totalOverlap(arrays.get(one), arrays.get(two));
          mutuallyExcl[i][j] = mutuallyExclusive(arrays.get(one), arrays.get(two));
        } else {
          total[i][j] = -1;
          negTotal[i][j] = -1;
          overlapTotal[i][j] = -1;
          Arrays.fill(mutuallyExcl[i][j], -1);
        }
      }
    }
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

  boolean clumped(int [] mutExcl) {
    int total = total(mutExcl);
    IntList xs = new IntList();
    IntList ys = new IntList();
    for (int i = 0; i < arrayWidth; i++) {
      for (int j = 0; j < arrayHeight; j++) {
        if (mutExcl[i * arrayWidth + j] == 1) {
          xs.append(i);
          ys.append(j);
          total--;
          if (total == 0) break;
        }
      }
    }

    FloatList dists = new FloatList();
    //int iterations = int(random(1, 6));
    for (int j = 0; j < 5; j++) {
      int refIndex = int(random(0, xs.size()));
      for (int i = 0; i < xs.size(); i++) {
        if (refIndex != i) {
          float d = dist(xs.get(refIndex), ys.get(refIndex), xs.get(i), ys.get(i));
          dists.append(d);
        }
      }
    }
    if (dists.size() != 0) {
      int maxIndex = dists.maxIndex();
      dists.remove(maxIndex);
    }
    float avg = dists.sum() / dists.size();
    avg /= 5;
    return(avg < 5 && avg != 0);
  }

  int [] mutuallyExclusive(int [] one, int [] two) {
    int [] newArray = new int [one.length];
    for (int i = 0; i < one.length; i++) {
      if ((one[i] == 0 && two[i] == 1) || (one[i] == 1 && two[i] == 0)) {
        newArray[i] = 1;
      } else {
        newArray[i] = 0;
      }
    }
    return(newArray);
  }

  int [] combinedArray(int [] one, int [] two) {
    int [] array = new int [one.length];
    for (int i = 0; i < array.length; i++) {
      array[i] = one[i] * two[i];
    }
    return(array);
  }
}