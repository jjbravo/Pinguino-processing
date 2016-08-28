import Pinguino.*;  //Importa libreria Pinguino Processing 

Pinguino pinguino = new Pinguino(this);  // Se crea un objeto que extiende a la clase Pinguino
float aDC,celcius,kelvin;                         // Se de declara la variable aDC para la lectura analoga del pin 13 de Pinguino, 
                                         // y la variable value para almacenar la conversion de grados Kelvin a grados Centigrados
int value,controlInicial=20;              // Se declara la variable celc para almacenar en tipo entero los grados centigrados para ser mostrados en la interfaz grafica
                                         // asi como tambien se declara la variable controlInicial para setear un valor por defecto para el control del sistema de calefacción

void setup(){                            // Declaracion de la funcion de configuracion inicial de Processing   
  pinguino.clear();                      // se llama al metodo clear() del objeto pinguino
  size(250,350);                         // Se define un tamaño inicial para la ventana de la interfaz grafica
  background(255);                       // Se establece un fondo blango para la interfaz 
  inicio();                              // Se llama a la funcion inicio();
}

void draw(){                             // Se declara la funcion draw() de processing para iniciar el loop del programa   
  background(255);                       // Nuevamente se establece un fondo blanco cuando para redibujar la interfaz al actualizar la informacion y vistas de la aplicacion
  text(controlInicial,50,35);            // Se escribe en las coordenadas 50,35 el valor por defecto del control inicial
  
  select();                              // Se llama a la funcion select();
  inicio();                              // Se llama a la funcion inicio();
  
  aDC=pinguino.analogRead(13);           // se almacena en aDC el valor analogo que entrega la lectura en el pin 13 de pinguino 
  kelvin=aDC*0.004882812*100;                     // Funcion matematica para calcular los grados Kelvin a partir de la lectura analoga que entrega el sensor LM335
  celcius=kelvin-273.15;      // Se calculan Grados Celcius a partir de los Grados Kelvin 
  delay(150);                       // delay de 150 milisegundos para evitar nuevas lecturas y logar una mejor vista en la interfaz de la temperatura
  value=parseInt(celcius);                        // Se convierte a tipo entero el valor de los grados Celcius y se almacenan en la variable Value
  
  text(value,100,30);                             // Se escribe en las coordenadas 100,30 los grados celcius sin valores descimales 
  text(" °C",120,30);                             // Se escribe en las coordenadas 120,30  el simbolo de grados Celcius °C
  
  if(value < controlInicial){                     // Condicional IF que evalua si el valor de la variable Value es menor que el valor inicial programado por el usuario o el por defecto
     pinguino.digitalWrite(1,pinguino.LOW);       // Instruccion de la libreria pinguino para colocar en estado bajo el pin uno de pinguino
  }else{                                          // Condicional Else, que evalua el efecto contrario en caso de que no se cumpla el IF anterior
     pinguino.digitalWrite(1,pinguino.HIGH);      // Instruccion de la libreria pinguino para colocar en estado alto el pin uno de pinguino y accionar el Relé 
  }                                               // Llave de cierre del if-else   
 
  for(int i = 0 ; i < 257 ;i += 10){             // Loop for para llamar cada 10 puntos a la funcion termometro y crear la animacion del termometro
    if(value > 0+i && value <= 10+i){             // Condicional If similar al condicional de la linea 37, el cual setea la altura de la linea segun la temeratura
      termometro(10+i);                           // Llamada a la funcion termometro con el parametro 10+i por cada iteraccion del ciclo for
    }                                             // Llave de cierre del condicional IF
  }                                               // Llave de cierre del ciclo for
}                                                 // Llave de cierre de la funcion draw() 

void inicio(){                                    // Declaracion de la funcion inicio
noStroke();                                       // Llamada a la funcion de processing noStroke() para no dibujar la linea de borde de un objeto o figura
for(int i=40;i<300;i+=20){                        // Ciclo for para crear las escalas del termometro
  fill(246,i+40,56);                              // Funcion de Processing para pintar el relleno de una figura
  rect(100,i,40,20);                              // Funcion de Processing para crear un rectangulo a partir de las coordenadas 100,i y de ancho 40 por 56 px de alto
}
 fill(255,0,0);                                   // Funcion para pintar de Rojo el relleno de una figura 
 stroke(255);                                     // Funcion para pintar de Rolo la linea de borde de una figura 
 ellipse(120,290,20,20);                          // Functio para crear la figura de un circulo en las coordenadas 120,290 y 20,20 para determinar su radio de ancho y alto
}

void termometro(int y){                           // Funcion Termometro que recibe un parametro entero, esta funcion dibuja la linea Roja con altura de acuerdo a la temperatura recibida por escalas de 10
  noStroke();                                     // Funcion de Processing para no dibujar una linea de borde para una fugura
 fill(255,0,0);                                   // Funcion de Processing para pintar de Rollo el relleno de una figura   
rect(115,300,10,-y);                              // Funcion para crear un rectangulo en las coordenadas 115,300, con 10 px de ancho y una altura variable en -Y segun el parametro recibido
redraw();                                         // Funcion para Redibujar la interfaz grafica y notar los cambios en los valores y los graficos   
}

void mousePressed(){                              // Funcion de Processing para usar el evento de mouse cuando se es presionado un boton

    if(mousePressed && mouseX>20 && mouseX < 40 && mouseY > 15 && mouseY < 25 ){  // Condicional if que evalue y triangula la posicion del puntero y capturar el evento del raton
        controlInicial++;                                                         // Se incrementa en uno el valor de la variable controlInicial para ser seteado por el usuario
      }
    if(mousePressed && mouseX>20 && mouseX < 40 && mouseY > 35 && mouseY < 55 ){  // Condicional if que evalua y triangula la posicion del puntero y capturar el evento del mouse 
        controlInicial--;                                                         // Se decrementa en uno el valor de la variable controlInicial 
      }    
       redraw();                                                                  // Funcion para redibujar la interfaz grafica y notar los cambios en los valores seteados
    }
    
void select(){                                                                    // Definicion de Funcion select() para crear botones de incremento y decremento de la variable controlInicial
         // X1  Y1  X2  Y2  X3  Y3   
   triangle(30, 15, 40, 25, 20, 25);                                              // Se crea un triangulo para simular el boton de subir el rango de temperatura a controlar
   triangle(30, 45, 40, 35, 20, 35);                                              // Se crea un triangulo para simular el boton para disminuir el rango de temperatura a controlar
}
   