import Pinguino.*;
Pinguino pinguino = new Pinguino(this);

void setup(){ 
  Pinguino.log(true);
  rect(25, 25, 50, 50);
} 
void draw(){ 

  
  if (mousePressed == true) {
     pinguino.digitalWrite(0,pinguino.HIGH); 
     fill(0);
  } 
  else {
    pinguino.digitalWrite(0,pinguino.LOW);
    fill(255);
  }
  
  
  rect(25, 25, 50, 50);
}
