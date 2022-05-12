/*
|----------------------------------//----------------------------------|
|  Página Secundaria - Funcionamiento de la Interfaz para jugador      |
|----------------------------------//----------------------------------|
*/


class Humano {
  Lista_interfaz cola_acciones;//Lista de todas las decisiones pendientes por tomar
  
  Humano (){
    this.cola_acciones = new Lista_interfaz();
  }
  
  
  /*
  -----------------------------------|Función para acordar una compra|-----------------------------------
  Si al jugador se le es propuesto comprar una propiedad se ejecutará esta función
  Por medio de la interfaz esta función retornará la decision del jugador
  */
  void comprar (Casilla propiedad, int precio) {
    //menu = 8;  //Visualizar ventanas en cola
    
    //Crear interfaz y añadirla a la cola
    Ventana compra = new Ventana (2, 100, 100, 300, 600);
    this.cola_acciones.añadir_cola(compra, 0);
  }
  
  
  /*
  -----------------------------------|Función para acordar una venta|-----------------------------------
  Si al jugador se le es propuesto vender una de sus propiedades se ejecutará esta función
    por medio de la interfaz esta función retornará la decision del jugador
  La variable jugador contiene la información del jugador del que procede la oferta
    mientras que la variable propiedad contiene la propiedad que se propone vender y la variable precio, al precio propuesto
  */
  void vender_propiedad (Jugador jugador, Casilla propiedad, int precio) {
    menu = 8;  //Visualizar ventanas en cola
    
    //Crear interfaz y añadirla a la cola
    Ventana venta = new Ventana (3, 100, 100, 300, 600);
    this.cola_acciones.añadir_cola(venta, 0);
  }
  
  
  /*
  -----------------------------------|Procedimiento para ofertar|-----------------------------------
  Proponer acuerdo de compra de una propiedad perteneciente a otro jugador
  La variable ofertante contiene al jugador que propone el trato
  */
  void ofertar (Jugador ofertante) {
    int precio = 0;
    Jugador jugador = mostrar_jugadores (ofertante);              //Seleccionar Jugador al que ofertar sus propiedades
    
    Casilla propiedad = mostrar_propiedades (jugador);    //Seleccionar la propiedad del jugador seleccionado y el precio al que comprarla
    
    if (propiedad != null)
      jugador.prop_venta(ofertante, propiedad, precio);           //Proponer acuerdo al jugador seleccionado
  }
  
  
  /*
  -----------------------------------|Procedimiento para vender|-----------------------------------
  Proponer acuerdo de venta de una propiedad propia con otro jugador
  La variable ofertante contiene al jugador que propone el trato
  */
  void vender (Jugador vendedor) {
    int precio = 0;
    Casilla propiedad = mostrar_propiedades (vendedor);          //Seleccionar la propiedad a vender
    
    Jugador jugador = mostrar_jugadores (vendedor);              //Seleccionar jugador al que proponerle el trato
    
    if (propiedad != null)
      jugador.comprar(propiedad, precio);                        //Proponer acuerdo al jugador seleccionado
  }
  
  
  /*
  -----------------------------------|Función para seleccionar a un jugador|-----------------------------------
  Esta función servirá para retornar la información del jugador seleccionado por medio de la interfaz
  La variable jugador contiene al jugador humano que interactua con la interfaz, por lo que será el único que no se muestre
  */
  Jugador mostrar_jugadores (Jugador jugador) {
    return jugador;
  }
  
  
  /*
  -----------------------------------|Función para seleccionar a una propiedad|-----------------------------------
  Esta función servirá para retornar la información de la propiedad de un jugador por medio de la interfaz
  La variable jugador contiene la información del jugador del que se quiere seleccionar una propiedad
  */
  Casilla mostrar_propiedades (Jugador jugador) {
    Casilla propiedad = jugador.propiedades.casilla;
    return propiedad;
  }
}
