import Pinguino.*;  //Importa libreria Pinguino Processing 

Pinguino pinguino = new Pinguino(this);  // Se crea un objeto que extiende a la clase Pinguino
float readAnalog,celcius,kelvin;    // Se de declara la variable readAnalog para la lectura analoga del pin 13 de Pinguino, 
 

int tempcontrol=25, value;         // Se declara la variable tempcontrol para el control de temperatura 
void setup(){                      // funcion de configuracion de processing
  size(680,340);                   // Tamaño de la ventana del programa
  background(88,146,170);          // color de fondo azul para la ventana principal
  //pinguino.clear();                // se colocal todos los pines de pinguino en estado bajo
}

void draw(){                       // Funcion de dibujo principal de processing
   background(88,146,170);         // color de fondo azul para la ventana principal, se vuelve a colocar para
   
  readAnalog=pinguino.analogRead(13);           // se almacena en aDC el valor analogo que entrega la lectura en el pin 13 de pinguino 
  kelvin=readAnalog*0.004882812*100;                     // Funcion matematica para calcular los grados Kelvin a partir de la lectura analoga que entrega el sensor LM335
  celcius=kelvin-273.15;    // Se calculan Grados Celcius a partir de los Grados Kelvin 
  delay(150);                //delay para hacer un retardo luego de la lectura del sensor
  println("Celcius "+celcius); //imprime por consola los grados celcius
  value=parseInt(celcius); 
  println("Value "+value);
  
 if(value > tempcontrol){
   pinguino.digitalWrite(0,pinguino.HIGH);
 }else{
   pinguino.digitalWrite(0,pinguino.LOW);
 }
  fill(255);
  textSize(24);
  text("Bienvenidos al sistema de control de Calefacción",12,30);
  textSize(100);
  text(celcius,230,280);
  text("°C",380,160);
  
  textSize(70);
  fill(255);
  text(tempcontrol,110,185);
  interfas();
}

void mousePressed(){                              // Funcion de Processing para usar el evento de mouse cuando se es presionado un boton

    if(mousePressed && mouseX>20 && mouseX < 90 && mouseY > 100 && mouseY < 170 ){  // Condicional if que evalue y triangula la posicion del puntero y capturar el evento del raton
        tempcontrol++;                                                         // Se incrementa en uno el valor de la variable controlInicial para ser seteado por el usuario
      }
    if(mousePressed && mouseX>20 && mouseX < 90 && mouseY > 180 && mouseY < 240 ){  // Condicional if que evalua y triangula la posicion del puntero y capturar el evento del mouse 
        tempcontrol--;                                                         // Se decrementa en uno el valor de la variable controlInicial 
      }    
       redraw();                                                                  // Funcion para redibujar la interfaz grafica y notar los cambios en los valores seteados
    }
void interfas(){
  stroke(200);
  line(225,50,225,320);
  textSize(20);
  text("Control",30,80);
  
  fill(217,209,209);
  rect(20,100,70,60);
  rect(20,180,70,60);
  fill(63,60,60);
  text("Subir",28,135);
  text("Bajar",28,215);
  
}