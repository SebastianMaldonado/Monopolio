/*
|----------------------------//----------------------------|
|  Página Secundaria - Funcionamiento de las listas        |
|----------------------------//----------------------------|
*/


/*
|====================================================================|
*                        |Lista de Casillas|
* Descripción:                                                        
*   Lista enlazada circular encargada de almacenar la información de las casillas 
|====================================================================|
*/
class Lista_casillas {
  Casilla casilla;            //Información de la Casilla
  Lista_casillas siguiente;   //Siguiente dirección del mapa
  
  Lista_casillas (Casilla casilla) {
    this.casilla = casilla;
    this.siguiente = this;
  }
  
  
  //----------------------------|Añadir elemento|----------------------------//
  Lista_casillas añadir_propiedad (Casilla propiedad){
    Lista_casillas lista = this;
    Lista_casillas nuevo = new Lista_casillas (propiedad);
    
    while (lista.siguiente != this) {
      lista = lista.siguiente;
    }
    
    lista.siguiente = nuevo;
    nuevo.siguiente = this;
    
    return nuevo.siguiente;
  }
    
  
  //----------------------------|Eliminar elemento|----------------------------//
  //Función para eliminar un elemento de la lista
  Lista_casillas eliminar_propiedad (String nombre){
    Lista_casillas lista = this;
    
    while (((lista.siguiente).casilla.nombre != nombre) && (lista.siguiente != this)){
      lista = lista.siguiente;
    }
    
    if ((lista.siguiente).casilla.nombre != nombre){  //Si se encontró
      if (lista.siguiente == this){             //Si la eliminación es el PTR
        lista.siguiente = this.siguiente;
        return lista;
      } else {                                  //Si la eliminación no es el PTR
        lista.siguiente = lista.siguiente.siguiente;
        return this;
      }
    } else {                                  //Si no se encontró
      return this;
    }
  }
  
  
  //----------------------------|Moverse en la lista|----------------------------//
  //En cant se ingresa la cantidad de casillas a desplazarse
  //En dir se ingresa [verdadero] para moverse hacia adelante | [false] para atrás
  Lista_casillas mover_posicion (int cant, boolean dir){
    Lista_casillas posicion = this;
    
    if (dir){  //Mover hacia adelante
      for (int i = 1; i <= cant; i++){
        posicion = posicion.siguiente;
      }
    } else {  //Mover hacia atrás
      Lista_casillas Cola = this;
      
      for (int i = 1; i <= cant; i++){
        while (posicion.siguiente != Cola){
          posicion = posicion.siguiente;
        }
      }
    }
    return posicion;
  }
}


/*
|====================================================================|
*                              |Casilla|
* Descripción:                                                        
*   Lista enlazada circular encargada de almacenar 
*   la información de las casillas 
|====================================================================|
*/
class Casilla {
    String nombre;            //Nombre de la Propiedad
    int num;                  //Número de la casilla
    int color_calle;          //Color de la propiedad [1] marrón | [2] azul claro | [3] magenta | [4] naranja | [5] rojo | [6] amarillo | [7] verde | [8] azul oscuro || Si es un servicio [1] púbico | [2] transporte
    int tipo;                 //Tipo de casilla: [1] propiedad | [2] servicio | [3] inicio | [4] especial
    int valor;                //Valor de compra
    int[] renta = new int[6]; //Valor de la renta - según posición: [0] sin casas | [1] 1 casa | [2] 2 casas | [3] 3 casas | [4] 4 casas | [5] castillo
    int construcciones;       //Construcciones hechas en la propiedad: [0] sin casas | [1] 1 casa | [2] 2 casas | [3] 3 casas | [4] 4 casas | [5] castillo
    int hipoteca;             //Valor de la hipoteca
    int vl_casa;              //Valor de comprar una casa o castillo
    boolean hipotecada;       //Si la propiedad está hipotecada será verdadero
    Jugador propietario;      //Propietario de la casilla: [estado] si nadie la posee | [null] si no puede poseerse
    int efecto;               //Efecto de la casilla (si es especial o servicio): [1] ingreso | [2] pago | [3] carcel | [4] carta | [5] ninguno
    int efecto_esp;           //Especificación del efecto generado (Revisar documentación para más información)
    int cant_pago;            //Almacena la cantidad de rentas que se han pagado
    int[] historial_rentas = new int[50];   //Almacena la información de todas las rentas recogidas por esta propiedad

    Casilla (int contador, Jugador propietario, String nombre, int color_calle, int tipo, int valor, int renta0, int renta1, int renta2, int renta3, int renta4, int renta5, int hipoteca, int casa, int efecto, int efecto_esp){
      this.nombre = nombre;
      this.num = contador;
      this.color_calle = color_calle;
      this.tipo = tipo;
      this.valor = valor;
      this.renta[0] = renta0;
      this.renta[1] = renta1;
      this.renta[2] = renta2;
      this.renta[3] = renta3;
      this.renta[4] = renta4;
      this.renta[5] = renta5;
      this.construcciones = 0;
      this.hipoteca = hipoteca;
      this.vl_casa = casa;
      this.hipotecada = false;
      this.efecto = efecto;
      this.efecto_esp = efecto_esp;
      this.cant_pago = 0;
      
      if (tipo == 3 | tipo == 4){
        this.propietario = null;
      } else {
        this.propietario = propietario;
      }
    }
    
    
    //----------------------------|Calcular Renta|----------------------------//
    int calcular_renta (){
      int renta = 0;  //Cálculo de la renta
      
      if (this.tipo == 1) {          //Si es propiedad
        //Por construcciones
        renta = this.renta[this.construcciones];
        
        //Revisar si se tienen todas las casillas del barrio
        boolean barrio_posesion = true;
        Lista_casillas temp = partida.mapa;
        
        do {
          if ((temp.casilla.color_calle == this.color_calle) && (temp.casilla.tipo == 1))
            if (temp.casilla.propietario != this.propietario)
              barrio_posesion = false;
        } while (temp != partida.mapa);
        
        //Por posesión de todo el barrio
        if (barrio_posesion)
          renta = renta * 2;
          
      } else if (this.tipo == 2) {   //Si es servicio
        if (this.color_calle == 2) {           //Si es una servicio público
            renta = int(random(1,7)) + int(random(1,7));
            
            //Revisar si se tienen los dos servicios
            boolean servicios_posesion = true;
            Lista_casillas temp = partida.mapa;
            
            do {
              if ((temp.casilla.tipo == 2) && (temp.casilla.color_calle == 2))
                if (temp.casilla.propietario != this.propietario)
                  servicios_posesion = false;
            } while (temp != partida.mapa);
            
            //Por posesión de ambos servicios
            if (servicios_posesion)
              renta = renta * 10;
            else
              renta = renta * 4;
              
        } else if (this.color_calle == 1) {    //Si es un servicio de transporte
          //Contar la cantidad de servicios de transporte en posesión
          int contador_serv = 0;
          Lista_casillas temp = partida.mapa;
          
          do {
            if ((temp.casilla.tipo == 2) && (temp.casilla.color_calle == 1))
              if (temp.casilla.propietario != this.propietario)
                contador_serv = contador_serv + 1;
          } while (temp != partida.mapa);
          
          //Por cantidad de tranportes en posesión
          renta = this.renta[contador_serv];
        }
      }
      
      return renta;
    }
    
    
    //----------------------------|Calcular Posición|----------------------------//
    // Retorna las coordenadas de la posición en términos de valores numéricos adaptados al tamaño del mapa
    // variable es el valor que se está pidiendo [1] para x | [2] para y
    float coordenadas_jug (int variable) {
      float cord = 0;
      int pos = this.num;
      int ind = 0;
      
      if (pos >= 1 && pos <= 10) {          //Primera línea: horizontal superior
        ind = 1;
      } else if (pos >= 11 && pos <= 20) {  //Segunda línea: vertical derecha
        ind = 2;
      } else if (pos >= 21 && pos <= 30) {  //Tercera línea: horizontal inferior
        ind = 3;
      } else {                              //Cuarta línea: vertical izquierda
        ind = 4;
      }
      
      if (variable == 1) {     //Coordenada en x
        switch (ind) {
          case 1:
            cord = pos * (motor.MV_x/12);
            break;
          case 2:
            cord = 11 * (motor.MV_x/12);
            break;
          case 3:
            cord = (32 - pos) * (motor.MV_x/12);
            break;
          case 4:
            cord = motor.MV_x/12;
            break;
        }
      } else {                 //Coordenada en y
        switch (ind) {
          case 1:
            cord = motor.MV_y/12;
            break;
          case 2:
            cord = (pos - 10) * (motor.MV_y/12);
            break;
          case 3:
            cord = 11 * (motor.MV_y/12);
            break;
          case 4:
            cord = (42 - pos) * (motor.MV_y/12);
            break;
        }
      }
      
      return cord;
    }
}


/*
|====================================================================|
*                        |Lista de Jugadores|
* Descripción:                                                        
*   Lista enlazada circular encargada de rotar los turnos 
*   según el orden de los jugadores
|====================================================================|
*/
class Lista_Jugadores {
  Jugador jugador;            //Jugador en la Posición
  Lista_Jugadores siguiente;  //Siguiente jugador en el turno
  
  void añadir_jug (Jugador jugador){
    if (this.jugador == null) {  //Si la lista está vacía
      this.jugador = jugador;
      this.siguiente = this;
    } else {                     //Si la lista NO está vacía
      Lista_Jugadores lista = this;
      while (lista.siguiente != this){
        lista = lista.siguiente;
      }
      
      Lista_Jugadores nuevo = new Lista_Jugadores ();
      nuevo.jugador = jugador;
      nuevo.siguiente = this;
      lista.siguiente = nuevo;
    }
  }
}


/*
|====================================================================|
*                        |Lista de Ventanas|
* Descripción:                                                        
*   Lista doblemente enlazada circular donde se almacena la cola
*   de las ventanas con las que el jugador podrá acceder a opciones
|====================================================================|
*/
class Lista_interfaz {
  Cont_Ventana interfaz;     //Ventana almacenada
  int cont;                  //Contador de la ventana
  
  Lista_interfaz siguiente;  //Ventana siguiente en cola
  Lista_interfaz previo;     //Ventana anterior en cola
  
  Lista_interfaz (){
    this.interfaz = null;
    this.cont = 0;
    this.siguiente = null;
    this.previo = null;
  }
  
  
  //-------------------------|Ingresar Ventana|-------------------------//
  //Ingresar ventana a la posición en la lista
  void Ingresar_ventana (Cont_Ventana ventana, int cont) {
    this.interfaz = ventana;
    this.cont = cont;
    this.siguiente = this;
    this.previo = this;
  }
  
  
  //-------------------------|Añadir a la Cola|-------------------------//
  //Añadir nueva ventana a la cola
  Lista_interfaz añadir_cola (Cont_Ventana ventana, int cont) {
      Lista_interfaz lista = this;
      
      if (this.interfaz == null){  //Si la cola está limpia
        ventana.ventana.x = ventana.ventana.x + (50 * cont);
        this.Ingresar_ventana (ventana, cont);
        
        return this;
      } else {                     //Si la cola NO está limpia
        Lista_interfaz nuevo = new Lista_interfaz ();
        nuevo.Ingresar_ventana (ventana, cont);
        
        lista = this.previo;
        
        nuevo.siguiente = this;     //Ingresar Siguiente
        nuevo.previo = this.previo; //Ingresar Anterior
        
        nuevo.interfaz.ventana.x = nuevo.interfaz.ventana.x + (50 * nuevo.cont);
        
        lista.siguiente = nuevo;
        this.previo = nuevo;
        
        return nuevo;
      }
  }
  
  
  //-------------------------|Mostrar Ventanas|-------------------------//
  void mostrar_interfaces () {
    Lista_interfaz temp = this;
    
    if (temp.interfaz == null) {  //Si no hay ventanas en cola
      menu = 5;
      return;
    }
    
    do {
      if (!temp.interfaz.ventana.decision) {  //Si NO se ha tomado la decision
        temp.interfaz.mostrar();        //Mostrar ventana
        temp = temp.siguiente;          //Pasar a la siguiente ventana
      } else {                        //Si se tomó la decisión
        temp = temp.eliminar();         //Eliminar ventana
      }
    } while (temp != this);
    
    this.previo.interfaz.mover();  //Si se mueve una ventana
    //this.previo.interfaz.presionar();  //Si se presiona una ventana ------------------------ |Para hacer|
  }

  
  //-------------------------|Seleccionar Ventana|-------------------------//
  //Seleccionar la ventana que primero se muestre
  //Devolverá la ventana que fue presionada y se encuentra visualizada en primer lugar
  Lista_interfaz seleccionar () {
    boolean presionado = false;
    Lista_interfaz PTR = this;
    Lista_interfaz fin = null;   //Ventana presionada

    Lista_interfaz temp = PTR.previo;
    
   //Revisar qué ventana fue presionada
    do {
       
       if (!presionado){
         if (temp.interfaz.sobre_caja()) {  //Guardar
           fin = temp;
           presionado = true;
         }
       }
      
       temp = temp.previo;
      
    }  while (temp != PTR.previo);
  
  
    if (fin != null) {  //Si se presionó una pestaña
      
      //Borrar seleccionada
      (fin.previo).siguiente = fin.siguiente;
      (fin.siguiente).previo = fin.previo;
      
      //Añadir al final
      if (fin == PTR)  //Si se debe pasar el PTR al final
        PTR = PTR.siguiente;
        
      fin.previo = PTR.previo;
      fin.siguiente = PTR;
      
      PTR.previo.siguiente = fin;
      PTR.previo = fin;
    }
    
    return PTR;
  }
  
  
  Lista_interfaz eliminar () {
    Lista_interfaz temp = this.previo;
    
    temp.siguiente = this.siguiente;
    (this.siguiente).previo = temp;
    
    return temp.siguiente;
  }
}


/*
|====================================================================|
*                        |Lista de Imágenes|
* Descripción:                                                        
*   Lista enlazada circular encargada de almacenar las imágenes 
*   para utilizar en el motor gráfico
*   Ingrese una imagen de tipo .png a partir de su nombre
|====================================================================|
*/
class Lista_imagenes {
  PImage imagen;      //Objeto imagen
  String archivo;     //Nombre archivo
  boolean ajustado;   //[verdadero] Si ha sido ajustado | [falso] si debe serlo
  boolean cargar;     //[verdadero] Si ha sido cargado | [falso] si debe serlo
  
  Lista_imagenes siguiente;
  
  
  //----------------------------|Buscar una imagen|----------------------------//
  Lista_imagenes encontrar (String nombre) {
    Lista_imagenes temp = this;
    boolean encontrado = false;
    
    while ((temp.siguiente != this) && (!encontrado)){
      temp = temp.siguiente;
      
      if (temp.archivo == nombre)
        encontrado = true;
    }
    
    if (encontrado) {  //Si se encontró
      return temp;       //Enviar imagen
    } else {           //Si NO se encontró
      ingresar(nombre);    //Crear imagen
      return temp.siguiente;       
    }
  }
  
  
  //----------------------------|Ingresar una imagen|----------------------------//
  //Crea un nuevo objeto en la lista e ingresa los datos correspondientes
  void ingresar (String archivo) {
    if (this.imagen == null) {  //Ingreso de imagen por defecto
      this.archivo = archivo;
      this.ajustado = false;
      this.siguiente = this;
      
      this.imagen = this.cargar();
    } else {                    //Ingreso del resto de imágenes
      Lista_imagenes temp = this;
      
      while (temp.siguiente != this) {
        temp = temp.siguiente;
      }
      
      Lista_imagenes nuevo = new Lista_imagenes();
      temp.siguiente = nuevo;
      
      nuevo.archivo = archivo;
      nuevo.ajustado = false;
      nuevo.siguiente = this;
      
      nuevo.imagen = nuevo.cargar();
      
      temp = null;
      System.gc();
    }
  }
  
  
  //----------------------------|Cargar una imagen|----------------------------//
  //Carga la imagen desde el directorio del juego
  PImage cargar () {
    PImage temp;
    temp = loadImage (this.archivo + ".png");
    
    if (temp == null)
      temp = loadImage ("defecto.png");
    
    return temp;
  }
  
  
  //----------------------------|Ajustar una imagen|----------------------------//
  //Calcula la proporción de los objetos en pantalla
  void ajustar (float prop, float tm_x, float tm_y) {
    if (!ajustado) {  //Si no ha sido ajustada
      //Generar Tamaño Relativo
        int tx = (int)(tm_x * prop);
        int ty = (int)(tm_y * prop);
        
      //Si la imagen se agranda más del 25% de la proporción actual
        if ((tm_x < tx) && (tm_y < ty))
          this.imagen = this.cargar();  //Volver a cargar imagen
        
      this.imagen.resize(tx, ty);
      this.ajustado = true;
    }
  }
  
  
  //----------------------------|Permitir el ajuste|----------------------------//
  //Cambia la variable ajustado de todas las imágenes de la lista
  //Por lo que cuando se muestren serán ajustadas
  void reajustar () {
    Lista_imagenes temp = this;
    temp.ajustado = false;
    
    while (temp.siguiente != this){
      temp = temp.siguiente;
      temp.ajustado = false;
    }
  }
  
  
  //----------------------------|Volver a cargar las Imágenes|----------------------------//
  //Vuelve a cargar las imágenes para ajustar la resolución
  void refrescar () {
    Lista_imagenes temp = this;
    
    while (temp.siguiente != this){
      temp = temp.siguiente;
      int x = temp.imagen.width;
      int y = temp.imagen.height;
      
      temp.imagen = temp.cargar();
      
      temp.imagen.resize(x, y);
    }
    
    temp = null;
    System.gc();
  }
}


//Lista Cartas (poner mas bonito)
class Lista_carta{
 Carta carta;
 Lista_carta siguiente;
 
 Lista_carta (Carta carta){
  this.carta = carta;
  this.siguiente = this;
 }
 
 Lista_carta añadir_carta (Carta carta){
   Lista_carta carta_actual = this;
   Lista_carta nuevo = new Lista_carta(carta);
   
   while (carta_actual.siguiente != this){
     carta_actual = carta_actual.siguiente;
   }
   
   carta_actual.siguiente = nuevo;
   nuevo.siguiente = this;
   
   return nuevo.siguiente;
}

class Carta{
 String texto;
 int accion;
 int efecto;
 
 Carta (String texto, int tipo, int accion, int efecto){
   this.texto = texto;
   this.accion = accion;
   this.efecto = efecto;
 }
}
