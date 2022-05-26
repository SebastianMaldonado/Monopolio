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
  Lista_casillas mapa;      //Lista circular con todas las casillas del juego
  Carta fortuna;            //Lista circular con todas las cartas de Fortuna
  Carta cofre;              //Lista circular con todas las cartas de Cofre
  
  int cant_jug;             //Contar la cantidad de jugadores para cada partida (2-8 jugadores)
  int cant_casas = 32;      //Cantidad de casas de las que dispone el juego
  int cant_castillos = 12;  //Cantidad de castillos de los que dispone el juego
  int[] of_pausa;           //Lista de la cola de espera para poder ofertar y vender (cada posición del vector es el número del jugador)
  
  
  void lanzar_dados () {
    if (!dados_lanzados) {
      dado1 = int(random (1, 7));
      dado2 = int(random (1, 7));
      dados_lanzados = true;
    }
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
  void generar_mapa () {
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
  
  
  void pasar_turno () {
    jugadores = jugadores.siguiente;
    
    while (jugadores.jugador.estado == 3) {
      jugadores = jugadores.siguiente;
    }
    
    bancarrota = false;
    dados_lanzados = false;
    ind = 1;
    interfaz.inv_cargado = false;
    interfaz.neg_cargado = false;
  }
  
  
  //-------------------------|Verificar fin del Juego|-------------------------//
  //Si todos los jugadores menos uno se encuentra en bancarrota
  void verificar_fin () {
    Lista_Jugadores temp = jugadores;
    int cont = 0;
    
    do {
      if (temp.jugador.estado != 3)  //Verificar cuántos jugadores quedan en la partida
        cont += 1;
      
      if (cont > 1)                  //Si queda más de un jugador
        return;
      
      temp = temp.siguiente;
    } while (temp != jugadores);
    
    fin_juego = true;  //Si solo quedó un jugador
  }
  
  
  //-------------------------|Hipotecar propiedades|-------------------------//
  //Por medio de esta subrutina se podrán hipotecar las propiedades
  //Se venderán automáticamente todas las casas y castillos del grupo de color
  //La propiedad quedará hipotecada y se pagará al jugador el valor de la hipoteca
  void hipotecar (Casilla propiedad) {
    
  }
  
  
  //-------------------------|Construir casas|-------------------------//
  //Se podrá aumentar el nivel de las edificaciones de las propiedades
  //Este será medido según la cantidad de casas y castillos disponibles
  void construir (Casilla propiedad) {
    if (propiedad.construcciones == 5)    //Si la propiedad ya llegó al límite de propiedades
      return;
    
    jugadores.jugador.pagar (propiedad.vl_casa);  //Pagar el valor de la construcción
    
    if (propiedad.construcciones == 4 && this.cant_castillos > 0) {    //Si se desea comprar un castillo
      this.cant_casas += 4;
      this.cant_castillos -= 1;
    } else if (this.cant_casas > 0) {                                  //Si se desea comprar una casa
      this.cant_casas -= 1;
    } else {                                                           //Si no hay lo que se desea comprar
      return;
    }
    
    propiedad.construcciones += 1;
  }
  
  /*
  -------------------------------------|Procedimiento de Cargado de cartas|-------------------------------------
  Deberá existir un archivo alojado en la aplicación llamado "suerte.txt" y otro llamado "cofre.txt"
  En este archivo deberá contenerse toda la información de las casillas del mapa sin contar a la casilla de inicio
  */
  void cargar_cartas () {
    this.fortuna = new Carta ();
    this.cofre = new Carta ();
    
    //Cargar cartas de Fortuna
    try {
      BufferedReader doc_fortuna = createReader("suerte.txt");
      
      String linea = null;
      while ((linea = doc_fortuna.readLine()) != null) {
        String[] datos = split(linea, "|");
        this.fortuna.añadir_carta (loadImage("Cartas/Fortuna-"+datos[0]+".png"), int(datos[1]), int(datos[2]));
      }
      doc_fortuna.close();
    } catch (IOException e) {
      println("Partida:  Archivo no logró cargar");
    }
    
    //Cargar cartas de Cofre
    try {
      BufferedReader doc_cofre = createReader("cofre.txt");
      
      String linea = null;
      while ((linea = doc_cofre.readLine()) != null) {
        String[] datos = split(linea, "|");
        this.cofre.añadir_carta (loadImage("Cartas/Cofre-"+datos[0]+".png"), int(datos[1]), int(datos[2]));
      }
      doc_cofre.close();
    } catch (IOException e) {
      println("Partida:  Archivo no logró cargar");
    }
  }
  
  
  /*
  -------------------------------------|Procedimiento para barajar las cartas|-------------------------------------
  Procedimiento para ubicar las cartas en un orden aleatorio
  */
  void barajar_cartas () {
    int cont = 16;
    int num = 0;
    
    for (int i = 1; i <= 16; i++) {
      num = int(random (1, 16));
      for (int j = 1; j <= num; j++) {
        
      }
    }
  }
}
