import processing.serial.*;

//int lf = 10;    // Linefeed in ASCII
int rU = 59; 
String myString = null;
Serial myPort;  // The serial port
int sensorValue;
int maxvol_1;
int maxvol_2;


void setup() {
  background(255,255,255);
  size(1600, 1000);
  
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(rU); //10 corresponds with 10 bits?
  myString = null;
}

void draw() {
  background(255);
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(rU);
    if (myString != null) {
      myString = myString.trim();
      // split the string at the tabs and convert the sections into integers:
      String mysensors[] = splitTokens(myString, " , ; ");
        if (mysensors[0] != null && mysensors[1] != null){
          printArray(mysensors);
          
          try{
          maxvol_1 = Integer.parseInt(mysensors[0]);
          maxvol_2 = Integer.parseInt(mysensors[1]);
          }catch (Exception e){
            continue;
          }
          
          float mapValue1 = map( (float) maxvol_1, 513, 1023, 0, 1);
          fill(0);
          ellipse(width*0.10, height*0.5, mapValue1 * 1000, mapValue1 * 1000);

          float mapValue2 = map( (float) maxvol_2, 513, 1023, 0, 1);
          fill(0);
          ellipse(width*0.90, height*0.5, mapValue2 * 1000, mapValue2 * 1000);
          
          int plotMax;
          if(maxvol_1 > maxvol_2){
            plotMax = maxvol_1;
          } else {
            plotMax = maxvol_2;
          }
          float mplotMax = map( (float) plotMax, 513, 1023, 0, 1);
          
          float diff = maxvol_1 - maxvol_2;
          float mapDiff = map(diff, 511, -511, width*0.1, width*0.9);
          
          fill(255,192,203);
          ellipse( (width*0.1 + mapDiff), height*0.5, mplotMax * 1000, mplotMax * 1000);
          
          
          //int dis1 = (width*0.10) - (width*0.90
          
          //int plotMax;
          //if(maxvol_1 > maxvol_2){
          //  plotMax = maxvol_1;
          //} else {
          //  plotMax = maxvol_2;
          //}
           //float mapPlotMax = map(plotMax, 513, 1023, 0, 1);
          
          //float diff = maxvol_1 - maxvol_2;
          //float mapDiff = map(diff, 513, 1023, width * 0.1, width * 0.9);
          //float mapDiff = map(diff, 513, 1023, width * 0.1, width * 0.9);
          
          //ellipse((width*0.5 + mapDiff), height*0.5, mapPlotMax * 1000, mapPlotMax * 1000);
          //fill(255,192,203);
          
          //float dif = ((mapValue2-mapValue1)*width*0.5);
          //ellipse(dif, height*0.5, 20, 20);
          //fill(255,192,203);
        }
      }
    }
  }
