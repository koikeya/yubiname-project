#include <Adafruit_NeoPixel.h>
#include <avr/power.h>
#define PIN            5
#define NUMPIXELS      1
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

unsigned char val0 = 0;
unsigned char val1 = 0;

int vals[2];
int inByte;

void setup() {
  pinMode(A6, INPUT);
  pinMode(A7, INPUT);
  
  pixels.begin();
  
  Serial.begin(9600);
  
  vals[0] = 0;
  vals[1] = 0;
  inByte = 0;
  
  establishContact();
}

void loop() {  
  vals[0] = analogRead(A6);
  vals[1] = analogRead(A7);
    
  if (Serial.available() > 0) {
    inByte = Serial.read();
    
    Serial.print(vals[0]);
    Serial.print(",");
    Serial.println(vals[1]);
  }
  
  pixels.setPixelColor(0, pixels.Color(
    map(vals[0], 0, 1024, 0, 255),
    map(vals[1], 0, 1024, 0, 255),0));
  pixels.show();
  
  delay(10);
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("0,0");
    delay(100);
  }
  pixels.setPixelColor(0, pixels.Color(0,0,255));
  pixels.show();
  
  delay(500);
}
