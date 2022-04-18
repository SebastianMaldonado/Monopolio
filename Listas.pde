/*
|----------------------------//----------------------------|
|  Página Secundaria - Funcionamiento de las listas        |
|----------------------------//----------------------------|
*/


//-------------------------|Lista de Casillas|-------------------------
//Lista enlazada circular encargada de almacenar la información de las casillas 

class Casilla {
    String nombre;            //Nombre de la Propiedad
    int num;                  //Número de la casilla
    int color_calle;          //Color de la propiedad [1] marrón | [2] azul claro | [3] magenta | [4] naranja | [5] rojo | [6] amarillo | [7] verde | [8] azul oscuro
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
    
    Casilla siguiente;      //Enlace para la siguiente casilla

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
    
    //Función para cálculo de la renta
    int calcular_renta (){
      return 0;
    }
    
    
    //Función para añadir un elemento a la lista
    Casilla añadir_propiedad (Casilla propiedad){
      Casilla lista = this;
      
      while (lista.siguiente != this){
        lista = lista.siguiente;
      }
      
      lista.siguiente = propiedad;
      propiedad.siguiente = this;
      return this;
    }
    
    
    //Función para eliminar un elemento de la lista
    Casilla eliminar_propiedad (String nombre){
      Casilla lista = this;
      
      while (((lista.siguiente).nombre != nombre) && (lista.siguiente != this)){
        lista = lista.siguiente;
      }
      
      if ((lista.siguiente).nombre != nombre){  //Si se encontró
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
}


//-------------------------|Lista de Jugadores|-------------------------
//Lista enlazada circular encargada de rotar los turnos según el orden de los jugadores

class Lista_Jugadores {
  Jugador jugador;            //Jugador en la Posición
  int negociar = 10;           //Turnos hasta la próxima oportunidad de ofertar o vender (Máquina)
  Lista_Jugadores siguiente;  //Siguiente jugador en el turno
  
  void generar_lista (Jugador jugador){
    this.jugador = jugador;
    this.siguiente = this;
  }
  
  void añadir_jug (Jugador jugador){
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
