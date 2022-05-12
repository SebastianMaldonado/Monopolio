/*
|----------------------------//----------------------------|
|  Página Secundaria - Funcionamiento de Interfaz          |
|----------------------------//----------------------------|
*/


/*
|====================================================================|
*                              |Interfaz|
* Descripción:                                                        
*   Objeto administrador de interfaces y decisiones del jugador humano
*   visualiza las ventanas y gestiona sus variables temporales
|====================================================================|
*/
class Interfaz {
  
  Animacion animacion;
  boolean pasar_turno;
  
  boolean inventario_mostrado = false;  //Para cada vez que se vaya a cargar el inventario
  Lista_interfaz propiedades;
  
  //Variables de los jugadores
    String[] nombres = new String [9];
    int [] color_ficha = new int [9];
    int [] figura_ficha = new int [9];
    int [] tipo = new int [9];
  
  Interfaz () {
    Animacion animacion = new Animacion ();  //Generador de Animaciones
    this.animacion = animacion;
  }
  
  
  /*
  ---------------------------------------|Pantalla de Inicio|---------------------------------------
   Botones: 
     - Iniciar partida: Redirige a la configuración de una nueva partida
     - Opciones: Redirige a la pestaña de opciones
     - Salir: Cierra la aplicación
  */
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
  
  
  /*
  ---------------------------------------|Pantalla de Opciones|---------------------------------------
   Botones: 
     - Modo de Bajos Recursos: Cambia la visulacización del juego, evitando usar el motor gráfico para ahorrar recursos
     - Aceptar: Acepta los cambios realizados y se devuelve a la pantalla de inicio
   Barras: 
     - Volumen Música: Gradúa el volumen de la música del juego 
     - Volumen Efectos: Gradúa el volumen de los efectos
  */
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
  
  
  /*
  ---------------------------------------|Pantalla de Jugadores|---------------------------------------
   Botones: 
     - Nuevo Jugador: Crean nuevo espacio para información de jugador y amplía la 
     - Aceptar: Aceptar cambios y generar jugadores ingresados
   Menú Interactivos:
     - Jugador: Modifica la información del jugador a crear
       - Figura de Ficha [Menú desplegable]
       - Nombre [Caja de Texto]
       - Color [Menú desplegable]
       - Tipo Jugador [Menú desplegable]
  */
  void jugadores () {
    image (Pantalla_jugadores, 0, 0);
    
    //Cantidad de jugadores de la partida
      partida.cant_jug = 2;
    
    //Botón de aceptar
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
      
    //Generar jugadores
      for (int i = 1; i <= partida.cant_jug; i++) {
        //partida.ingresar_jugador (i, nombres[i], color_ficha[i], figura_ficha[i], tipo[i]);
      }
        
      partida.ingresar_jugador (1, "Jugador 1", 0, 0, 1);
      partida.ingresar_jugador (2, "Jugador 2", 0, 0, 1);
    
    //Liberar espacio
      this.nombres = null;
      this.color_ficha = null;
      this.figura_ficha = null;
      this.tipo = null;
    
    //Barra de Carga
      partida.cargar_cartas();
      partida.barajar_cartas();
      
    //Finalizar carga
      menu = 5; //Pasar a la partida
  }

  void mostrar_tablero () {
    
    //Generar variables temporales
    float cord_x = 0, cord_y = 0;
    
    //-------------[Mostrar Tablero]-------------
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
      
    //-------------[Mostrar Edificios]-------------
      //Crear variables temporales
      Lista_casillas temp_2 = partida.mapa;
      
      do {
        if (temp_2.casilla.construcciones != 0) {
          //Generar coordenadas
          cord_x = temp_2.casilla.coordenadas_jug(1);
          cord_y = temp_2.casilla.coordenadas_jug(2);
          
          //Mostrar imagen
          switch (temp_2.casilla.construcciones) {
            case 1:  //1 Casa
              motor.mostrar("Casa_1", cord_x, cord_y, 50, 50);
              break;
            case 2:  //2 Casas
              motor.mostrar("Casa_2", cord_x, cord_y, 50, 50);
              break;
            case 3:  //3 Casas
              motor.mostrar("Casa_3", cord_x, cord_y, 50, 50);
              break;
            case 4:  //4 Casas
              motor.mostrar("Casa_4", cord_x, cord_y, 50, 50);
              break;
            case 5:  //Castillo
              motor.mostrar("Castillo", cord_x, cord_y, 50, 50);
              break;
          }
        }
        
        temp_2 = temp_2.siguiente;
      } while (temp_2 != partida.mapa);
      
      temp_2 = null;  //Liberar memoria
      
    //-------------[Mostrar Fichas]-------------
      //Crear variables temporales
      Lista_Jugadores temp_1 = jugadores;
      
      do {
        //Generar coordenadas
        cord_x = temp_1.jugador.posicion.casilla.coordenadas_jug(1);
        cord_y = temp_1.jugador.posicion.casilla.coordenadas_jug(2);
        
        //println("Mostrar " + temp_1.jugador.nombre + " en " + cord_x + "  " + cord_y);
        
        motor.mostrar(temp_1.jugador.ficha, cord_x, cord_y, 200, 200);  //Mostrar imagen
        
        temp_1 = temp_1.siguiente;
      } while (temp_1 != jugadores);
      
      temp_1 = null;  //Liberar memoria
      
    //Botón para abrir inventario
    
    //Botón para abrir cartera
    
    //Botón para abrir pestaña de negocios
    
  }


  /*
  ---------------------------------------|Inventario|---------------------------------------
   Botones: 
     - Propiedades [lista de ventanas]: Cada que se presione en una propiedad se desplegará la información de la misma
     - Devolverse: Devuelve al menú principal
  */
  void mostrar_inventario() {
    //Cargar propiedades como ventanas
    if (!inventario_mostrado) {
      this.propiedades = new Lista_interfaz ();
      Lista_casillas temp = jugadores.jugador.propiedades;
      
      do {  //Generar una ventana por cada propiedad en poseción del jugador
        Ventana nuevo = new Ventana (4, 0, 0, 200, 400);  //--------------------------------------------- |Para hacer|
        this.propiedades.añadir_cola (nuevo, 0);
      } while (temp != jugadores.jugador.propiedades);
      
      inventario_mostrado = true;
    }
    
    //Mostrar las cartas del jugador
    this.propiedades.mostrar_interfaces();
  }
  
  
  /*
  ---------------------------------------|Cartera|---------------------------------------
  Muestra la cantidad de billetes de que se poseen
  */
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


/*
|====================================================================|
*                          |Animación|
* Descripción:                                                        
*   Objeto para generar una animación
|====================================================================|
*/
class Animacion {
  
  void lanzar_dados () {
  }
  
  void mover_ficha () {
  }
  
  
}
