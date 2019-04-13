import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
int sensorValue;
void setup() {
  size(900,900);
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
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
          println(sensorValue);
          
          float mapValue = float(sensorValue);
          mapValue = map(sensorValue, 513, 1023, 0, 1);
          
          ellipse(width/2, height/2, mapValue *100, mapValue *100);
          fill(0);
          
    }
  }
}
}
