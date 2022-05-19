/*
|----------------------------//----------------------------|
|  Página Secundaria - Funcionamiento de los Jugadores     |
|----------------------------//----------------------------|
*/


/*
|====================================================================|
*                              |Jugador|
* Descripción:                                                        
*   Contenedor de la información de los jugadores
*   Ejecuta las diferentes acciones que puede desarrollar un jugador
*   Puede ser humano o máquina, dependiendo de su tipo tendrá¨
*   un objeto de la clase correspondiente
|====================================================================|
*/
class Jugador {
  String nombre;               //Nombre del jugador
  String ficha;                //Ficha del jugador
  int tipo;                    //Tipo de jugador: [1] humano | [2] máquina
  int saldo;                   //Saldo del jugador
  Lista_casillas propiedades;  //Propiedades del jugador
  Lista_casillas posicion;     //Posición del jugador
  int estado;                  //Estado del jugador: [1] libre | [2] preso | [3] bancarrota
  Humano interfaz;             //Contenedor de la interfaz de usuario del jugador humano
  Maquina IA;                  //Contenedor de la información interna manejada por cada jugador-máquina
  
  
  void generar_jugador (String nombre, int color_ficha, int figura_ficha, int tipo, Lista_casillas posicion) {
    this.nombre = nombre;
    this.ficha = "figura_jugador_" + figura_ficha + "-" + color_ficha;
    this.tipo = tipo;
    this.saldo = 1500;
    this.propiedades = null;
    this.posicion = posicion;
    this.estado = 1;
    
    //Creación de contenedores según tipo de jugador
    if (tipo == 1){  //Si es humano
      Humano interfaz = new Humano ();
      this.interfaz = interfaz;
      this.IA = null;  
    } else {         //Si es máquina
      Maquina IA = new Maquina ();
      this.IA = IA;
      this.interfaz = null;
    }
  }
  
  
  /*
  ----------------------------|Subrutina para Movimiento|----------------------------
  Ejecuta la acción que sea necesaria al momento de caer en una determinada posición
  */
void mover (Lista_casillas posicion) {
    if (this.estado == 1){  //Si el jugador está libre
      this.posicion = posicion;
      Casilla casilla = posicion.casilla;
      
      switch (casilla.tipo){  //Accionar según tipo de casilla
        case 1:  //Propiedad
          if (casilla.propietario == null) {  //Si no tiene dueño
            this.comprar(casilla, casilla.valor);
          } else {                             //Si tiene dueño
            this.pagar(casilla.calcular_renta());
          }
          break;
        case 2:  //Servicio
          if (casilla.propietario == null) {  //Si no tiene dueño
            this.comprar(casilla, casilla.valor);
          } else {                             //Si tiene dueño
            this.pagar(casilla.calcular_renta());
          }
          break;
        case 3:  //Inicio
          this.saldo = this.saldo + 200;
          break;
        case 4:  //Especial
          switch (this.propiedades.casilla.efecto) {  //Dependiendo del efecto de la casilla
            case 4:      //Si es una carta
              if (this.propiedades.casilla.propiedad_esp == 1) {    //Si es carta de suerte
                int accion = partida.lista_suerte.carta.accion;
                int efecto = partida.lista_suerte.carta.efecto;
                int tipo_pago = partida.lista_suerte.carta.tipo_pago;
              } else {                                              //Si es carta de cofre
                int accion = partida.lista_cofre.carta.accion;
                int efecto = partida.lista_cofre.carta.efecto;
                int tipo_pago = partida.lista_cofre.carta.tipo_pago;
              }
              
              switch(accion){
                case 1:                                             //Sumar dinero al valor neto del jugador
                  jugadores.jugador.saldo = jugadores.jugador.saldo + efecto;
                  break;
                case 2:                                             //Restar dinero al valor neto del jugador
                  //[1][2]
                  switch(tipo_pago){
                    case 1:                                         //Pago directo 
                      jugadores.jugador.pagar(efecto);
                      break;
                    case 2:                                         //Pago por tipo y cantidad de propiedad
                      jugadores.jugador.pagar(efecto*(juego.cant_jug));
                      break;
                  }
                  break;
                  case 3:                                            //Moverse de casilla
                   // ----------------------------------------------------------- |Para hacer|
                  case 4:                                            //Conservar carta
                   // ----------------------------------------------------------- |Para hacer|
              }
              
              break;
          }
          break;
      }
      
      if (this.tipo == 2){  //Si el jugador es una máquina se evaluarán las posibilidades para vender u ofertar
        this.ofertar ();
        this.vender ();
      }
    }
  }
  
  
  /*
  ----------------------------|Subrutinas para Comprar|----------------------------
  Subrutina para redirigir una compra según el tipo de jugador
  ejecutar_compra(), subrutina para hacer efectiva la compra después de tomar una decisión
  ingresar la casilla y el precio al que la va a comprar ESTE jugador
  */
  void comprar (Casilla propiedad, int precio) {
    if (this.estado != 3){  //Si el jugador NO está en bancarrota
      boolean decision = false;  //Decisión tomada si desea comprar o no la propiedad
      
      if (this.tipo == 1){  //Si el jugador es humano
        interfaz.comprar (propiedad, precio);               //Manda la decisión a la cola del jugador
      } else {              //Si el jugador es la máquina
         if (precio >= this.saldo) {    //Si no puede comprar la propiedad
           decision = IA.comprar(this, propiedad, precio);  //Máquina determina si comprar o no la propiedad
           if (decision)
             ejecutar_compra(propiedad, precio);
         }
      }
    }
  }
  
  void ejecutar_compra (Casilla propiedad, int precio){
        this.pagar(precio);     //Pagar propiedad
        
        if (propiedad.propietario != null) {  //Si existe un propietario
          propiedad.propietario.saldo = propiedad.propietario.saldo + precio;      //Recibir pago
          propiedad.propietario.propiedades.eliminar_propiedad(propiedad.nombre);  //Eliminar de inventario
        }
        
        propiedad.propietario = this;         //Cambiar propietario
        this.registrar_prop(propiedad);       //Registrar en inventario
           
        println("Comando [Jugador]: Registrada la compra de propiedad " + propiedad.nombre + " por $" + precio);
        println("Comando [Jugador]: Nuevo saldo " + this.saldo);
  }
  
  
  /*
  ----------------------------|Subrutinas para Vender|----------------------------
  Subrutina para redirigir una venta según el tipo de jugador
  ejecutar_venta(), subrutina para hacer efectiva la venta después de tomar una decisión
  ingresar Jugador que va a comprar la propiedad, la propiedad en cuestión y su precio
  */
  void prop_venta (Jugador jugador, Casilla propiedad, int precio){
    if (this.estado != 3){  //Si el jugador NO está en bancarrota
      boolean decision = false;  //Decisión tomada si desea vender o no la propiedad
      
      if (this.tipo == 1){  //Si el jugador es humano
        interfaz.vender_propiedad(jugador,propiedad, precio);        //Manda la decisión a la cola del jugador
      } else {              //Si el jugador es la máquina
        decision = IA.vender_propiedad(jugador, propiedad, precio);  //Máquina determina si vender o no la propiedad
       if (decision)       //Si se va a vender la propiedad
         ejecutar_venta(jugador,propiedad, precio);
      }
    }
  }
  
  void ejecutar_venta (Jugador jugador, Casilla propiedad, int precio) {
    jugador.pagar(precio);                   //Pagar propiedad
    this.saldo = this.saldo + precio;        //Recibir pago
    
    //Traspaso de Escrituras
    propiedad.propietario = jugador;
    this.propiedades = this.propiedades.eliminar_propiedad(propiedad.nombre);
    
    //Actualización de inventarios
    this.propiedades = this.propiedades.eliminar_propiedad(propiedad.nombre);
    jugador.registrar_prop(propiedad); 
  }
  
  
  //----------------------------|Subrutina para Ofertar|----------------------------
  void ofertar () {
    if (this.estado != 3) {  //Si el jugador NO está en bancarrota
      if (this.tipo == 1) {  //Si el jugador es humano
        interfaz.ofertar (this);
      } else {              //Si el jugador es la máquina
        IA.ofertar (this);
      }
    }
  }
  
  
  //----------------------------|Subrutina para Registrar una propiedad|----------------------------
  void registrar_prop (Casilla propiedad) {
    if (this.propiedades == null)  //Si NO tiene propiedades
      this.propiedades = new Lista_casillas (propiedad);
    else                           //Si tiene propiedades
      this.propiedades = this.propiedades.añadir_propiedad (propiedad);
  }
  
  
  //----------------------------|Subrutina para Vender|----------------------------
  void vender () {
    if (this.estado != 3) {  //Si el jugador NO está en bancarrota
      if (this.tipo == 1) {  //Si el jugador es humano
        interfaz.vender (this);
      } else {              //Si el jugador es la máquina
        IA.vender (this);
      }
    }
  }
  
  
  //----------------------------|Subrutina para Pagar|----------------------------
  void pagar (int valor) {
    this.saldo = this.saldo - valor;  //Ejecutar pago
    
    if (this.saldo < 0) {    //Si se entra en deuda
      this.estado = 3;           //Jugador entra en bancarrota
    }
  }
  
  //----------------------------|Subrutina para Calcular Posición|----------------------------
  void coordenadas_jug (float x, float y) {
    int pos = this.posicion.casilla.num;
    if (pos >= 1 && pos <= 10) {          //Primera línea: horizontal inferior
      x = pos * (motor.MV_x/11);
      y = motor.MV_y/11;
    } else if (pos >= 11 && pos <= 20) {  //Segunda línea: vertical derecha
      x = 11 * (motor.MV_x/11);      
      y = (pos - 10) * (motor.MV_y/11);
    } else if (pos >= 21 && pos <= 30) {  //Tercera línea: horizontal su  perior
      x = pos * (motor.MV_x/11);
      y = 11 * (motor.MV_y/11);
    } else {                              //Cuarta línea: vertical izquierda
      x = motor.MV_x/11;
      y = (44 - pos) * (motor.MV_y/11);
    }
  }
}
