/*-----------------------------------------------------
Author:  Yohon Bravo Castro
Email: bravo2008@misena.edu.co
Date: 2016-06-26
Description: Codigo para Pinguino Processing, la cual esta basada en la libreria creada por Jean-Pierre MANDON 2009.

Esta libreria es compatible con la version 1.3 de Processing y la version 4.14 del bootloader de Pinguino 2550.

https://github.com/PinguinoIDE/PinguinoProcessing

Version: 1.0

-----------------------------------------------------*/


u8 receivedbyte;
char buffer[64];
char data[8];
int i=0,temp;


void setup() {

for( i=0; i<8; i++ ){
	pinMode( i, OUTPUT );
}
 clear();
}
void readBulk(){
 receivedbyte = BULK.read(buffer); 
 buffer[receivedbyte] = 0;
}
void loop() {
receivedbyte=0;
 if ( BULK.available()) {
    readBulk();
    if (receivedbyte > 0){ 
		if(buffer[1]=='C') clear();
		if(buffer[0]=='W'){
			if(buffer[1]=='D'){ 
    	   		digitalWrite(buffer[2],buffer[3]);
			}
			if(buffer[1]=='A'){
			temp = (((((buffer[3] * 10) + buffer[4]) * 10) + buffer[5]) * 10) + buffer[4];
			analogWrite(buffer[2],temp);
			}
		}
		if(buffer[0]=='R'){
			if(buffer[1]=='D'){ 
			   pinMode(buffer[2],INPUT);
    	   		   data[0]=digitalRead(buffer[2]);
			   BULK.write(data,1);
			}
			if(buffer[1]=='A'){
			   temp=analogRead(buffer[2]);
			   data[0]=temp/1000;
			   data[1]=(temp%1000)/100;
			   data[2]=(temp%100)/10;
			   data[3]=(temp%10);
			   BULK.write(data,4);
				}
			}
    		}
	}
}
void clear() {
 for( i=0; i<8; i++ ) {
  digitalWrite( i, LOW );
 }
}

