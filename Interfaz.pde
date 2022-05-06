/*
|----------------------------//----------------------------|
|  Página Secundaria - Funcionamiento de Interfaz          |
|----------------------------//----------------------------|
*/

class Interfaz {
  
  Animacion animacion;
  boolean pasar_turno;
  
  Interfaz () {
    Animacion animacion = new Animacion ();  //Generador de Animaciones
    this.animacion = animacion;
  }
  
  void pantalla_inicio () {
    image (Pantalla_inicio, 0, 0);
    
    if (mousePressed) {
      //Botón de inicio
      if ((mouseX >= 480*(width/1920)) && (mouseX <= 1435*(width/1920)) && (mouseY >= 430*(height/1080)) && (mouseY <= 530*(height/1080))){             //Botón de inicio
        menu = 2;
      } else if ((mouseX >= 480*(width/1920)) && (mouseX <= 1435*(width/1920)) && (mouseY >= 630*(height/1080)) && (mouseY <= 730*(height/1080))) {     //Botón de opciones
        menu = 1; 
      } else if ((mouseX >= 480*(width/1920)) && (mouseX <= 1435*(width/1920)) && (mouseY >= 830*(height/1080)) && (mouseY <= 930*(height/1080))) {     //Botón de salida
        exit();
      }
    }
    
  }

  void opciones () {
    //Volumen de Música
      vol_m = 1;
    //Volumen de Efectos
      vol_e = 1;
    //Modo de Bajos recursos
      modo_br = false;
      
    //Botón de aceptar
      menu = 0;  //Volver a Inicio
  }

  void jugadores () {
    image (Pantalla_jugadores, 0, 0);
    
    //Cantidad de jugadores de la partida
      partida.cant_jug = 8;
    
    //Variables de los jugadores
      String[] nombres = new String [9];
      int [] color_ficha = new int [9];
      int [] color_figura = new int [9];
      int [] tipo = new int [9];
    
    //Botón de aceptar
      for (int i = 1; i <= partida.cant_jug; i++){
        //partida.ingresar_jugador (i, nombres[i], color_ficha[i], color_figura[i], tipo[i]);
      }
      menu = 3; //Pasar a la selección de Modalidades
  }

  void seleccion () {  
    //Modalidad Normal
      modalidad = 1;
      
    //Modalidad "Telón de Acero"
      modalidad = 2;
      
    //Botón de Aceptar
      menu = 4; //Pasar a la pantalla de carga
  }

  void pantalla_carga () {
    //Cargar Imágenes
      for (int i = 1; i <= 5; i++) {
        for (int j = 1; j <= 5; j++) {
          motor.imagenes.ingresar("fila-"+i+"-columna-"+j);
        }
      }
      println("Imagenes cargadas - 100%");
    
      
    //Generar mapa
      partida.generar_mapa();
      
    //Barra de Carga
      partida.cargar_cartas();
      partida.barajar_cartas();
      
    //Finalizar carga
      menu = 5; //Pasar a la partida
  }

  void mostrar_tablero () {
    //Mostrar tablero
      motor.mostrar("fila-1-columna-1", 0, 0, 1001, 1001);
      motor.mostrar("fila-1-columna-2", 1000, 0, 1001, 1001);
      motor.mostrar("fila-1-columna-3", 2000, 0, 1001, 1001);
      motor.mostrar("fila-1-columna-4", 3000, 0, 1001, 1001);
      motor.mostrar("fila-1-columna-5", 4000, 0, 1001, 1001);
      motor.mostrar("fila-2-columna-1", 0, 1000, 1001, 1001); 
      motor.mostrar("fila-2-columna-2", 1000, 1000, 1001, 1001); 
      motor.mostrar("fila-2-columna-3", 2000, 1000, 1001, 1001); 
      motor.mostrar("fila-2-columna-4", 3000, 1000, 1001, 1001); 
      motor.mostrar("fila-2-columna-5", 4000, 1000, 1001, 1001);
      motor.mostrar("fila-3-columna-1", 0, 2000, 1001, 1001);
      motor.mostrar("fila-3-columna-2", 1000, 2000, 1001, 1001);
      motor.mostrar("fila-3-columna-3", 2000, 2000, 1001, 1001);
      motor.mostrar("fila-3-columna-4", 3000, 2000, 1001, 1001);
      motor.mostrar("fila-3-columna-5", 4000, 2000, 1001, 1001);
      motor.mostrar("fila-4-columna-1", 0, 3000, 1001, 1001);
      motor.mostrar("fila-4-columna-2", 1000, 3000, 1001, 1001);
      motor.mostrar("fila-4-columna-3", 2000, 3000, 1001, 1001);
      motor.mostrar("fila-4-columna-4", 3000, 3000, 1001, 1001);
      motor.mostrar("fila-4-columna-5", 4000, 3000, 1001, 1001);
      motor.mostrar("fila-5-columna-1", 0, 4000, 1001, 1001);
      motor.mostrar("fila-5-columna-2", 1000, 4000, 1001, 1001);
      motor.mostrar("fila-5-columna-3", 2000, 4000, 1001, 1001);
      motor.mostrar("fila-5-columna-4", 3000, 4000, 1001, 1001);
      motor.mostrar("fila-5-columna-5", 4000, 4000, 1001, 1001);
    //Mostrar Fichas
      Lista_Jugadores temp = jugadores;
      float cord_x = 0, cord_y = 0;
      
      do  {
        //temp.jugador.coordenadas_jug(cord_x, cord_y);
        //motor.mostrar(temp.jugador.ficha, cord_x, cord_y, 200, 200);
        //temp = temp.siguiente;
      } while (temp != jugadores);
      temp = null;
    //Mostrar edificios
    
    //Botón para abrir inventario
    
    //Botón para abrir cartera
    
    //Botón para abrir pestaña de negocios
    
  }
  
  void mostrar_inventario() {
    //Mostrar las cartas del jugador
  }
  
  void mostrar_cartera () { 
    //Mostrar los billetes del jugador
  }
  
  void mostrar_negocios () {
    //Mostrar pestaña
  }
  
  void anuncio () {
    //Mostrar anuncio
  }
  
  void activar_pase (Lista_interfaz cola) {
    boolean permiso = true;
    
    //Validar permiso para pasar turno
    if (cola.interfaz != null)
      permiso = false;
      
    if (permiso){  //Cuando se puede pasar turno
      
    } else {      //Cuando NO se puede pasar turno
    
    }
  }
  
}

class Animacion {
  
  void lanzar_dados () {
  }
  
  void mover_ficha () {
  }
  
  
}
