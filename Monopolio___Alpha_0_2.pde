/*
|----------------------------//----------------------------|
|  Monopolio - Versión Alpha 0.2 (17/04/22)                |
|  Proyecto Estructura de Datos I                          |
|                                                          |
|  Desarrollador: Marudonado-kami-sama Studios             |
|----------------------------//----------------------------|

  Descripción de versión:
  - Ofertar y vender funcionales parcialmente 
  - Introducida arquitectura para Interfaz
  - Añadido nuevo sistema de toma de decisiones para jugador humano
  - Añadida cola de decisiones para el jugador humano
  - Introducida versión experimental de ventanas interactivas
  - Ahora cada jugador contará con su propio contenedor (objeto de la clase Humano o de la clase Maquina)
  
*/

/*
|----------------------------//----------------------------|
|  Página Principal - Interfaz Gráfica                     |
|----------------------------//----------------------------|
*/

Juego partida = new Juego();  //Generar una partida nueva
Lista_Jugadores jugadores = new Lista_Jugadores(); //Generar lista de jugadores

boolean mouseDragged;  //Variable booleana para cuando se mantenga presionado el ratón
int menu;  //Variable de definición del Menú (Revisar Documentación para más información)


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
      break;
    case 1:  //Página de Opciones
      break;   
    case 2:  //Página de Lectura de Jugadores
      break;
    case 3:  //Página de Selección de Modalidad
      break;
    case 4:  //Pantalla de Carga
      break;
    case 5:  //Página del Juego
      break;
    case 6:  //Inventario
      break;
    case 7:  //Cartera
      break;
    case 8:  //Visualizar ventanas
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
