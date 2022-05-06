/*
|----------------------------//----------------------------|
|  Página Secundaria - Funcionamiento de los Jugadores     |
|----------------------------//----------------------------|
*/


class Jugador{
  String nombre;          //Nombre del jugador
  String ficha;           //Ficha del jugador
  int tipo;               //Tipo de jugador: [1] humano | [2] máquina
  int saldo;              //Saldo del jugador
  Casilla propiedades;    //Propiedades del jugador
  Casilla posicion;       //Posición del jugador
  int estado;             //Estado del jugador: [1] libre | [2] preso | [3] bancarrota
  Humano interfaz;        //Contenedor de la interfaz de usuario del jugador humano
  Maquina IA;             //Contenedor de la información interna manejada por cada jugador-máquina
  
  
  void generar_jugador (String nombre, int color_ficha, int figura_ficha, int tipo, Casilla posicion) {
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
  
  
  //----------------------------|Subrutina para Movimiento|----------------------------
  void mover (Casilla posicion) {
    if (this.estado == 1){  //Si el jugador está libre
      this.posicion = posicion;
      
      switch (posicion.tipo){  //Accionar según tipo de casilla
        case 1:  //Propiedad
          if (posicion.propietario == null) {  //Si no tiene dueño
            this.comprar(posicion, posicion.valor);
          } else {                             //Si tiene dueño
            this.pagar(posicion.calcular_renta());
          }
          break;
        case 2:  //Servicio
          if (posicion.propietario == null) {  //Si no tiene dueño
            this.comprar(posicion, posicion.valor);
          } else {                             //Si tiene dueño
            this.pagar(posicion.calcular_renta());
          }
          break;
        case 3:  //Inicio
          this.saldo = this.saldo + 200;
          break;
        case 4:  //Especial
          //-------------------------------------------------------------------------------------------------|Para hacer|
          break;
      }
      
      if (this.tipo == 2){  //Si el jugador es una máquina se evaluarán las posibilidades para vender u ofertar
        this.ofertar ();
        this.vender ();
      }
    }
  }
  
  
  //----------------------------|Subrutinas para Comprar|----------------------------
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
        this.saldo = this.saldo - precio;
        propiedad.propietario = this;
        this.propiedades = this.propiedades.añadir_propiedad (propiedad);
  }
  
  
  //----------------------------|Subrutinas para Vender|----------------------------
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
  
  void ejecutar_venta (Jugador jugador, Casilla propiedad, int precio){
    this.saldo = this.saldo + precio;
    jugador.saldo = jugador.saldo - precio;
    
    if (propiedad.propietario != null)
      propiedad.propietario.saldo = propiedad.propietario.saldo + precio;
    
    propiedad.propietario = jugador;
    this.propiedades = this.propiedades.eliminar_propiedad(propiedad.nombre);
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
    //-------------------------------------------------------------------------------------------------|Para hacer|
  }
  
  //----------------------------|Subrutina para Calcular Posición|----------------------------
  void coordenadas_jug (float x, float y) {
    int pos = this.posicion.num;
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
