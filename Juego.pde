/*
|----------------------------//----------------------------|
|  Página Secundaria - Funcionamiento de Partida           |
|----------------------------//----------------------------|
*/



//Clase que define la creación de una partida
class Juego {
  Casilla mapa;    //Lista circular con todas las casillas del juego
  
  int cant_jug;    //Contar la cantidad de jugadores para cada partida (2-8 jugadores)
  int[] of_pausa;  //Lista de la cola de espera para poder ofertar y vender (cada posición del vector es el número del jugador)
  
  
  /*
  -----------------------------------|Procedimiento de Generación de Jugadores|-----------------------------------
  Generar nuevo jugador, estos serán generados cada que el usuario aumente el número de ellos con la variable cant_jug
  Ingresar el número del jugador por medio de la variable entera jugador
  */
  void ingresar_jugador (int jugador, String nombre, int color_ficha, int figura_ficha, int tipo) {
    Jugador nuevo_jug = new Jugador ();
    nuevo_jug.generar_jugador (nombre, color_ficha, figura_ficha, tipo, mapa);
    
    if (jugador == 1){
      jugadores.generar_lista(nuevo_jug);
    } else {
      jugadores.añadir_jug (nuevo_jug);
    }
    
    println(nuevo_jug.nombre + " ha sido generado - " + (jugador * (100 / cant_jug)) + "%");
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
      Casilla inicio = new Casilla (1, null, "Inicio", 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2000);  //Posición inicial
      Casilla temp = new Casilla (0, null, "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);    //Casilla temporal;
      inicio.siguiente = temp;
      
      String linea = null;
      while ((linea = mapa.readLine()) != null) {
        cont = cont + 1;
        String[] datos = split(linea, "|");
        Casilla nueva_cas = new Casilla (cont, null, datos[0], int(datos[1]), int(datos[2]), int(datos[3]), int(datos[4]), int(datos[5]), int(datos[6]), int(datos[7]), int(datos[8]), int(datos[9]), int(datos[10]), int(datos[11]), int(datos[12]), int(datos[13]));

        if (temp.num == 0) {
          temp = nueva_cas;
          inicio.siguiente = temp;
        } else {
          temp.siguiente = nueva_cas;
          temp = nueva_cas;
        }
      }
      
      temp.siguiente = inicio;
      mapa.close();
      
      this.mapa = inicio;
      println("El mapa fue generado exitosamente - 100%");
    } catch (IOException e) {
      print("Archivo no logró cargar");
    }
  }
}
