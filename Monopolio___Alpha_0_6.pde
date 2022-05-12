 /*
|----------------------------//----------------------------|
|  Monopolio - Versión Alpha 0.6 (10/05/22)                |
|  Proyecto Estructura de Datos I                          |
|                                                          |
|  Desarrollador: Marudonado-kami-sama Studios             |
|----------------------------//----------------------------|

  Descripción de versión:
    - Implementadas las funcionalidades de las ventanas
    - Pestañas de inventario y ventanas funcionales en consola
    - Implementado el cálculo de la renta de cada casilla
    - Arreglado error con las posiciones de la casillas de la línea inferior
  
*/


/*
|----------------------------//----------------------------|
|  Página Principal - Interfaz Gráfica                     |
|----------------------------//----------------------------|
*/

//Imágenes
  Motor_Grafico motor = new Motor_Grafico (5000, 5000);
  PImage Pantalla_inicio;
  PImage Pantalla_opciones;
  PImage Pantalla_jugadores;
  PImage Tablero;

//Variables de opciones
  float vol_m = 1;           //Volumen ambiente
  float vol_e = 1;           //Volumen efectos
  boolean modo_br = false;   //Modo de bajos recursos
  int modalidad = 1;         //Modalidad del juego [1] Normal | [2] Telón de Acero

//Objetos de Apliación Global
  Juego partida = new Juego();                          //Generar una partida nueva
  Lista_Jugadores jugadores = new Lista_Jugadores();    //Generar lista de jugadores
  Interfaz interfaz = new Interfaz ();                  //Conjunto de procedimientos para la generación de la interfaz gráfica

Lista_casillas pos = null;       //Posición de movimiento
int dado1, dado2;                //Dados
boolean dados_lanzados = false;  //Dados lanzados

boolean mouseDragged;    //Variable booleana para cuando se mantenga presionado el ratón
int menu = 0;            //Variable de definición del Menú (Revisar Documentación para más información)
int ind = 1;             //Variable de ciclo básico de la partida (Revisar Documentación para más información)


void setup(){ 
  fullScreen();
  
  //Motor Gráfico
  motor.inicializar();
  
  //Carga de Imágenes
  Pantalla_inicio = loadImage ("Pantalla de Inicio - Boceto.png");
  Pantalla_jugadores = loadImage ("Pantalla de Jugadores - Boceto.png");
}


void draw(){
  switch (menu) {
    case 0:  //Página de Inicio
      interfaz.pantalla_inicio();
      break;
    case 1:  //Página de Opciones
      interfaz.opciones();
      break;   
    case 2:  //Página de Lectura de Jugadores
      interfaz.jugadores ();
      break;
    case 3:  //Página de Selección de Modalidad
      interfaz.seleccion();
      break;
    case 4:  //Pantalla de Carga
      interfaz.pantalla_carga();
      break;
    case 5:  //Página del Juego
      interfaz.mostrar_tablero();
    
      switch (ind){
        case 1:  //Lanzar dados
          partida.lanzar_dados();
          interfaz.animacion.lanzar_dados();  //---------------------------------------------------------- |Para hacer|
          println("Dados lanzados:  "+dado1+"  "+dado2);
          ind = 2;
          break;
        case 2:  //Mover ficha
          pos = jugadores.jugador.posicion.mover_posicion((dado1 + dado2), true);
          println("Casilla caída:  " + pos.casilla.nombre);
          ind = 3;
          break;
        case 3:  //Animación
          interfaz.animacion.mover_ficha();  //---------------------------------------------------------- |Para hacer|
          ind = 4;
          break;
        case 4:  //Acción de la casilla
          jugadores.jugador.mover(pos);
          ind = 5;
          break;
        case 5:  //Anuncio de acción
          interfaz.anuncio();  //---------------------------------------------------------- |Para hacer|
          ind = 6;
          break;
        case 6:  //Tiempo libre
          if (jugadores.jugador.tipo == 2) {
            ind = 7;
          } else {
            interfaz.activar_pase(jugadores.jugador.interfaz.cola_acciones); //---------------------------------------------------------- |Verificar funcionalidad|
          }
          break;
        case 7:  //Acción de pasar turno
          partida.pasar_turno();
          break;
      }
      break;
    case 6:  //Inventario
      interfaz.mostrar_tablero();
      interfaz.mostrar_inventario();
      println("Menú [Inventario]: Activado");
      break;
    case 7:  //Cartera
      interfaz.mostrar_tablero();
      interfaz.mostrar_cartera();
      println("Menú [Cartera]: Activado");
      break;
    case 8:  //Visualizar ventanas
      interfaz.mostrar_tablero();
      jugadores.jugador.interfaz.cola_acciones.mostrar_interfaces();
      println("Menú [Ventanas]: Activado");
      break;
    case 9:  //Negociaciones
      interfaz.mostrar_negocios();
      println("Menú [Negocios]: Activado");
      break;
    case 10: //Pantalla del Fin del Juego 
      break;
    case 15:
      break;
  }
}


//----------------------------|Lectura del ratón|----------------------------
void mousePressed(){
  //jugadores.jugador.interfaz.cola_acciones = jugadores.jugador.interfaz.cola_acciones.seleccionar();
  if (menu >= 5 && menu <= 9) //Si se encuentra mostrando el mapa
    motor.presionar();
    
  if (menu == 6)  //Inventario
    interfaz.propiedades.seleccionar();  //Seleccionar una de las propiedades
}

void keyPressed(){
  if (menu >= 5 && menu <= 9) //Si se encuentra mostrando el mapa
    motor.mover();
    
  if ((menu == 5) && (ind == 6)) {  //Tiempo libre del Juego
    if (key == '1') {           //Inventario
      menu = 6;
    } else if (key == '2') {    //Cartera
      menu = 7;
    } else if (key == '3') {    //Visualizar Ventanas
      menu = 8;
    } else if (key == '4') {    //Negociaciones
      menu = 9;
    } else if (key == ENTER) {  //Pasar turno
      ind = 7;
    }
  } else if ((menu >= 6) && (menu <= 9)) {  //Si se encuentra en algún menú de jugador
    if (key == ENTER)  //Devolverse
      menu  = 5;
    }
}

void mouseWheel (MouseEvent event) {
  if (menu >= 5 && menu <= 9) //Si se encuentra mostrando el mapa
    motor.zoom(event.getCount());
}

void mouseDragged() {
  mouseDragged = true;
}

void mouseReleased() {
  mouseDragged = false;
}
