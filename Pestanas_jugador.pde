/*
|------------------------------//------------------------------|
|  Página Secundaria - Pestañas de la Interfaz del Jugador     |
|------------------------------//------------------------------|
*/


/*
|====================================================================|
*                             |Tablero|
* Descripción:                                                        
*   Pantalla donde se ejecutarán las funciones necesarias para correr
*   el juego, el objeto deberá recibir el porcentaje de carga
|====================================================================|
*/
class Tablero {
  
  void mostrar () {
    //Generar variables temporales
    float cord_x = 0, cord_y = 0;
    
    //-------------[Mostrar Tablero]-------------
      motor.mostrar("Tablero/fila-1-columna-1", 0, 0, 1001, 1001);
      motor.mostrar("Tablero/fila-1-columna-2", 1000, 0, 1001, 1001);
      motor.mostrar("Tablero/fila-1-columna-3", 2000, 0, 1001, 1001);
      motor.mostrar("Tablero/fila-1-columna-4", 3000, 0, 1001, 1001);
      motor.mostrar("Tablero/fila-1-columna-5", 4000, 0, 1001, 1001);
      motor.mostrar("Tablero/fila-2-columna-1", 0, 1000, 1001, 1001); 
      motor.mostrar("Tablero/fila-2-columna-2", 1000, 1000, 1001, 1001); 
      motor.mostrar("Tablero/fila-2-columna-3", 2000, 1000, 1001, 1001); 
      motor.mostrar("Tablero/fila-2-columna-4", 3000, 1000, 1001, 1001); 
      motor.mostrar("Tablero/fila-2-columna-5", 4000, 1000, 1001, 1001);
      motor.mostrar("Tablero/fila-3-columna-1", 0, 2000, 1001, 1001);
      motor.mostrar("Tablero/fila-3-columna-2", 1000, 2000, 1001, 1001);
      motor.mostrar("Tablero/fila-3-columna-3", 2000, 2000, 1001, 1001);
      motor.mostrar("Tablero/fila-3-columna-4", 3000, 2000, 1001, 1001);
      motor.mostrar("Tablero/fila-3-columna-5", 4000, 2000, 1001, 1001);
      motor.mostrar("Tablero/fila-4-columna-1", 0, 3000, 1001, 1001);
      motor.mostrar("Tablero/fila-4-columna-2", 1000, 3000, 1001, 1001);
      motor.mostrar("Tablero/fila-4-columna-3", 2000, 3000, 1001, 1001);
      motor.mostrar("Tablero/fila-4-columna-4", 3000, 3000, 1001, 1001);
      motor.mostrar("Tablero/fila-4-columna-5", 4000, 3000, 1001, 1001);
      motor.mostrar("Tablero/fila-5-columna-1", 0, 4000, 1001, 1001);
      motor.mostrar("Tablero/fila-5-columna-2", 1000, 4000, 1001, 1001);
      motor.mostrar("Tablero/fila-5-columna-3", 2000, 4000, 1001, 1001);
      motor.mostrar("Tablero/fila-5-columna-4", 3000, 4000, 1001, 1001);
      motor.mostrar("Tablero/fila-5-columna-5", 4000, 4000, 1001, 1001);
      
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
        
        if (((menu == 5) && (ind == 3))) {
          if ((jugadores == temp_1) && (fichas != null)) {
            cord_x = fichas.calc_pos(true);
            cord_y = fichas.calc_pos(false);
          }
        }
          
          motor.mostrar(temp_1.jugador.ficha, cord_x, cord_y, 200, 200);  //Mostrar imagen
          
          temp_1 = temp_1.siguiente;
      } while (temp_1 != jugadores);
      
      temp_1 = null;  //Liberar memoria
  }
}


/*
|====================================================================|
*                            |Inventario|
* Descripción:                                                        
*    Botones: 
*      - Propiedades [menu_seleccion]: se mostrará una lista de propiedades las cuales se podrán seleccionar
*      - Inventario del jugador:
*        - Vender: Permite seleccionar un jugador para ofrecerle la propiedad
*        - Hipotecar: Hipoteca la casa al banco
*        - Construir: Compra el siguiente nivel de construcción en la propiedad
*      - Inventario de otro jugador:
*        - Ofertar: Proponerle la compra de una de sus propiedades a otro jugador
*      - Devolverse: Devuelve al menú principal
|====================================================================|
*/
class Inventario {
  Menu_seleccion inventario;    //Menú de Selección (Lista de propiedades)
  boolean inv_propio;           //Booleano para saber si es el inventario propio
  Casilla seleccionado;         //Casilla seleccionada
  Tarjeta_itr tarjeta;          //Tarjeta de la propiedad
  
  Boton vender;                 //Botón para vender la propiedad
  Boton hipotecar;              //Botón para hipotecar la propiedad
  Boton construir;              //Botón para construir en la propiedad
  Boton ofertar;                //Botón para ofertar la propiedad del jugador seleccionado
  
  Inventario (Jugador jugador) {
    this.vender = new Boton ((3*width)/5 + ((2*width)/5)/13, (7*height)/8, 3*((2*width)/5)/13, height/12);
    this.hipotecar = new Boton ((3*width)/5 + (5*((2*width)/5))/13, (7*height)/8, 3*((2*width)/5)/13, height/12);
    this.construir = new Boton ((3*width)/5 + (9*((2*width)/5))/13, (7*height)/8, 3*((2*width)/5)/13, height/12);
    this.ofertar = new Boton ((3*width)/5 + (5*((2*width)/5))/13, (7*height)/8, 3*((2*width)/5)/13, height/12);
    this.inventario = new Menu_seleccion (0, 0, 3*width/5, height, 1);
    
    //Determinar si es el inventario propio
    if (jugador == jugadores.jugador)  
      this.inv_propio = true;
    else
      this.inv_propio = false;
      
    //Cargar propiedades como ventanas
    Lista_casillas temp = jugador.propiedades;
    if (temp != null) {      //Si hay propiedades cargadas
      //Ingresar propiedades en el menú
      do {
        this.inventario.añadir_carp(temp.casilla);
        temp = temp.siguiente;
      } while (temp != jugador.propiedades);
    }
  }
  
  
  void mostrar () {
    inventario.mostrar();
    
    if (seleccionado != null) {
      fill(255);
      textSize (30);
      textAlign(CENTER);
      text (seleccionado.nombre, (1305*width)/1920, (30*height)/1080, (461*width)/1920, (50*height)/1080);
      
      String info = "Contrucciones: " + seleccionado.construcciones;
      if (seleccionado.hipotecada)
        info = info + "\n Hipotecada: Si";
      else
        info = info + "\n Hipotecada: No";
      
      textAlign(LEFT);
      text (info, (1305*width)/1920, (791*height)/1080, (461*width)/1920, (300*height)/1080);
      fill(255);
      
      tarjeta.mostrar();
      tarjeta.vx = (1305*width)/1920;
      tarjeta.vy = (100*height)/1080;
      
      if (inv_propio) {      //Si se está observando el inventario propio
        vender.mostrar();
        hipotecar.mostrar();
        construir.mostrar();
      } else {               //Si se está observando el inventario de otro jugador
        ofertar.mostrar();
      }
      
    }
  }
  
  
  void presionar () {
    Capsula_CJ temp = this.inventario.presionar();
    
    if (temp != null) {    //Si se está seleccionando una propiedad
      this.seleccionado = temp.casilla;
      tarjeta = new Tarjeta_itr (seleccionado.frente, seleccionado.reverso, (1305*width)/1920, (100*height)/1080, (461*width)/1920, (691*height)/1080);
    } else {               //Si se está presionando en otra parte
      if (seleccionado != null) {  //Si ya fue seleccionada una casilla
        this.tarjeta.presionar();
      }
      // Acción de los botones ------------------------------------------------------------- |Para hacer|
    }
  }
}


/*
|====================================================================|
*                          |Negociaciones|
* Descripción:                                                        
*    Botones: 
*      - Propiedades [menu_seleccion]: se mostrará una lista de jugadores los cuales se podrán seleccionar
*      - Lista de jugadores:
*        - Ver propiedades: Permite observar las propiedades del jugador seleccionado
*      - Seleccionar jugador:
*        - Vender: Teniendo una propiedad seleccionada le propones una oferta al jugador seleccionado
*      - Devolverse: Devuelve al menú principal
|====================================================================|
*/
class Negociaciones {
  Menu_seleccion negocios;    //Menu de selección (lista de jugadores)
  Casilla propiedad;          //Casilla a vender (si es seleccionada una)
  Jugador seleccionado;       //Jugador seleccionado
  
  Boton propiedades;          //Botón para ver las propiedades del jugador seleccionado
  Boton vender;               //Botón para proponerle una venta a un jugador
  
  Negociaciones (Casilla propiedad) {
    this.propiedades = new Boton ((3*width)/5 + (5*(2*width)/5)/13, (7*height)/8, 3*((2*width)/5)/13, height/12);
    this.vender = new Boton ((3*width)/5 + (5*(2*width)/5)/13, (7*height)/8, 3*((2*width)/5)/13, height/12);
    this.negocios = new Menu_seleccion (0, 0, 3*width/5, height, 2);
    this.propiedad = propiedad;
      
    //Cargar jugadores como ventanas
    Lista_Jugadores temp = jugadores;
    if (temp != null) {      //Si los jugadores ya están cargados
      //Ingresar jugadores en el menú
      do {
        this.negocios.añadir_carp(temp.jugador);
        temp = temp.siguiente;
      } while (temp != jugadores);
    }
  }
  
  
  void mostrar () {
    this.negocios.mostrar();
    if (archivador == null)
      rect (3*width/5, 0, 2*width/5, height);
    
    if (this.propiedad != null) {    //Si se está seleccionando un jugador para vender
      this.vender.mostrar();
    } else {
      this.propiedades.mostrar();
    }
    
    propiedades.mostrar();
    if (seleccionado != null) {
      fill(255);
      textSize (30);
      textAlign(CENTER);
      text (seleccionado.nombre, (1200*width)/1920, (60*height)/1080, (461*width)/1920, (50*height)/1080);
      String info = "Saldo del jugador: " + seleccionado.saldo;
      if (seleccionado.tipo == 1)
        info = info + "\n Tipo de Jugador: Humano";
      else
        info = info + "\n Tipo de Jugador: Máquina";
        
      if (seleccionado.estado == 1)
        info = info + "\n Estado del Jugador: Libre";
      else if (seleccionado.estado == 2)
        info = info + "\n Estado del Jugador: Preso";
      else if (seleccionado.estado == 3)
        info = info + "\n Estado del Jugador: Bancarrota";
      
      info = info + "\n Ubicación: " + seleccionado.posicion.casilla.nombre;
      info = info + "\n Correos en espera: " + seleccionado.interfaz.contar_ventanas();
      textAlign(LEFT);
      text (info, (1200*width)/1920, (550*height)/1080, (461*width)/1920, (300*height)/1080);
      fill(255);
      
      PImage ficha_sl = loadImage(seleccionado.ficha + ".png");
      if (ficha_sl != null)
        image (ficha_sl, (1300*width)/1920, (150*height)/1080, (350*width)/1920, (350*height)/1080);
    }
  }
  
  
  void presionar () {
    Capsula_CJ temp = this.negocios.presionar();
    
    if (temp != null) {  //Si se está seleccionando un jugador  
      this.seleccionado = temp.jugador;
    } else {             //Si se presiona en otra parte
      // Acción de los botones ------------------------------------------------------------- |Para hacer|
    }
  }
}


/*
|====================================================================|
*                             |Cartera|
* Descripción:                                                        
*   Permite visualizar la cantidad de dinero y billetes que cuenta el jugador
|====================================================================|
*/
class Cartera {
}
