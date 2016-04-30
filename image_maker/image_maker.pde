String path = sketchPath() + "/data";

void setup()
{
   size(50,50);
   background(255);
 
   fill(0);
   textSize(40);
   textAlign(CENTER, CENTER);
   
   StringList fontNames = new StringList(PFont.list());
   fontNames.shuffle();
   
   for(int i = 0; i < 60; i++)
   {
     for (int j = 0; j < 10; j++) 
     {
     int num = j;
     textFont(createFont(fontNames.get(i), 32));
     text(str(num), width/2, height/2.5);
     loadPixels();
     save(str(num) + " " + str((int)random(0, 100000)) + ".png");
     clear();
     background(255);
     }
   }
   exit();
}

void draw()
{
  
}