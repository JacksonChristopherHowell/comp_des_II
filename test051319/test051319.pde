import processing.serial.*;

int rU = 59; //59 is ";" in ASCII
String myString = null;
Serial myPort;  
int sensorValue;  
int maxvol_1;
int maxvol_2;
float baseline=0.0f;

ArrayList<Float> wave1 = new ArrayList<Float>();
ArrayList<Float> wave2 = new ArrayList<Float>();

void setup() {
  background(255, 255, 255);
  size(1000, 700);
  //fullScreen();

  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[3], 19200);
  myPort.clear();
  // Throw out the first reading, in case we started reading
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(rU); //read until ";"
  myString = null;
}

void draw() {
  background(0, 0, 0, 255);

  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(rU);
    if (myString != null) {
      myString = myString.trim();
      //println(myString);

      // split the string at the tabs then convert the sections into integers:
      String mysensors[];
      mysensors = splitTokens(myString, " , ; ");
      println(mysensors[0]);
      println(mysensors[1]);
      println("");
      if (mysensors.length>1) {
        //println("made it here");
        try {
          maxvol_1 = Integer.parseInt(mysensors[0]);
          maxvol_2 = Integer.parseInt(mysensors[1]);
        }
        catch (Exception e) {
          continue;
        }
        
        float v1 = maxvol_1/1023.0f;
        float v2 = maxvol_2/1023.0f;

        wave1.add(v1);
        wave2.add(v2);
        baseline=baseline*0.95f+(v1+v2)*0.5f*0.05f;

        if (wave1.size()>64) wave1.remove(0);
        if (wave2.size()>64) wave2.remove(0);
      }
    }
  }
  
  stroke(0, 0, 0, 10);


  int waveSize = 1; 
  if (wave1 != null) {
    waveSize = wave1.size();
  }
  float dx=0.5f*width/(float)waveSize;
  float dy=height;
  
  //println(waveSize);

  for (int i=0; i< waveSize-1; ++i) {
    float reading1 = wave1.get(i);
    fill(255);
    rect(i*dx, 0, dx*(reading1-baseline), dy);

    // right column
    float reading2 = wave2.get(i);
    fill(255);
    rect(width/2+i*dx, 0, dx*(reading2-baseline), dy);
  }
  
   /*noFill();
   stroke(204, 0, 0, 100);
   beginShape();
   
   for(int i=0; i<samples.size(); ++i) {
   vertex(i*xscale, height*0.5+samples.get(i).v1*200.0);
   }
   endShape();
   
   stroke(20, 0, 205, 100);
   beginShape();
   
   for(int i=0; i<samples.size(); ++i) {
   vertex(i*xscale, height*0.5-samples.get(i).v2*200.0);
   }
   endShape();*/
}
