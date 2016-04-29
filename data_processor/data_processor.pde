// Sample processor - makes a little visualization of the data so far so that we have a better idea of what's going on

String myPath = "";
String dataLocation = "/OCR/samples";
FloatList [] floats = new FloatList [10];

void setup() {
  size(500, 500);
  myPath = sketchPath();
  //println(myPath);
  //println(myPath.substring(0, myPath.lastIndexOf("/")));

  // Go back one folder
  myPath = myPath.substring(0, myPath.lastIndexOf("/"));
  // Now go to the actual data location
  myPath = myPath + dataLocation;
  println(myPath);

  File dataDir = new File(myPath);
  String [] names = dataDir.list();

  for (int i = 0; i < 10; i++) {
    floats[i] = new FloatList();
  }

  for (int i = 0; i < names.length; i++) {
    String [] data = loadStrings(myPath + "/" + names[i]);
    for (int j = 0; j < data.length; j++) {
      String [] splits = splitTokens(data[j], " \t:");
      if (splits.length >= 3) {
        floats[j].append(float(splits[2]));
      }
    }
  }
  for (FloatList flow : floats) {
    //printArray(flow);
    flow.sort();
  }
}

void draw() {
  background(255);
  float x0 = 50;
  float xf = width - 50;
  float y0 = height - 50;
  float yf = 50;
  float yrange = y0 - yf;
  float xrange = xf - x0;
  float xincr = xrange / 10;
  for (int i = 0; i < floats.length; i++) {
    float xi = x0 + xincr * (i + 1);
    for (int j = 0; j < floats[i].size(); j++) {
      fill(255, 0, 0, 30);
      noStroke();
      ellipse(xi, y0 - yrange * floats[i].get(j), 4, 4);
    }
    
    stroke(0);
    strokeWeight(1);
    // Lowest line
    line(xi - 4, y0 - yrange * q0(floats[i]), xi + 4, y0 - yrange * q0(floats[i]));
    // Highest line
    line(xi - 4, y0 - yrange * q4(floats[i]), xi + 4, y0 - yrange * q4(floats[i]));
    // Median line
    line(xi - 4, y0 - yrange * q2(floats[i]), xi + 4, y0 - yrange * q2(floats[i]));
    
    strokeWeight(.75);
    noFill();
    rectMode(CORNERS);
    rect(xi - 4, y0 - yrange * q1(floats[i]), xi + 4, y0 - yrange * q3(floats[i]));
    
    //Lower vertical line
    line(xi, y0 - yrange * q0(floats[i]), xi, y0 - yrange * q1(floats[i]));
    // Higher vertical line
    line(xi, y0 - yrange * q3(floats[i]), xi, y0 - yrange * q4(floats[i]));
    
  }
  
  stroke(0);
  strokeWeight(2);
  line(x0, y0 - yrange * .5, xf, y0 - yrange * .5);
  strokeWeight(4);
  line(x0, y0, x0, yf);
  line(x0, y0, xf, y0);
  textSize(15);
  textAlign(RIGHT);
  fill(0);
  for (int i = 0; i < 11; i+=2) {
    text(nfc(float(i) / 10, 2), x0 - 5, y0 - (yrange / 10) * i);
  }
  textAlign(TOP, CENTER);
  for (int i = 0; i < 10; i+=2) {
    text(i, x0 + xincr * (i + 1), y0 + 10);
  }
}

float q3(FloatList f) {
  if (f.size() % 4 == 0) {
    int n1 = int(f.size() * .75);
    return(avg(n1, f));
  } else {
    int n1 = int(f.size() * .75);
    return(f.get(n1));
  }
}

float q1(FloatList f) {
  if (f.size() % 4 == 0) {
    int n1 = int(f.size() * .25);
    return(avg(n1, f));
  } else {
    int n1 = int(f.size() * .25);
    return(f.get(n1));
  }
}

float q2(FloatList f) {
  if (f.size() % 2 == 0) {
    int n1 = int(f.size() * .5);
    return(avg(n1, f));
  } else {
    int n1 = int(f.size() * .5);
    return(f.get(n1));
  }
}

float q0(FloatList f) {
  return(f.min());
}

float q4(FloatList f) {
  return(f.max());
}

float avg(int n, FloatList f) {
  return((f.get(n) + f.get(n + 1)) / 2);
}