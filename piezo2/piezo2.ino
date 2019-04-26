#include <SoftwareSerial.h> //include when using AVR microcontrollers


#define piezo1 A7 //connected to red wire of piezo1 (upper)
#define piezo2 A3 //connected to red wire of piezo2 (lower)
const byte rxPin = 0; //the pin on which to receive serial data. Changed from int to byte
const byte txPin = 1; //the pin on which to transmit serial data.

//set up new serial object
SoftwareSerial Serial(rxPin, txPin);


const int RECLENGTH = 100;
int audio[RECLENGTH];

void setup() 
{
  //define pin modes for tx, rx
  pinMode(rxPin, INPUT);
  pinMode (txPin, OUTPUT);

  //set data rate
  Serial.begin(9600);

  //clear memory of array
  for(int i=0; i<RECLENGTH; ++i) {
    audio[i]=0;
  }
}
                                           
void loop()
{

  int value;
  int magnitude;

  int maxvol_1 = 0;
  int maxvol_2 = 0;
  
    for (int i=0; i<RECLENGTH; ++i) {
      value = analogRead(piezo1);
      audio[i]=value;
      if (value > maxvol_1) maxvol_1 = value;
    }   
    
    for (int j=0; j<RECLENGTH; ++j) {
      value = analogRead(piezo2);
      audio[j]=value;
      if (value > maxvol_2) maxvol_2 = value;
      }

  Serial.print(maxvol_1);
  Serial.print(',');
  Serial.print(maxvol_2);
  Serial.print(';');
  
}
