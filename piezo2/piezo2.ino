#include <SoftwareSerial.h> //include when using AVR microcontrollers

#define piezo_1 A7 //connected to red wire of piezo1 (upper)
#define piezo_2 A3 //connected to red wire of piezo2 (lower)
const byte rxPin = 0; //the pin on which to receive serial data. Changed from int to byte
const byte txPin = 1; //the pin on which to transmit serial data.

//set up new serial object
SoftwareSerial Serial(rxPin, txPin);

//#define RECLENGTH  64
 short audio_1;
 short audio_2;

void setup()
{
  //define pin modes for tx, rx
  pinMode(rxPin, INPUT);
  pinMode (txPin, OUTPUT);

  //set data rate
  Serial.begin(19200);
}

#define OUTPUTREC


void loop()
{
  audio_1 = analogRead(piezo_1);
  Serial.print(audio_1);
  Serial.print(',');
  audio_2 = analogRead(piezo_2);
  Serial.print(audio_2);
  Serial.print(';');
  delay(20); 
}
