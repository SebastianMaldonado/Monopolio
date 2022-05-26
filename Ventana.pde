/*
|----------------------------//----------------------------|
|  Página Secundaria - Ventanas Interactivas               |
|----------------------------//----------------------------|
*/


/*
|====================================================================|
*                              |Ventana|
*                            [Clase Padre]
* Descripción:                                                        
*   Ventana que permite visualizar información
*   Al presionarla sobre un área es posible desplazarla
*   Una vez tomada una decision la ventana dejará de visualizarse
*   y se borrará a la siguiente iteración del algoritmo
|====================================================================|
*/
class Ventana {
  float x;                      //Posición en x
  float y;                      //Posición en y
  float tx;                     //Tamaño en x
  float ty;                     //Tamaño en y
  float x_margen =  0.0;        //Margen en x
  float y_margen =  0.0;        //Margen en y
  boolean sobre_caja = false;   //Booleano para saber si el ratón está sobre la caja
  boolean mov = false;          //Booleano para saber si se está moviendo
  boolean mouse_tm = false;     //Booleano para seleccionar la caja con un solo click
  boolean decision;             //Booleano para cerrar la ventana
  PImage img;                   //Imagen de la ventana
  Boton aceptar;                //Botón para aceptar la información de la ventana
  Boton cancelar;               //Botón para cancelar la información de la ventana
  
  Ventana (PImage img, float x, float y, float tx, float ty) {
    this.img = img;
    this.x = x;
    this.y = y;
    this.tx = tx;
    this.ty = ty;
    this.decision = false;
    this.aceptar = new Boton (int((tx/9) + x), int((ty - ty/5) + y), int(3*tx/9), int(ty/10));
    this.cancelar = new Boton ( + int((5*tx/9) + x), int((ty - ty/5) + y), int(3*tx/9), int(ty/10));
  }
  
  
  //-------------------------|Sobre Caja|-------------------------//
  boolean sobre_caja () {
    if ((mouseX > this.x) && (mouseX < this.x + this.tx) && (mouseY > this.y) && (mouseY < this.y + this.ty)) {
      return true;    //Si el cursor está por encima de la ventana
    } else {
      return false;   //Si el cursor NO está por encima de la ventana
    }
  }
  
  
  //-------------------------|Mover Ventana|-------------------------//
  void mover () {

    this.sobre_caja = this.sobre_caja();   //Booleano para saber si el ratón está sobre la ventana
    
    //Si el cursor está por encima de la ventana
    if (this.sobre_caja){
      if(!this.mov) {  //Si la caja no se está moviendo
      }
    } else {  //Si el cursor NO está por encima de la ventana
    }
    
    if ((mousePressed) && (!this.mouse_tm)){    //Presionar caja
      if(this.sobre_caja) {  //Activar movimiento
        this.mov = true; 
      } else {
        this.mov = false;
      }   
      
      //Generar márgenes
      this.x_margen = mouseX - this.x;
      this.y_margen = mouseY - this.y; 
        
      this.mouse_tm = true;     
    }

    if (!mousePressed) {
      this.mouse_tm = false;
    }

    if (mouseDragged) {                         //Mantenerla presionada
      if(this.mov) {
        this.x = mouseX - this.x_margen; 
        this.y = mouseY - this.y_margen; 
        
        //Desplazar Botones
        this.aceptar.vx = int((this.tx/9) + this.x);
        this.aceptar.vy = int((this.ty - this.ty/5) + this.y);  
        this.cancelar.vx = int((5*this.tx/9) + this.x);
        this.cancelar.vy = int((this.ty - this.ty/5) + this.y);  
      }
    }
  }
  
  
  //-------------------------|Presionar Botones|-------------------------//
  //Botón para aceptar la solicitud y negarla
  void presionar () {
    this.decision = true;  //Cerrar Ventana
  }
  
  
  //-------------------------|Mostrar Ventana|-------------------------//
  void mostrar () {
    //Visualización de la pestaña
    if (this.img == null) {
      rect (this.x, this.y, this.tx, this.ty);
      this.cancelar.mostrar(this.cancelar.vx, this.cancelar.vy);
      this.aceptar.mostrar(this.aceptar.vx, this.aceptar.vy);
    } else {
      image (this.img, this.x, this.y, this.tx, this.ty);
    }
  }
  
  //-------------------------|Botón de Aceptar|-------------------------//
  void aceptar () {
    println("Ventana: Objeto Vacío");
  }
}


/*
|====================================================================|
*                        |Ventana de Anuncio|                        
* Descripción:                                                        
*   Ventana para visualizar un anuncio de alguna acción ejecutada
*   Se cerrará al presionar sobre la ventana
|====================================================================|
*/
class V_Anuncio extends Ventana {
  String mensaje;    //Mensaje del anuncio
  PImage imagen;     //Imagen del anuncio
  
  V_Anuncio (String mensaje, PImage imagen, float x, float y, float tx, float ty) {
    super(null, x, y, tx, ty);
    this.mensaje = mensaje;
    this.imagen = imagen;
  }
  
  
  //-------------------------|Mostrar Ventana|-------------------------//
  void mostrar () {
    if (this.imagen == null)
      rect (this.x, this.y, this.tx, this.ty);
    else
      image (this.imagen, this.x, this.y, this.tx, this.ty);
      
    fill (0);
    textSize((25*width)/1920);
    textAlign(CENTER);
    text (this.mensaje, this.x + this.tx/5, this.y + this.ty/8, this.tx*3/5, this.ty*6/8);
    fill (255);
  }
  
  
  //-------------------------|Cerrar Ventana|-------------------------//
  void aceptar () {
    if (this.sobre_caja()) {  //Si se presiona
      this.decision = true;  //Cerrar ventana
    }
  }
}


/*
|====================================================================|
*                        |Ventana de Compra|                        
* Descripción:                                                        
*   Mostrará la información de la propuesta de una compra al jugador
*   Permitirá presionar las dos opciones:
*   [Aceptar] para ejecutar la orden | [Cancelar] para negarla
*   La ventana se cerrará después de presionar uno de los botones
|====================================================================|
*/
class V_Compra extends Ventana {
  Casilla propiedad;   //Propiedad a comprar
  Tarjeta_itr tarjeta; //Tarjeta de la propiedad
  int precio;          //Precio de la propiedad a comprar
  
  V_Compra (Casilla propiedad, int precio, float x, float y, float tx, float ty) {
    super(loadImage("Carta.png"), x, y, tx, ty);
    this.propiedad = propiedad;
    this.precio = precio;
    this.tarjeta = new Tarjeta_itr (propiedad.frente, propiedad.reverso, int(tx/8 + x), int(ty/40 + y), int(6*tx/8), int(6*ty/8));
  }
  
  
  //-------------------------|Aceptar compra|-------------------------//
  //Ejecutará la compra de la propiedad
  void aceptar () {
    if (this.sobre_caja() && !decision)
      this.tarjeta.presionar();
    if (this.cancelar.sobre_boton() && !decision) {  //Compra Cancelada
      this.decision = true;
      return;
    }
    if (this.aceptar.sobre_boton() && !decision) {    //Compra realizada
      this.decision = true;
      jugadores.jugador.ejecutar_compra(propiedad, precio);
    }
  }
  
  //-------------------------|Mostrar Ventana|-------------------------//
  void mostrar () {
    //println("mostrando compra");
    super.mostrar();
    this.tarjeta.vx = int(this.tx/8 + this.x);
    this.tarjeta.vy = int(this.ty/40 + this.y);
    this.tarjeta.mostrar();
  }
  
  
  //-------------------------|Mover Ventana|-------------------------//
  void mover () {
    super.mover();
  }
}


/*
|====================================================================|
*                        |Ventana de Venta|                        
* Descripción:                                                        
*   Mostrará la información de la propuesta de una venta al jugador
*   Permitirá presionar las dos opciones:
*   [Aceptar] para ejecutar la orden | [Cancelar] para negarla
*   La ventana se cerrará después de presionar uno de los botones
|====================================================================|
*/
class V_Venta extends Ventana {
  Jugador jugador;     //Jugador que ejecutará la acción
  Tarjeta_itr tarjeta; //Tarjeta de la propiedad
  Casilla propiedad;   //Propiedad a comprar
  int precio;          //Precio de la propiedad a comprar
  
  V_Venta (Jugador jugador, Casilla propiedad, int precio, float x, float y, float tx, float ty) {
    super(loadImage("Carta.png"), x, y, tx, ty);
    this.jugador = jugador;
    this.propiedad = propiedad;
    this.precio = precio;
    this.tarjeta = new Tarjeta_itr (propiedad.frente, propiedad.reverso, int(tx/8 + x), int(ty/40 + y), int(6*tx/8), int(6*ty/8));
  }
  
  
  //-------------------------|Aceptar venta|-------------------------//
  //Ejecutará la venta de la propiedad
  void aceptar () {
    if (this.sobre_caja() && !decision)
      this.tarjeta.presionar();
    if (this.cancelar.sobre_boton() && !decision) {  //Venta Cancelada
      this.decision = true;
      return;
    }
    if (this.aceptar.sobre_boton() && !decision) {  //Venta realizada
      this.decision = true;
      jugadores.jugador.ejecutar_venta(jugador, propiedad, precio);
    }
  }
  
  
  //-------------------------|Mostrar Ventana|-------------------------//
  void mostrar () {
    super.mostrar();
    this.tarjeta.vx = int(this.tx/8 + this.x);
    this.tarjeta.vy = int(this.ty/40 + this.y);
    this.tarjeta.mostrar();
  }
  
  
  //-------------------------|Mover Ventana|-------------------------//
  void mover () {
    super.mover();
  }
}

 
/*
|====================================================================|
*                      |Contenedor de Ventana|                        
* Descripción:                                                        
*   Permite unificar las tres clases de ventanas en una misma clase
*   Por medio de su constructor se especifica qué clase será
*   La variable tipo señala explícitamente qué tipo de ventana es
|====================================================================|
*/
class Cont_Ventana {
  Ventana ventana;  //Objeto contenedor de la Ventana y su respectiva acción
  int tipo;         //[1] Anuncio | [2] Compra | [3] Venta
  
  /* 
  ||===============================|Ventana de Anuncio|===============================||
  */ 
  Cont_Ventana (String mensaje, PImage imagen, float x, float y, float tx, float ty) {
    if (tipo != 0)
      return;
    
    this.tipo = 1;
    this.ventana = new V_Anuncio(mensaje, imagen, x, y, tx, ty);
  }
  
  /* 
  ||===============================|Ventana de Compra|===============================||
  */
  Cont_Ventana (Casilla propiedad, int precio, float x, float y, float tx, float ty) {
    if (tipo != 0)
      return;
    
    this.tipo = 1;
    this.ventana = new V_Compra(propiedad, precio, x, y, tx, ty);
  }
  
  /* 
  ||===============================|Ventana de Venta|===============================||
  */
  Cont_Ventana (Jugador jugador, Casilla propiedad, int precio, float x, float y, float tx, float ty) {
    if (tipo != 0)
      return;
    
    this.tipo = 1;
    this.ventana = new V_Venta(jugador, propiedad, precio, x, y, tx, ty);
  }
  
  
  //-------------------------|Aceptar Botón|-------------------------//
  void aceptar () {
    ventana.aceptar();
  }
  
  
  //-------------------------|Mover Ventana|-------------------------//
  void mover () {
    ventana.mover();
  }
  
  
  //-------------------------|Presionar Ventana|-------------------------//
  void presionar () {
    ventana.presionar();
  }
  
  
  //-------------------------|Mostrar Ventana|-------------------------//
  void mostrar () {
    ventana.mostrar();
  }
  
  
  //-------------------------|Ratón sobre la caja|-------------------------//
  boolean sobre_caja () {
    return ventana.sobre_caja();
  }
}
