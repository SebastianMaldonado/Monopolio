/*
|-----------------------------//-----------------------------|
|  Página Secundaria - Objetos utilizados en la Interfaz     |
|-----------------------------//-----------------------------|
*/


/*
|====================================================================|
*                               |Botón|         
*                            [Clase Padre]
* Descripción:                                                        
*   Clase definida para crear una interfaz donde poder ejecutar una
*   acción al ser presionado, se puede mostrar y devuelve un booleano
*   al pasar el ratón sobre él
|====================================================================|
*/
class Boton {
  int x, y;         //Posición del botón
  int tx, ty;       //Tamaño del botón
  PImage imagen;    //Imagen para mostrar
  
  Boton (int x, int y, int tx, int ty) {
    this.x = x;
    this.y = y;
    this.tx = tx;
    this.ty = ty;
  }
  
  
  //-------------------------|Ingresar imagen|-------------------------//
  void Ingresar_imagen (PImage imagen) {
    if (imagen != null)
      this.imagen = imagen;
  }
  
  
  //-------------------------|Sobre Caja|-------------------------//
  boolean sobre_boton () {
    if ((mouseX > this.x) && (mouseX < this.x + this.tx) && (mouseY > this.y) && (mouseY < this.y + this.ty)) {
      return true;    //Si el cursor está por encima de la ventana
    } else {
      return false;   //Si el cursor NO está por encima de la ventana
    }
  }
  
  
  //-------------------------|Mostrar Botón|-------------------------//
  //Ingresar valores opciones para cargar una posición
  //No ingresar nada para ejecutarlo con la posición original del botón
  void mostrar () {
    if (this.imagen == null) {      //Si NO tiene una imagen
      rect (this.x, this.y, this.tx, this.ty);
    } else {                        //Si tiene una imagen
      image (this.imagen, this.x, this.y);
    }
  }
  
  void mostrar (int op_x, int op_y) {
    if (this.imagen == null) {      //Si NO tiene una imagen
      rect (op_x, op_y, this.tx, this.ty);
    } else {                        //Si tiene una imagen
      image (this.imagen, op_x, op_y);
    }
  }
}


/*
|====================================================================|
*                        |Botón de Casilla|                        
* Descripción:                                                        
*   Botón para desarrollar en interfaz que permite contener 
*   la información de una casilla y devolverla cuando sea presionado
|====================================================================|
*/
class Carpeta_casilla extends Boton {
  Casilla casilla;  //Información de la casilla que contiene
  
  Carpeta_casilla (Casilla casilla, int x, int y, int tx, int ty) {
    super (x, y, tx, ty);
    this.casilla = casilla;
  }
  
  
  //-------------------------|Mostrar|-------------------------//
  void mostrar () {
    super.mostrar();
    //Mostrar el resto de información del Jugador
  }
  
  
  //-------------------------|Presionar|-------------------------//
  //Devuelve la información de la casilla que contiene
  Casilla presionar () {
    if (this.sobre_boton())
      return this.casilla;
    else
      return null;
  }
}


/*
|====================================================================|
*                         |Botón de Jugador|                         
* Descripción:                                                        
*   Botón para desarrollar en interfaz que permite contener 
*   la información de un jugador y devolverla cuando sea presionado
|====================================================================|
*/
class Carpeta_jugador extends Boton {
  Jugador jugador;
  
  Carpeta_jugador (Jugador jugador, int x, int y, int tx, int ty) {
    super (x, y, tx, ty);
    this.jugador = jugador;
  }
  
  
  //-------------------------|Presionar|-------------------------//
  //Devuelve la información de la casilla que contiene
  Jugador presionar () {
    if (this.sobre_boton())
      return this.jugador;
    else
      return null;
  }
}


/*
|=====================================================================|
*                         |Menú de Selección|                         
* Descripción:                                                        
*  Contenedor de todos los objetos de tipo carpeta
*  Muestra todos los botones en forma de una lista con desplazamiento
|====================================================================|
*/
class menu_seleccion {
  int x, y;            //Posición del menú
  int tx, ty;          //Tamaño del menú
  int pos;             //Posición virtual del menú
  int tm_v;            //Tamaño virtual del menú (acumulado de las carpetas)
  int cant_carp;       //Cantidad de carpetas contenidas
  int tipo;            //[1] para contener casillas | [2] para contener jugadores
  
  Boton subir, bajar;  //Botones para subir y bajar la casilla
  
  Carpeta_jugador[] lista_jugadores;
  Carpeta_casilla[] lista_casillas;
  
  menu_seleccion (int x, int y, int tx, int ty, int tipo) {
    this.x = x;
    this.y = y;
    this.tx = tx;
    this.ty = ty;
    this.pos = 0;
    this.cant_carp = 0;
    this.tipo = tipo;
  }
  
  
  //-------------------------|Añadir casilla|-------------------------//
  //Añadir un nueva casilla a la lista, se detendrá si el menú no contiene casillas
  void añadir_carp (Carpeta_casilla carpeta) {
    if (this.tipo != 1) {  //Si el menú NO contiene casillas
      return;
    }
    
    carpeta.y = tm_v;
    this.cant_carp = this.cant_carp + 1;
    this.lista_casillas[this.cant_carp] = carpeta;
    this.tm_v = this.tm_v + carpeta.ty;
  }
  
  
  //-------------------------|Añadir jugador|-------------------------//
  //Añadir un nuevo jugador a la lista, se detendrá si el menú no contiene jugadores
  void añadir_carp (Carpeta_jugador carpeta) {
    if (this.tipo != 2) {  //Si el menú NO contiene jugadores
      return;
    }
    
    carpeta.y = tm_v;
    this.cant_carp = this.cant_carp + 1;
    this.lista_jugadores[this.cant_carp] = carpeta;
    this.tm_v = this.tm_v + carpeta.ty;
  }
  
  
  //-------------------------|Mostrar Carpetas|-------------------------//
  void mostrar () {
    if (this.tipo == 1) {                //Si el menú contiene casillas
      for (int i = 1; i <= this.cant_carp; i++) {
        if (carpeta_aparece(this.lista_casillas[i].y, this.lista_casillas[i].ty)) {  //Si la carpeta aparece en la lista
          int temp_y = this.lista_casillas[i].y - this.pos;  //Calcular posición relativa
          this.lista_casillas[i].mostrar(this.x, temp_y);    //--------------------------------------------------------- |Para hacer|
        }
      }
    } else if (this.tipo == 2) {         //Si el menú contiene jugadores
      for (int i = 1; i <= this.cant_carp; i++) {
        if (carpeta_aparece(this.lista_jugadores[i].y, this.lista_jugadores[i].ty)) {  //Si la carpeta aparece en la lista
          int temp_y = this.lista_casillas[i].y - this.pos;  //Calcular posición relativa
          this.lista_casillas[i].mostrar(this.x, temp_y);    //--------------------------------------------------------- |Para hacer|
        }
      }
    } else {                             //Si el menú NO contiene datos aceptados
      return;
    }
  }
  
  
  //-------------------------|Desplazar Posición|-------------------------//
  void desplazar () {
    if (this.subir.sobre_boton()) {         //Si se presiona el botón de SUBIR
      if (this.pos - 5 <= 0)           //Si se pasa del borde
        return;
      
      this.pos = this.pos - 5;
    } else if (this.bajar.sobre_boton()) {  //Si se presiona el botón de BAJAR
      if (this.pos + 5 <= this.tm_v)  //Si se pasa del borde
        return;
        
      this.pos = this.pos + 5;
    } else {                                //Si NO se presionó ningún botón
      return;
    }
  }
  
  
  //-------------------------|Aparecer en menú|-------------------------//
  //Si la carpeta aparece en el menú visible se retornará verdadero
  boolean carpeta_aparece (int y, int ty) {
    if ((ty > this.y) && (y < this.ty)) {  //Si aparece en la barra
      return true;
    } else {                               //Si no aparece en la barra
      return false;
    }
  }
}
