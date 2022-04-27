/*
|----------------------------//----------------------------|
|  Monopolio - Versión Alpha 0.3 (20/04/22)                |
|  Proyecto Estructura de Datos I                          |
|                                                          |
|  Desarrollador: Marudonado-kami-sama Studios             |
|----------------------------//----------------------------|

  Descripción de versión:
  - Ofertar y vender funcionales
  - Sistema de Ventanas interactivas operativo
  - Implementado Ciclo Básico del Juego
  - Implementadas Condiciones de Finalización
  
*/

/*
|----------------------------//----------------------------|
|  Página Principal - Interfaz Gráfica                     |
|----------------------------//----------------------------|
*/

Juego partida = new Juego();  //Generar una partida nueva
Lista_Jugadores jugadores = new Lista_Jugadores(); //Generar lista de jugadores
Interfaz interfaz = new Interfaz ();  //Conjunto de procedimientos para la generación de la interfaz gráfica

Casilla pos = null;      //Posición de movimiento
int dado1, dado2;        //Dados
boolean dados_lanzados = false;  //Dados lanzados

boolean mouseDragged;  //Variable booleana para cuando se mantenga presionado el ratón
int menu = 0;  //Variable de definición del Menú (Revisar Documentación para más información)
int ind = 0;   //Variable de ciclo básico de la partida (Revisar Documentación para más información)


void setup(){
  //Generar Mapa
  partida.generar_mapa();
  
  //Generar Jugadores
  partida.cant_jug = 3;
  partida.ingresar_jugador (1, "Humano", 0, 0, 1);
  partida.ingresar_jugador (2, "Maquina", 0, 0, 2);
  partida.ingresar_jugador (3, "Jose", 0, 0, 2);
  
  Lista_Jugadores lista = jugadores;
  while (lista.siguiente != jugadores){
    println(lista.jugador.nombre);
    lista = lista.siguiente;
  }
  println(lista.jugador.nombre);
}


void draw(){
  switch (menu){
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
      break;
    case 5:  //Página del Juego
      interfaz.mostrar_tablero();
    
      switch (ind){
        case 1:  //Lanzar dados
          partida.lanzar_dados();
          interfaz.animacion.lanzar_dados();
          break;
        case 2:  //Mover ficha
          pos = partida.mapa.mover_posicion((dado1 + dado2), true);
          ind = 3;
          break;
        case 3:  //Animación
          interfaz.animacion.mover_ficha();
          break;
        case 4:  //Acción de la casilla
          jugadores.jugador.mover(pos);
          ind = 5;
          break;
        case 5:  //Anuncio de acción
          interfaz.anuncio();
          break;
        case 6:  //Tiempo libre
          if (jugadores.jugador.tipo == 2) {
            ind = 7;
          } else {
            interfaz.activar_pase(jugadores.jugador.interfaz.cola_acciones);
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
      break;
    case 7:  //Cartera
      interfaz.mostrar_tablero();
      interfaz.mostrar_cartera();
      break;
    case 8:  //Visualizar ventanas
      interfaz.mostrar_tablero();
      jugadores.jugador.interfaz.cola_acciones.mostrar_interfaces();
      break;
    case 9:
      break;
    case 10: //Pantalla del Fin del Juego 
      break;
    case 15:
      break;
  }
}


//----------------------------|Lectura del ratón|----------------------------
void mouseDragged() {
  mouseDragged = true;
}

void mouseReleased() {
  mouseDragged = false;
}
