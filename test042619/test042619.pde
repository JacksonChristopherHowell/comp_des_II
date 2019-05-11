import processing.serial.*;

int numLines = 15;

//int lf = 10;    // Linefeed
int rU = 59; //59 is ";" in ASCII
String myString = null;
Serial myPort;  
int sensorValue;  
int maxvol_1;
int maxvol_2;
int b = 512; //lowest reading of piezo, can change to 512
int scl = 500; //scalar


class Sample{
  public Sample(float v1_, float v2_) {
    v1=v1_;
    v2=v2_;
  }
  
  public ArrayList<Float> wave1;
  public ArrayList<Float> wave2;
  public float v1;
  public float v2;
}

ArrayList<Sample> samples = new ArrayList<Sample>();

void setup() {
  //background(255,255,255);
  //size(1000, 700);
  
  fullScreen();
  background(0);
  stroke(255);
  fill(255); 
  
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(rU); //read until ";"
  myString = null;
}

Boolean readNextValues() {
  if (myPort.available() ==0) return false;
  
  myString = myPort.readStringUntil(rU);
  if (myString == null) return false;
  
  myString = myString.trim();
  // split the string at the tabs then convert the sections into integers:
  String mysensors[] = splitTokens(myString, " , ; ");
  if (mysensors==null || mysensors.length<2) return false;
  
  if (mysensors[0] == null || mysensors[1] == null) return false;
          
       
       // printArray(mysensors);
        
        try{
          maxvol_1 = Integer.parseInt(mysensors[0]);
          maxvol_2 = Integer.parseInt(mysensors[1]);
        }catch (Exception e){
          return false;
        }
        
        float v1 = maxvol_1/1023.0f;
        float v2 = maxvol_2/1023.0f;
    
    Sample s=new Sample(v1, v2);
    if (mysensors.length>2) {
      s.wave1=new ArrayList<Float>();
      s.wave2=new ArrayList<Float>();
      
      int num=(mysensors.length-2)/2;
      int ri=2;
      println(num);
      for(int i=0; i<num; ++i) {
        s.wave1.add(Integer.parseInt(mysensors[ri])/1023.0f);
        ++ri;
        s.wave2.add(Integer.parseInt(mysensors[ri])/1023.0f);
        ++ri;
      }
    }
    
        
    
    samples.add(s);
     

    
    if (samples.size()>800) samples.remove(0);
   
    return true;
}

void draw() {
  //background(255);
  background(0);
  strokeCap(PROJECT);
  
  while(readNextValues()) {
  }
   
   if (samples.size()==0) return;
   
   float scale=width*0.4;
   
   int num=Math.min(samples.size(), 20);
   
   //stroke(0, 0, 0, 10);
   
   for(int i=1; i<num; ++i) {
     Sample s=samples.get(samples.size()-i);
     
      //fill(0,0,0, 2);
      //ellipse(width*0.2, height*0.5, s.v1*scale, s.v1*scale);
      
      //ellipse(width*0.8, height*0.5, s.v2*scale, s.v2*scale);
      
      float dif=s.v2-s.v1;
      float amp = (s.v1+s.v2)*0.5f;
      float difn = dif/amp;
      
      //fill(255,0,203, 2);
      //ellipse(width*0.5 + difn*1000.0, height*0.5, amp*scale, amp*scale);
      
      for(int j = 0; j < numLines; j++) {
        float x = (j+1) * ((float) width/(numLines+1));
        float distFromCenter = dist(x, 0, width/2, 0);
        float waveOffset = map(distFromCenter, 0, width/2, 0, 100);
        float wave = 20 * sin((PI / 2)* sin((-frameCount + waveOffset) / 40.0)) + difn*100.0;
        stroke(255);
        strokeWeight(abs(wave));
        line(x, -500, x, height+400);
      }
   }



  float xscale=width/(float)samples.size();

  noFill();
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
  endShape();
 
    
/*  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(rU);
    if (myString != null) {
      myString = myString.trim();
      // split the string at the tabs then convert the sections into integers:
      String mysensors[] = splitTokens(myString, " , ; ");
        if (mysensors[0] != null && mysensors[1] != null){ // [0] is for maxvol_1 and [1] is for maxvol_2
          printArray(mysensors);
          
          try{
          maxvol_1 = Integer.parseInt(mysensors[0]);
          maxvol_2 = Integer.parseInt(mysensors[1]);
          }catch (Exception e){
            continue;
          }
          
          //created variable b since values are now showing in 400's
          //created variable sc so  can adjust scale easily
          float mapValue1 = map( (float) maxvol_1, b, 1023, 0, 1);
          fill(0, 100);
          ellipse(width*0.10, height*0.5, mapValue1 * scl, mapValue1 * scl);

          float mapValue2 = map( (float) maxvol_2, b, 1023, 0, 1);
          fill(0, 100);
          ellipse(width*0.90, height*0.5, mapValue2 * scl, mapValue2 * scl);
          
          int plotMax;
          if(maxvol_1 > maxvol_2){
            plotMax = maxvol_1;
          } else {
            plotMax = maxvol_2;
          }
          float mplotMax = map( (float) plotMax, b, 1023, 0, 1);
          
          //float diff = maxvol_1 - maxvol_2;
          //float mapDiff = map(diff, (b-1023), (1023-b), -(width*0.4), width*0.4);
          
          //fill(255,192,203);
          //ellipse(width*0.5 + mapDiff , height*0.5, mplotMax * scl, mplotMax * scl);
          
          //Lins attempt:
          
          PVector pV1 = new PVector(width*0.10, height*0.5);
          PVector pV2 = new PVector(width*0.90, height*0.5);
          PVector pV3 = PVector.sub(pV1, pV2);
          float screenDif = pV3.mag();
          float maxvolDif = 1023-b; 
          float volDif = (float)maxvol_1 - (float)maxvol_2;
          float interval = screenDif/maxvolDif;
          PVector pVcenter = new PVector(pV1.x + screenDif/2, height*0.5);
          fill(255,192,203, 100);
          ellipse(pVcenter.x + volDif * interval, height*0.5, mplotMax * scl, mplotMax * scl);
          
        }
      }
    }*/
  }
