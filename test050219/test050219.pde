import processing.serial.*;

int rU = 59; //59 is ";" in ASCII
String myString = null;
Serial myPort;  
int sensorValue;  
int maxvol_1;
int maxvol_2;
//int b = 512; //lowest reading of piezo, can change to 512
//int scl = 500; //scalar
float baseline=0.0f;

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
  background(255,255,255);
  size(1000, 700);
  
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[3], 9600);
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
  //println(myString);
  
  myString = myString.trim();
  // split the string at the tabs then convert the sections into integers:
  String mysensors[] = splitTokens(myString, " , ; ");
  if (mysensors==null || mysensors.length<2) return false;
  
  if (mysensors[0] == null || mysensors[1] == null) return false;
          
        //printArray(mysensors);
        
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
      //print("num: ");
      //println(num);
      for(int i=0; i<num; ++i) {
        float w1=Integer.parseInt(mysensors[ri])/1023.0f;
        s.wave1.add(w1);
        ++ri;
        float w2=Integer.parseInt(mysensors[ri])/1023.0f;
        s.wave2.add(w2);
        ++ri;
        
        baseline=baseline*0.95f+(w1+w2)*0.5f*0.05f;
      }
    }
    //print("wave 1: ");
    //printArray(s.wave1);
    samples.add(s);
    
    if (samples.size()>800) samples.remove(0);
    
    //println(baseline);
   
    return true;
}

void draw() {
  background(0,0,0,255);
  
  while(readNextValues()) {
  }
   
   if (samples.size()==0) return;
   
   float scale=width*0.4;
   
   int num=Math.min(samples.size(), 20);
   
   stroke(0, 0, 0, 10);
   
   
   /*Sample s0=samples.get(samples.size()-1);
   float dy=height/(float)s0.wave1.size();
   for(int i=0; i<s0.wave1.size(); ++i) {
      float reading1 = s0.wave1.get(i);
      float b1 = (reading1-baseline)*5800.0f;
      fill(255);
      rect(0, i*dy, width/2, dy*(reading1-baseline));
      
      // right column
      float reading2 = s0.wave2.get(i);
      float b2 = (reading2-baseline)*5800.0f;
      fill(255);
      rect(width/2, i*dy, width/2, dy*(reading2-baseline));
   }*/
   
   //Sample s0=samples.get(samples.size()-1);
   //float dx=0.5f*width/(float)s0.wave1.size();
   //float dy=height;
   //for(int i=0; i<s0.wave1.size(); ++i) {
   //   float reading1 = s0.wave1.get(i);
   //   float b1 = (reading1-baseline)*5800.0f;
   //   fill(255);
   //   rect(i*dx, 0, dx, dy*(reading1-baseline));
      
   //   // right column
   //   float reading2 = s0.wave2.get(i);
   //   float b2 = (reading2-baseline)*5800.0f;
   //   fill(255);
   //   rect(width/2+i*dx, 0, dx, dy*(reading2-baseline));
   //}
   
   
   //  Sample s0=samples.get(samples.size()-1);
   //float dx=0.5f*width/(float)s0.wave1.size();
   //float dy=height;
   //for(int i=0; i<s0.wave1.size(); ++i) {
   //   float reading1 = s0.wave1.get(i);
   //   float b1 = (reading1-baseline)*5800.0f;
   //   fill(255);
   //   rect(i*dx, 0, dx*(reading1-baseline), dy);
      
   //   // right column
   //   float reading2 = s0.wave2.get(i);
   //   float b2 = (reading2-baseline)*5800.0f;
   //   fill(255);
   //   rect(width/2+i*dx, 0, dx*(reading2-baseline), dy);
   //}
   
   /*
   for(int i=1; i<num; ++i) {
     Sample s=samples.get(samples.size()-i);
      
     int num2 = s.wave1.size();
     float step = height / num2;
     //print("num2: ");
     //println(num2);
     
     for(int j = 0; j < num2; j++){
      //left column
      float reading1 = s.wave1.get(j);
      float b1 = map(reading1, 0, 1, 0, 255);
      fill(b1);
      rect(0, 0+j*step, width/2, step);
      
      // right column
      float reading2 = s.wave2.get(j);
      float b2 = map(reading2, 0, 1, 0, 255);
      fill(b2);
      rect(width/2, 0+j*step, width/2, step);
     }
     
     //fill(0,0,0, 2);
     //ellipse(width*0.2, height*0.5, s.v1*scale, s.v1*scale);
      
     //ellipse(width*0.8, height*0.5, s.v2*scale, s.v2*scale);
      
     //float dif=s.v2-s.v1;
     //float amp = (s.v1+s.v2)*0.5f;
     //float difn = dif/amp;
      
     //fill(255,0,203, 2);
     //ellipse(width*0.5 + difn*1000.0, height*0.5, amp*scale, amp*scale);
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
  endShape();*/
}
