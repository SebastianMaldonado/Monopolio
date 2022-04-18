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
  - Habilitada interfaz para introducir jugadores y cargar el juego
*/

/*
|----------------------------//----------------------------|
|  Página Principal - Interfaz Gráfica                     |
|----------------------------//----------------------------|
*/

Juego partida = new Juego();  //Generar una partida nueva
Lista_Jugadores jugadores = new Lista_Jugadores(); //Generar lista de jugadores
Humano interfaz = new Humano();  //Generar una partida nueva
Maquina IA = new Maquina();  //Generar una partida nueva

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
    case 2:  //Página de 
    case 5:
      break;
    case 10:
      break;
    case 15:
      break;
  
  }



}
