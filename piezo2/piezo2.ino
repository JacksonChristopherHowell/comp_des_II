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

  //clear memory of array
//  for(int i=0; i<RECLENGTH; ++i) {
//    audio_1[i]=0;
//  }
//  
//  for(int j=0; j<RECLENGTH; ++j) {
//    audio_2[j]=0;
//  }
}

#define OUTPUTREC


void loop()
{
   //short maxvol_1 = 0;
   //short maxvol_2 = 0;
  
    //for (int i=0; i < RECLENGTH; ++i) {
      audio_1 = analogRead(piezo_1);
      Serial.print(audio_1);
      Serial.print(',');
      audio_2 = analogRead(piezo_2);
      Serial.print(audio_2);
      Serial.print(';');
      delay(20);

        //if (audio_1[i] > maxvol_1) maxvol_1 = audio_1[i];
        //if (audio_2[i] > maxvol_2) maxvol_2 = audio_2[i];
   // }   

   

  //Serial.print(maxvol_1);
  //Serial.print(',');
  //Serial.print(maxvol_2);

//#ifdef OUTPUTREC
//  
//    for(int i=0; i<RECLENGTH; ++i) {
//      Serial.print(',');
//      Serial.print(audio_1[i]);
//      Serial.print(',');
//      Serial.print(audio_2[i]);
//    }
//
//#endif
  
  //delay(200);
}
