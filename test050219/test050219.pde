import processing.serial.*;

int rU = 59; //59 is ";" in ASCII
String myString = null;
Serial myPort;  
int sensorValue;  
int maxvol_1;
int maxvol_2;
//int b = 512; //lowest reading of piezo, can change to 512
//int scl = 500; //scalar


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
          
        printArray(mysensors);
        
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
      //println(num);
      for(int i=0; i<num; ++i) {
        s.wave1.add(Integer.parseInt(mysensors[ri])/1023.0f);
        ++ri;
        s.wave2.add(Integer.parseInt(mysensors[ri])/1023.0f);
        ++ri;
      }
    }
    println(s); // check how many values are in the wave1 and wave2 arrayLists       
    samples.add(s);
    
    if (samples.size()>800) samples.remove(0);
   
    return true;
}

void draw() {
  background(255);
  
  while(readNextValues()) {
  }
   
   if (samples.size()==0) return;
   
   float scale=width*0.4;
   
   int num=Math.min(samples.size(), 20);
   
   stroke(0, 0, 0, 10);
   
   for(int i=1; i<num; ++i) {
     Sample s=samples.get(samples.size()-i);
     
      //fill(0,0,0, 2);
      //ellipse(width*0.2, height*0.5, s.v1*scale, s.v1*scale);
      
      //ellipse(width*0.8, height*0.5, s.v2*scale, s.v2*scale);

     int num2=((s.wave1.length + s.wave2.length)-2)/2;
     for(i = 0; i < num2; i++){
      //left column
      float b1 = map(s.wave1[i], 0, 1, 0, 255);
      fill(0,0,0, b1);
      line(0, (height/num2)*i, width/2, (height/num2)*(i+1));
      
      // right column
      float b2 = map(s.wave2[i], 0, 1, 0, 255);
      fill(0,0,0, b2);
      line(width/2, (height/num2)*i, width, (height/num2)*(i+1));
     }
      
      float dif=s.v2-s.v1;
      float amp = (s.v1+s.v2)*0.5f;
      float difn = dif/amp;
      
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
  endShape();
}
