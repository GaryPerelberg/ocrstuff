import java.util.Arrays; //<>// //<>// //<>// //<>//
import funGUI.*;
import java.util.Random;

int arrayWidth = 50;
int arrayHeight = 50;

String dataType = ".png";
int[][][] data = new int[10][][];
File currentDir;
MachineLearning program;
int count = 0; // Used in conjunction with the timer
Timer time = new Timer(750, this);

int [] distLowX = new int [50];

PImage [] dataSample = new PImage[50];

void setup() 
{
  size(50, 50);
  loadFiles();
  program = new MachineLearning(.75);
  //extractConnectedComponents(3, 5);
  for (int i = 0; i < 30; i++) {
    println("");
    println(i);
    println("");
    program.run();
    //delay(300);
  }
  println("");
  program.reportConfusion();
  exit();
  time.reset();
}

void draw()
{
  //background(255);
  image(dataSample[count], 0, 0);
  if (time.done()) {
    count++;
    count %= dataSample.length;
    //println(count);
    time.reset();
  }
}