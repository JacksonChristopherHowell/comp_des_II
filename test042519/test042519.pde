import processing.serial.*;

//int lf = 10;    // Linefeed in ASCII
int rU = 59; 
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
          ellipse(width*0.25, height*0.25, mapValue1 * 1000, mapValue1 * 1000);
          fill(0);

          float mapValue2 = map( (float) maxvol_2, 513, 1023, 0, 1);
          ellipse(width*0.75, height*0.75, mapValue2 * 1000, mapValue2 * 1000);
          fill(0);
        }
      }
    }
  }
