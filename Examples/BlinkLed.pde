import Pinguino.*;

Pinguino pinguino = new Pinguino(this);

void setup(){ 
 Pinguino.log(true);
} 
void draw(){ 
 pinguino.digitalWrite(0,pinguino.HIGH);
 delay(200);
 pinguino.digitalWrite(0,pinguino.LOW);
 delay(200);
}