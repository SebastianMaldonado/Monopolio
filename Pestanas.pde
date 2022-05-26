/*
|------------------------------//------------------------------|
|  Página Secundaria - Pestañas de la Interfaz del Juego       |
|------------------------------//------------------------------|
*/


/*
|====================================================================|
*                        |Pantalla de Inicio|
* Elementos                                                        
*   Botones: 
*    - Iniciar partida: Redirige a la configuración de una nueva partida
*    - Opciones: Redirige a la pestaña de opciones
*    - Salir: Cierra la aplicación
|====================================================================|
*/
class Pantalla_inicio {
  Boton inicio;        //Botón para iniciar el juego
  Boton opciones;      //Botón para entrar a opciones
  Boton salir;         //Botón para salir de la aplicación
  
  PImage img_p_inicio; //Imagen de la Portada
  
  Pantalla_inicio () {
    this.inicio = new Boton ((480*width)/1920, (430*height)/1080, (950*width)/1920, (100*height)/1080);
    this.opciones = new Boton ((480*width)/1920, (630*height)/1080, (950*width)/1920, (100*height)/1080);
    this.salir = new Boton ((480*width)/1920, (830*height)/1080, (950*width)/1920, (100*height)/1080);
    this.img_p_inicio = loadImage("Pantalla de Inicio - Boceto.png");
    this.img_p_inicio.resize (width, height);
  }
  
  
  void mostrar () {
    image (this.img_p_inicio, 0, 0);
  }
  
  void presionar () {
    if (this.inicio.sobre_boton())
      menu = 2;
    else if (this.opciones.sobre_boton())
      menu = 1;
    else if (this.salir.sobre_boton())
      exit();
  }
}


/*
|====================================================================|
*                      |Pantalla de Opciones|
* Descripción:                                                        
*  Botones: 
*    - Modo de Bajos Recursos: Cambia la visulacización del juego, evitando usar el motor gráfico para ahorrar recursos
*    - Aceptar: Acepta los cambios realizados y se devuelve a la pantalla de inicio
*  Barras: 
*    - Volumen Música: Gradúa el volumen de la música del juego 
*    - Volumen Efectos: Gradúa el volumen de los efectos
|====================================================================|
*/
class Pantalla_opciones { 
  Boton boton_mbr;            //Botón de Modo de Bajos Recursos
  Boton aceptar;              //Botón para Aceptar cambios
  Boton subir_vm, bajar_vm;   //Botones para subir y bajar volumen de música
  Boton subir_ve, bajar_ve;   //Botones para subir y bajar volumen de efectos
  
  int vol_m;                  //Medida del volumen de la música
  int vol_e;                  //Medida del volumen de efectos
  int modo_br;                //Activado modo de bajos recursos
  
  void mostrar () {
  }
  
  void presionar () {
  }
}


/*
|====================================================================|
*                         |Pantalla de Selección|
* Descripción:                                                        
*   
|====================================================================|
*/
class Pantalla_seleccion { 
  int modalidad;
  
  void mostrar () {
  }
  
  void presionar () {
  }
}


/*
|====================================================================|
*                        |Pantalla de Jugadores|
* Descripción:                                                        
*  Botones: 
*    - Nuevo Jugador: Crean nuevo espacio para información de jugador y amplía la 
*    - Aceptar: Aceptar cambios y generar jugadores ingresados
*  Menú Interactivos:
*    - Jugador: Modifica la información del jugador a crear
*      - Figura de Ficha [Menú desplegable]
*      - Nombre [Caja de Texto]
*      - Color [Menú desplegable]
*      - Tipo Jugador [Menú desplegable]
|====================================================================|
*/
class Pantalla_jugadores {
  Boton añadir_jugador;      //Botón para añadir un nuevo jugador
  Boton aceptar;             //Botón para aceptar cambios
  PImage img_p_jug;          //Imagen de la Pestaña
  
  String[] nombres = new String [9];
  int [] color_ficha = new int [9];
  int [] figura_ficha = new int [9];
  int [] tipo = new int [9];
  
  Pantalla_jugadores () {
    this.img_p_jug = loadImage ("Pantalla de Jugadores - Boceto.png");
    this.img_p_jug.resize (width, height);
  }
  
  void mostrar () {
    image (img_p_jug, 0, 0);
  }
  
  void presionar () {
    menu = 4;
  }
}


/*
|====================================================================|
*                         |Pantalla de Carga|
* Descripción:                                                        
*   Pantalla donde se ejecutarán las funciones necesarias para correr
*   el juego, el objeto deberá recibir el porcentaje de carga
|====================================================================|
*/
class Pantalla_carga {
  int carga;                            //Nivel de carga de la pantalla
  String[] nombres = new String [9];    //Nombres de los jugadores
  int [] color_ficha = new int [9];     //Color de la ficha de los jugadores
  int [] figura_ficha = new int [9];    //Figura de la ficha de los jugadores
  int [] tipo = new int [9];            //Tipo de jugador
  
  Pantalla_carga (String[] nombres, int[] color_ficha, int[] figura_ficha, int[] tipo) {
    this.nombres = nombres;
    this.color_ficha = color_ficha;
    this.figura_ficha = figura_ficha;
    this.tipo = tipo;
  }
  
  
  void mostrar () {
    rect (0, 0, width, height);
    
    this.cargar_img();
    //Subir barra de carga
    this.generar_mapa();
    //Subir barra de carga
    partida.cargar_cartas ();
    //Subir barra de carga
      partida.cant_jug = 8;
      interfaz.jug_vec = new int [partida.cant_jug + 1];
      partida.ingresar_jugador (1, "Jugador 1", 1, 0, 1);
      partida.ingresar_jugador (2, "Jugador 2", 2, 0, 1);
      partida.ingresar_jugador (3, "Jugador 3", 3, 0, 1);
      partida.ingresar_jugador (4, "Jugador 4", 4, 0, 1);
      partida.ingresar_jugador (5, "Jugador 5", 5, 0, 1);
      partida.ingresar_jugador (6, "Jugador 6", 6, 0, 1);
      partida.ingresar_jugador (7, "Jugador 7", 7, 0, 1);
      partida.ingresar_jugador (8, "Jugador 8", 8, 0, 1);
    //this.generar_jugadores();
    //Subir barra de carga
    this.cargar_cartas();
    //Subir barra de carga
    
    menu = 5;
  }
  
  
  void cargar_img () {
    //Cargar Imágenes
      for (int i = 1; i <= 5; i++) {
        for (int j = 1; j <= 5; j++) {
          motor.imagenes.ingresar("Tablero/fila-"+i+"-columna-"+j);
        }
      }
      println("Imagenes cargadas - 100%");
  }
  
  
  void generar_mapa () {
    partida.generar_mapa();
  }
  
  
  void generar_jugadores () {
    for (int i = 1; i <= partida.cant_jug; i++) {
      partida.ingresar_jugador (i, nombres[i], color_ficha[i], figura_ficha[i], tipo[i]);
    }
  }
  
  
  void cargar_cartas () {
    partida.cargar_cartas();
    partida.barajar_cartas();
  }
}
