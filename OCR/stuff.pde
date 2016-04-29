void intArrayToScreen(int[][][] data)
{       
  for(int i = 0; i < data[0][0].length; i++)
    if(data[0][0][i] ==  1)
        data[0][0][i] = -16777216;
    else if(data[0][0][i] == 0)
        data[0][0][i] = -1;
  
  loadPixels();
  for(int i = 0; i < data[0][0].length; i++)
    pixels[i] = data[0][0][i];
  updatePixels(); 
}

void intArrayToScreen(int [] data)
{
  loadPixels();
  for(int i = 0; i < data.length; i++)
    pixels[i] = data[i];
  updatePixels(); 
}