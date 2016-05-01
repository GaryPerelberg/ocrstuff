class NeuralNetwork 
{
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
  // but IntLists do.
  IntList indexes = new IntList();

  // Arrays for holding various information. Might be replaced
  // by some kind of vector object 2D array
  int [][] total;
  int [] total1;
  int [][] negTotal;
  int [][] overlapTotal;
  int [][][] mutuallyExcl;

  MachineLearning() {
    // Put the data into a format that is useful for us
    formatData();

    // Want it to be randomized, because we don't really want to
    // do any of the work for this, and it's probably best if the
    // data is presented in a random order. Randomization is a key
    // part of machine learning/general algorithm creation because
    // it allows for chance really great things to happen with a net
    // effect of good performance.
    indexes.shuffle();

    generateStats();

    // StringList that contains all of the mis-paired pairs
    StringList badPairs = new StringList();
    // StringList containing all of the correctly-paired pairs
    StringList goodPairs = new StringList();
    // To keep track of the total # of missed pairs
    int numMissed = 0;
    // To keep track of missed pairs, mistaken pairs, and true pairs
    int [] misses = new int [10];
    int [] mistakes = new int [10];
    int [] hits = new int [10];

    // Fill them initially
    Arrays.fill(misses, 0);
    Arrays.fill(mistakes, 0);
    Arrays.fill(hits, 0);

    int [] counts = new int [3];
    Arrays.fill(counts, 0);

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

        int remainder1 = n1 % data[0].length;
        int remainder2 = n2 % data[0].length;
        int num1 = round(float(n1 - remainder1) / data[0].length);
        int num2 = round(float(n2 - remainder2) / data[0].length);
        boolean clumpy = !clumped(mutuallyExcl[i][j]);

        if (withinRange(over1, over2) && over > .5 && over != -1 && under != -1) {
          counts[0]++;
          String pair = "(" + num1 + ", " + num2 + ")";

          boolean match = num1 == num2;

          if (!match) {
            badPairs.append(pair);
            mistakes[num1]++;
          } else {
            goodPairs.append(pair);
            hits[num1]++;
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
        } else if (clumpy && over != -1 && under != -1) {
          counts[1]++;
          String pair = "(" + num1 + ", " + num2 + ")";

          boolean match = num1 == num2;

          if (!match) {
            badPairs.append(pair);
            mistakes[num1]++;
          } else {
            goodPairs.append(pair);
            hits[num1]++;
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
        }
      }
    }
    //printArray(badPairs);
    //printArray(goodPairs);
    //println(numMissed);
    //println(pow(indexes.size(), 2) - indexes.size());
    printArray(counts);

    // Record all of the results in a small summary that is easily read and parsed
    PrintWriter dataWriter = createWriter("samples/I " + day() + "." + month() + "." + year() + " " + hour() + "." + minute() + "." + second() + ".txt");
    for (int i = 0; i < 10; i++) {
      float proportion = float(hits[i]) / (hits[i] + mistakes[i]);
      String data = i + ": %: " + nfc(proportion, 2) + "\t\tCorrect: " + hits[i] + "\tMistakes: " + mistakes[i] + "\tMissed: " + misses[i];
      println(data);
      dataWriter.println(data);
    }
    dataWriter.flush();
    dataWriter.close();
  }

  void formatData() {
    int running = 0;
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        arrays.add(new int [50 * 50]);

        indexes.append(i * data[i].length + j);
        for (int k = 0; k < data[i][j].length; k++) {  
          arrays.get(running)[k] = data[i][j][k];
        }
        running++;
      }
    }
  }

  void generateStats() {
    total = new int [indexes.size()][indexes.size()];
    total1 = new int [indexes.size()];
    negTotal = new int [indexes.size()][indexes.size()];
    overlapTotal = new int [indexes.size()][indexes.size()];
    mutuallyExcl = new int [indexes.size()][indexes.size()][2500];

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
    for (int i = 0; i < 50; i++) {
      for (int j = 0; j < 50; j++) {
        if (mutExcl[i * 50 + j] == 1) {
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