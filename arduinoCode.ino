#include <Servo.h>
#define MAX_MILLIS_TO_WAIT 5000  //or whatever
unsigned long starttime;

Servo s3;
Servo s2;
Servo s1;

int theta = 0;
int alpha = 70;
int beta = 0;
int len = 60;
int ch[60];

void setup() {
  s3.attach(8);
  s2.attach(7);
  s1.attach(6);
  Serial.begin(9600);
  s1.write(theta);
  s2.write(alpha);
  s3.write(beta);
}
 
void loop() {
  starttime = millis();
  if (theta<179) s1.write(theta);
  theta += 1;
  alpha = 70;

  s1.write(theta);
  s3.write(0);
  
  while ( (Serial.available()<len) && ((millis() - starttime) < MAX_MILLIS_TO_WAIT) ) {      
     // hang in this loop until we either get 50 bytes of data or 5 second has gone by
  }
  if(Serial.available() < len) {
     // the data didn't come in - so wait for next iteration
  }
  else {
    for(int i=0;i<len;i++) {
      ch[i] = Serial.read();
    }
    for(int i=0;i<len;i++) {
      s2.write(i+70);
      s3.write(15*ch[i]);
      delay(50);
    } 
    s3.write(0);
    for(int i=len;i>0;i--) {
      s2.write(i+70);
      delay(25);
    }
    //Serial.write(1);
  }
}

