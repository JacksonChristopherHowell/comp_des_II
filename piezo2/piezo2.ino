#include <SoftwareSerial.h> //include when using AVR microcontrollers


#define piezo_1 A7 //connected to red wire of piezo1 (upper)
#define piezo_2 A3 //connected to red wire of piezo2 (lower)
const byte rxPin = 0; //the pin on which to receive serial data. Changed from int to byte
const byte txPin = 1; //the pin on which to transmit serial data.

//set up new serial object
SoftwareSerial Serial(rxPin, txPin);


#define RECLENGTH  24
 short audio_1[RECLENGTH];
 short audio_2[RECLENGTH];

void setup()
{
  //define pin modes for tx, rx
  pinMode(rxPin, INPUT);
  pinMode (txPin, OUTPUT);

  //set data rate
  Serial.begin(9600);

  //clear memory of array
  for(int i=0; i<RECLENGTH; ++i) {
    audio_1[i]=0;
  }
  
  for(int j=0; j<RECLENGTH; ++j) {
    audio_2[j]=0;
  }
}

//#define OUTPUTREC


void loop()
{

  //int value_1;
  //int value_2;

   short maxvol_1 = 0;
   short maxvol_2 = 0;
  //int n = 0;
  //int m = 0;
  
    for (int i=0; i < RECLENGTH; ++i) {
      audio_1[i] = analogRead(piezo_1);
      audio_2[i] = analogRead(piezo_2);

        if (audio_1[i] > maxvol_1) maxvol_1 = audio_1[i];
        if (audio_2[i] > maxvol_2) maxvol_2 = audio_2[i];
      
/*      if (i%2 == 0) {
        value_1 = analogRead(piezo_1);
        int q = i - (i - n); 
        //        2-2=0 i-(i-0) the final column in pattern becomes n
        //        4-3=1 i-(i-1)
        //        6-4=2 i-(i-2)
        audio_1[q]=value_1;
        if (value_1 > maxvol_1) maxvol_1 = value_1;
        n++;
      }
      else if (i%2 == 1) {
        value_2 = analogRead(piezo_2);
        int r = i - (i - m);
        //        1-1=0 i-(i-0) the final column in pattern becomes m
        //        3-2=1 i-(i-1)
        //        5-3=2 i-(i-2)
        audio_2[r]  = value_2;
        if (value_2 > maxvol_2) maxvol_2 = value_2;
      }*/
    }   

   

  Serial.print(maxvol_1);
  Serial.print(',');
  Serial.print(maxvol_2);

#ifdef OUTPUTREC
  
    for(int i=0; i<RECLENGTH; ++i) {
      Serial.print(',');
      Serial.print(audio_1[i]);
      Serial.print(',');
      Serial.print(audio_2[i]);
    }

#endif

  
  Serial.print(';');

//  value_1 = analogRead(piezo_1);
//  value_2 = analogRead(piezo_2);
//  Serial.print(value_1);
//  Serial.print(',');
//  Serial.print(value_2);
//  Serial.print(';');
  
}
