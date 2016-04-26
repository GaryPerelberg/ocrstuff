String path = "/Users/GaryPerelberg/Documents/Processing";

void setup()
{
   size(50,50);
   background(255);
 
   fill(0);
   textSize(40);
   textAlign(CENTER, CENTER);
   
   StringList fontNames = new StringList(PFont.list());
   fontNames.shuffle();
   
   for(int i = 0; i < 40; i++)
   {
     int num = i % 10;
     textFont(createFont(fontNames.get(i), 32));
     text(str(num), width/2, height/2.5);
     loadPixels();
     save(str(num) + " " + str((int)random(0, 100000)) + ".png");
     clear();
     background(255);
   }
}

void draw()
{
  
}