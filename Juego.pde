/*
|----------------------------//----------------------------|
|  Página Secundaria - Funcionamiento de Partida           |
|----------------------------//----------------------------|
*/


/*
|====================================================================|
*                              |Juego|
* Descripción:                                                        
*   Administrador de las funciones principales del juego
*   Es además el encargado de cargar la información de casillas,
*   cartas y jugadores de la partida
|====================================================================|
*/
class Juego {
  Lista_casillas mapa;    //Lista circular con todas las casillas del juego
  
  int cant_jug;    //Contar la cantidad de jugadores para cada partida (2-8 jugadores)
  int[] of_pausa;  //Lista de la cola de espera para poder ofertar y vender (cada posición del vector es el número del jugador)
  
  void lanzar_dados () {
    if (!dados_lanzados) {
      dado1 = int(random (1, 7));
      dado2 = int(random (1, 7));
      dados_lanzados = true;
    }
  }
  
  void pasar_turno () {
    jugadores = jugadores.siguiente;
    dados_lanzados = false;
    ind = 1;
    interfaz.inv_cargado = false;
  }
  
  /*
  -----------------------------------|Procedimiento de Generación de Jugadores|-----------------------------------
  Generar nuevo jugador, estos serán generados cada que el usuario aumente el número de ellos con la variable cant_jug
  Ingresar el número del jugador por medio de la variable entera jugador
  */
  void ingresar_jugador (int jugador, String nombre, int color_ficha, int figura_ficha, int tipo) {
    Jugador nuevo_jug = new Jugador ();
    nuevo_jug.generar_jugador (nombre, color_ficha, figura_ficha, tipo, mapa);
    
    jugadores.añadir_jug (nuevo_jug);
    
    println("Partida:  " + nuevo_jug.nombre + " ha sido generado - " + (jugador * (100 / cant_jug)) + "%");
  }
  
  
  /*
  -------------------------------------|Procedimiento de Generación de Mapa|-------------------------------------
  Deberá existir un archivo alojado en la aplicación llamado "mapa.txt"
  En este archivo deberá contenerse toda la información de las casillas del mapa sin contar a la casilla de inicio
  */
  void generar_mapa (){
    try {
      BufferedReader mapa = createReader("mapa.txt");
      
      int cont = 1;
      Casilla inicio = new Casilla (1, null, "Inicio", 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2000);  //Casilla de Inicio
      Lista_casillas lista = new Lista_casillas (inicio);                                          //Lista de Casillas del mapa
      Lista_casillas temp = lista;                                                                 //Posición temporal 
      
      //Lectura de la información de cada casilla
      String linea = null;
      while ((linea = mapa.readLine()) != null) {
        cont = cont + 1;
        String[] datos = split(linea, "|");
        
        //Crear objeto Casilla con la información
        Casilla nueva_cas = new Casilla (cont, null, datos[0], int(datos[1]), int(datos[2]), int(datos[3]), int(datos[4]), int(datos[5]), int(datos[6]), int(datos[7]), int(datos[8]), int(datos[9]), int(datos[10]), int(datos[11]), int(datos[12]), int(datos[13]));
        
        //Ingresarlo a la lista
        lista = lista.añadir_propiedad(nueva_cas);
        temp = temp.siguiente;
      }
      
      temp.siguiente = lista;
      mapa.close();
      
      this.mapa = lista;
      println("Partida:  El mapa fue generado exitosamente - 100%");
    } catch (IOException e) {
      println("Partida:  Archivo no logró cargar");
    }
  }
  
  
  /*
  -------------------------------------|Procedimiento de Cargado de cartas|-------------------------------------
  Deberá existir un archivo alojado en la aplicación llamado "cartas.txt"
  En este archivo deberá contenerse toda la información de las casillas del mapa sin contar a la casilla de inicio
  */
  void cargar_cartas () {
  }
  
  
  /*
  -------------------------------------|Procedimiento para barajar las cartas|-------------------------------------
  Procedimiento para ubicar las cartas en un orden aleatorio
  */
  void barajar_cartas () {
  }
}
