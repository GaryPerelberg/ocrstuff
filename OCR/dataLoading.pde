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
}

void cleanUp() {
  // Convert color integers into 0s and 1s where 0 = white and 1 = black
  for (int i = 0; i < data.length; i++)
   for (int j = 0; j < data[i].length; j++)
     for (int k = 0; k < data[i][j].length; k++)
       if (data[i][j][k] == -1)
         data[i][j][k] = 0;
       else
         data[i][j][k] = 1;
  
  //// Want to try something different
  //for (int i = 0; i < data.length; i++) {
  //  for (int j = 0; j < data[i].length; j++) {
        // This actually works really well
  //    erode(data[i][j]);
  //    dilate(data[i][j]);
  //  }
  //}
  
  convertingIntArraytoImages();
}