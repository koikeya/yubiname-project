import processing.serial.*;
import processing.net.*;

import oscP5.*;
import netP5.*;

Serial myPort;

OscP5 oscP5;
NetAddress myRemoteLocation;

color fillColor;
int[] vals = {0, 0};
int[] prevVals = {0, 0};
int threshould = 100;

void setup() {
  size(180, 180);
  
  oscP5 = new OscP5(this, 1234);
  myRemoteLocation = new NetAddress("127.0.0.1", 5555);
  
  println(Serial.list());
  
  myPort = new Serial(this, "/dev/tty.usbmodem1411", 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(24);
  fill(0);
  ellipse(width / 2, height / 2, 150, 150);
  
  fill(fillColor);
  ellipse(width / 2, height / 2, 100, 100);
}

void serialEvent(Serial p) {
  String myString = p.readStringUntil('\n');
  
  myString = trim(myString);
  
  int[] rawVals = int(split(myString, ','));
  
  if (rawVals.length > 1) {
    fillColor = color(rawVals[0], rawVals[1], 0);
    
    if (rawVals[0] < threshould) { vals[0] = 0; }
    else { vals[0] = 1; }
    if (rawVals[1] < threshould) { vals[1] = 0; }
    else{ vals[1] = 1; }
    
    if (prevVals[0] != vals[0] || prevVals[1] != vals[1]) {
      OscMessage myMessage = new OscMessage("/finger");
      myMessage.add(vals[0]);
      myMessage.add(vals[1]);
      oscP5.send(myMessage, myRemoteLocation);
      prevVals[0] = vals[0];
      prevVals[1] = vals[1];
    }
  }
  
  myPort.write('A');
}
