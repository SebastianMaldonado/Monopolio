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
  
  int ind;

  Ventana (int ind, float x, float y, float tx, float ty){
    this.ind = ind;
    this.x = x;
    this.y = y;
    this.tx = tx;
    this.ty = ty;
    this.decision = false;
  }
  
  
  //-------------------------|Sobre Caja|-------------------------//
  boolean sobre_caja (){
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
      }
    }
  }
  
  
  //-------------------------|Presionar Botones|-------------------------//
  //Botón para aceptar la solicitud y negarla
  void presionar () {
    this.decision = true;  //Cerrar Ventana
  }
  
  
  //-------------------------|Mostrar Ventana|-------------------------//
  void mostrar (){
    //Visualización de la pestaña
    rect (this.x, this.y, this.tx, this.ty);
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
  
  V_Anuncio (String mensaje, PImage imagen, int ind, float x, float y, float tx, float ty) {
    super(ind, x, y, tx, ty);
    this.mensaje = mensaje;
    this.imagen = imagen;
  }
  
  
  //-------------------------|Cerrar Ventana|-------------------------
  void aceptar () {
    if (mousePressed && this.sobre_caja()) {  //Si se presiona
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
  int precio;          //Precio de la propiedad a comprar
  
  V_Compra (Casilla propiedad, int precio, int ind, float x, float y, float tx, float ty) {
    super(ind, x, y, tx, ty);
    this.propiedad = propiedad;
    this.precio = precio;
  }
  
  
  //-------------------------|Aceptar compra|-------------------------//
  //Ejecutará la compra de la propiedad
  void aceptar () {
    if (mousePressed && this.sobre_caja()) {
      jugadores.jugador.ejecutar_compra(propiedad, precio);
    }
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
  Casilla propiedad;   //Propiedad a comprar
  int precio;          //Precio de la propiedad a comprar
  
  V_Venta (Jugador jugador, Casilla propiedad, int precio, int ind, float x, float y, float tx, float ty) {
    super(ind, x, y, tx, ty);
    this.jugador = jugador;
    this.propiedad = propiedad;
    this.precio = precio;
  }
  
  
  //-------------------------|Aceptar venta|-------------------------//
  //Ejecutará la venta de la propiedad
  void aceptar () {
    if (mousePressed && this.sobre_caja()) {
      jugadores.jugador.ejecutar_venta(jugador, propiedad, precio);
    }
  }
}
