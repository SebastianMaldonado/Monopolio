/*
|------------------------------//------------------------------|
|  Página Secundaria - Objetos utilizados en la Interfaz       |
|------------------------------//------------------------------|
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
  int x, y;              //Posición del botón
  int vx, vy;            //Posición virtual del botón (para movimiento del botón)
  int tx, ty;            //Tamaño del botón
  PImage imagen;         //Imagen para mostrar
  
  Boton (int x, int y, int tx, int ty) {
    this.x = x;
    this.y = y;
    this.vx = x;
    this.vy = y;
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
    if ((mouseX > this.vx) && (mouseX < this.vx + this.tx) && (mouseY > this.vy) && (mouseY < this.vy + this.ty)) {
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
  
  
  void presionar () {
    if (this.sobre_boton())
      println("Presionado Botón");
  }
}


/*
|====================================================================|
*                        |Botón de Casilla|
*                       [Clase hija de Botón]
* Descripción:                                                        
*   Botón para desarrollar en interfaz que permite contener 
*   la información de una casilla y devolverla cuando sea presionado
|====================================================================|
*/
class Carpeta_casilla extends Boton {
  Casilla dato;  //Información de la casilla que contiene
  
  Carpeta_casilla (Casilla casilla, int x, int y, int tx, int ty) {
    super (x, y, tx, ty);
    this.dato = casilla;
  }
  
  
  //-------------------------|Mostrar|-------------------------//
  void mostrar (int op_x, int op_y) {
    super.mostrar(op_x, op_y);
    //Mostrar el resto de información del Jugador
    
    fill(0);
    textAlign(CENTER);
    textSize(20);
    text(this.dato.nombre, op_x, op_y + this.ty/5, this.tx, this.ty);
    fill(255);  
  }
  
  
  //-------------------------|Presionar|-------------------------//
  //Devuelve la información de la casilla que contiene
  void presionar () {
    if (this.sobre_boton())
      println(this.dato.nombre);
  }
}


/*
|====================================================================|
*                         |Botón de Jugador|    
*                       [Clase hija de Botón]
* Descripción:                                                        
*   Botón para desarrollar en interfaz que permite contener 
*   la información de un jugador y devolverla cuando sea presionado
|====================================================================|
*/
class Carpeta_jugador extends Boton {
  Jugador dato;
  
  Carpeta_jugador (Jugador jugador, int x, int y, int tx, int ty) {
    super (x, y, tx, ty);
    this.dato = jugador;
  }
  
  
  //-------------------------|Mostrar|-------------------------//
  void mostrar (int op_x, int op_y) {
    super.mostrar(op_x, op_y);
    //Mostrar el resto de información del Jugador
    
    fill(0);
    textAlign(CENTER);
    textSize(20);
    text(this.dato.nombre, op_x, op_y + this.ty/5, this.tx, this.ty);
    fill(255);  
  }
  
  
  //-------------------------|Presionar|-------------------------//
  //Devuelve la información de la casilla que contiene
  void presionar () {
    if (this.sobre_boton())
      println(this.dato.nombre);
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
class Menu_seleccion {
  int x, y;            //Posición del menú
  int tx, ty;          //Tamaño del menú
  int pos;             //Posición virtual del menú
  int tm_v;            //Tamaño virtual del menú (acumulado de las carpetas)
  int cant_carp;       //Cantidad de carpetas contenidas
  int tipo;            //[1] para contener casillas | [2] para contener jugadores
  boolean pres;        //Para mantener presionados los botones de subir/bajar
  Boton subir, bajar;  //Botones para subir y bajar la casilla
  Boton[] lista;       //Contenedor de los botones a mostrar
  
  Menu_seleccion (int x, int y, int tx, int ty, int tipo) {
    this.x = x;
    this.y = y;
    this.tx = tx;
    this.ty = ty;
    this.pres = false;
    this.pos = 0;
    this.cant_carp = 0;
    this.tipo = tipo;  
    this.subir = new Boton (tx - this.ty/8, 0, this.ty/8 ,this.ty/8);
    this.bajar = new Boton (tx - this.ty/8, ty - this.ty/8, this.ty/8 ,this.ty/8);
    //************[Nota de Desarrollador]************//
    //Cambiar cantidad de posiciones del vector según necesidad del usuario
    this.lista = new Boton [50];  
  }
  
  
  //-------------------------|Añadir casilla|-------------------------//
  //Añadir un nueva casilla a la lista, se detendrá si el menú no contiene casillas
  void añadir_carp (Casilla casilla) {
    if (this.tipo != 1) {  //Si el menú NO contiene casillas
      return;
    }
    
    Carpeta_casilla carpeta = new Carpeta_casilla (casilla, this.x, tm_v, 5*this.tx/6, this.ty/5);
    
    carpeta.y = tm_v;
    this.cant_carp = this.cant_carp + 1;
    this.lista[this.cant_carp] = carpeta;
    this.tm_v = this.tm_v + carpeta.ty;
  }
  
  
  //-------------------------|Añadir jugador|-------------------------//
  //Añadir un nuevo jugador a la lista, se detendrá si el menú no contiene jugadores
  void añadir_carp (Jugador jugador) {
    if (this.tipo != 2) {  //Si el menú NO contiene jugadores
      return;
    }
    
    Carpeta_jugador carpeta = new Carpeta_jugador (jugador, this.x, tm_v, 5*this.tx/6, this.ty/5);
    
    carpeta.y = tm_v;
    this.cant_carp = this.cant_carp + 1;
    this.lista[this.cant_carp] = carpeta;
    this.tm_v = this.tm_v + carpeta.ty;
    
  }
  
  
  //-------------------------|Mostrar Carpetas|-------------------------//
  void mostrar () {
    if ((this.tipo != 1) && (this.tipo != 2))  //Si el menú NO contiene datos aceptados
      return;
    
    rect (this.x, this.y, this.tx, this.ty);
    subir.mostrar();
    bajar.mostrar();
    this.desplazar();
    
    for (int i = 1; i <= this.cant_carp; i++) {
      if (carpeta_aparece(this.lista[i].vy, this.lista[i].ty)) {  //Si la carpeta aparece en la lista
        this.lista[i].mostrar(this.x, this.lista[i].vy);    //--------------------------------------------------------- |Para hacer|
      }
    }
  }
  
  
  //-------------------------|Desplazar Posición|-------------------------//
  void desplazar () {
    if (!mousePressed)  //Si NO se presiona el ratón
      return;
    
    boolean presionado = false;
    
    if (this.subir.sobre_boton()) {         //Si se presiona el botón de SUBIR
      presionado = true;
      
      if (this.pos - 3 <= 0) {                     //Si se pasa del borde
        this.pos = 0;
      } else {                                     //Si NO se pasa del borde
        this.pos = this.pos - 3;
      }
    } else if (this.bajar.sobre_boton()) {  //Si se presiona el botón de BAJAR
      presionado = true;
      
      if (this.pos + this.ty + 3 >= this.tm_v) {   //Si se pasa del borde 
        this.pos = this.tm_v - this.ty;
      } else {                                     //Si NO se pasa del borde
        this.pos = this.pos + 3;
      }
    } else {                                //Si NO se presionó ningún botón
      return;
    }
    
    if (presionado) {  //Si se movió el mapa
      //Actualizar posición virtual de los botones
      for (int i = 1; i <= this.cant_carp; i++) {
        this.lista[i].vy = this.lista[i].y - this.pos;
      }
    }
  }
  
  
  //-------------------------|Presionar un Botón|-------------------------//
  //Evaluar qué botón fue presionado
  void presionar () {
    for (int i = 1; i <= this.cant_carp; i++) {
      this.lista[i].presionar();
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


/*
|=====================================================================|
*                         |Tarjeta interactiva|   
*                         [Clase Hija de Botón]
* Descripción:                                                        
*  Contenedor de todos los objetos de tipo carpeta
*  Muestra todos los botones en forma de una lista con desplazamiento
|====================================================================|
*/
class Tarjeta_itr extends Boton {
  PImage reverso;     //Imagen del reverso de la tarjeta
  boolean lado;       //Determina el lado de la tarjeta [verdadero] frente | [falso] reverso
  boolean girando;    //Booleano para saber si la casilla está girando
  int rotacion;       //Rotación de la tarjeta
  
  //Variables temporales de movimiento
  int mitad_carta;    //Valor de la mitad del tamaño de la carta
  int mov_x;          //Movimiento en x
  boolean mover_x;    //Activar desplazamiento en x
  int giro_x;         //Valor del nuevo tamaño de la carta
  boolean girar;      //Activar reducción del tamaño en x
  boolean voltear;    //Cambio de imagen al voltear la tarjeta
  
  Tarjeta_itr (PImage imagen, PImage reverso, int x, int y, int tx, int ty) {
    super (x, y, tx, ty);
    this.imagen = imagen;
    this.reverso = reverso;
    this.rotacion = 0;
    this.lado = true;
    this.girando = false;
    this.mov_x = 0;
    this.giro_x = tx;
    this.girar = false;
    this.voltear = false;
  }
  
  
  //-------------------------|Mostrar Tarjeta|-------------------------//
  void mostrar () {    
    if (!girando) {      //Si la tarjeta NO está girando
      if ((this.imagen == null) || (this.reverso == null)) {    //Si las imágenes NO están cargadas
        rect(this.vx, this.vy, this.tx, this.ty);
      } else {                                                  //Si las imágenes están cargadas
        if (lado)      //Si está del lado delantero
          image (this.imagen, this.vx, this.vy, this.tx, this.ty);
        else           //Si está en el reverso
          image (this.reverso, this.vx, this.vy, this.tx, this.ty);
      }
    } else {             //Si la tarjeta está girando
      //Moverse en x
      if ((this.mov_x < this.mitad_carta) && (this.mover_x))  {  //Llegar hasta la mitad
        this.mov_x = this.mov_x + 2;
      } else if (this.mover_x) {  //Si llegó a la mitad
        this.mitad_carta = 0;
        this.mov_x = this.mov_x - 2;
        
        if (this.mov_x <= 0) {  //Si terminó el recorrido
          this.mov_x = 0;
          this.mover_x = false;
        }
      }
      
      this.vx = this.vx + this.mov_x;
        
      //Girar carta    
      if ((this.giro_x > 0) && (girar)) {  //Reducir a 0 el tamaño
        this.giro_x = this.giro_x - 4;
        voltear = true;
      } else {                             //Si se redujo a 0
        //Cambiar lado
        if (lado && voltear) {
          this.lado = false;
          voltear = false;
        } else if (voltear) {
          this.lado = true;
          voltear = false;
        }
        
        this.girar = false;
          
        if (this.giro_x < this.tx)
          this.giro_x = this.giro_x + 4;
      }

      //Visualizar tarjeta
      if ((this.imagen == null) || (this.reverso == null)) {    //Si las imágenes NO están cargadas
        if (lado) {
          fill(255);
          rect(this.vx, this.vy, this.giro_x, this.ty);
        } else {
          fill(#F02929);
          rect(this.vx, this.vy, this.giro_x, this.ty);
          fill(255);
        }
      } else {                                                  //Si las imágenes están cargadas
        if (lado)      //Si está del lado delantero
          image (this.imagen, this.vx, this.vy, this.giro_x, this.ty);
        else           //Si está en el reverso
          image (this.reverso, this.vx, this.vy, this.giro_x, this.ty);
      }
    
      this.rotacion = this.rotacion + 5;
    }
  }
  
  //-------------------------|Presionar Tarjeta|-------------------------//
  //Permite girar la tarjeta
  void presionar () {
    if (this.sobre_boton()) {
      this.mitad_carta = this.tx / 2;
      this.mover_x = true;
      this.girando = true;
      this.girar = true;
    }
  }
}
