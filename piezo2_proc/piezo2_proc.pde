import processing.serial.*;
section[] sections;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
int sensorValue;
int maxvol_1;
int maxvol_2;


void setup() {
  
  size(1080, 720);
  
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf); //10 corresponds with 10 bits?
  myString = null;
}

void draw() {
  background(255);
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      myString = myString.trim();
        if (myString != null){
          try{
          sensorValue = Integer.parseInt(myString);
          }catch (Exception e){
            continue;
          }
          
          if (sensorValue = 0) {continue;}
            else {return;}
            if (sensorValue = 1) {continue;}
            else {return;}
            if (sensorValue = 2) {continue;}
            else {return;}
          
           maxvol_1 = sensorValue;
          
          if (sensorValue = 3) {continue;}
            else {return;}
          if (sensorValue = 4) {continue;}
            else {return;}
           if (sensorValue = 5) {continue;}
            else {return;}
          
           maxvol_2 = sensorValue ;
           
         
           
          print("max1 ");
          println(maxvol_1);
          print("max1 ");
          println(maxvol_2);
          
          float mapValue = float(sensorValue);
          mapValue = map(sensorValue, 0, 1023, 0, 1);
          
          ellipse(width/2, height/2, mapValue * 10000, mapValue * 10000);
          fill(0);
          
        }
      }
    }
