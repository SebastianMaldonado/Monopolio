/*
|----------------------------//----------------------------|
|  Página Secundaria - Funcionamiento de Interfaz          |
|----------------------------//----------------------------|
*/


/*
|====================================================================|
*                              |Interfaz|
* Descripción:                                                        
*   Objeto administrador de interfaces y decisiones del jugador humano
*   visualiza las ventanas y gestiona sus variables temporales
|====================================================================|
*/
class Interfaz {
  Pantalla_inicio p_inicio;          //Pantalla de Inicio
  Pantalla_opciones p_opciones;      //Menú de Opciones
  Pantalla_seleccion p_seleccion;    //Pantalla para selección de modalidad
  Pantalla_jugadores p_jugadores;    //Pantalla para ingreso de Jugadores
  Pantalla_carga p_carga;            //Pantalla de Carga
  
  Inventario inventario;
  Negociaciones negocios;
  Tablero tablero;
  
  V_Anuncio ps_turno;                //Anuncio para pasar turno
  
  boolean inv_cargado;          //Booleano para verificar si los datos del inventario han sido cargados
  boolean neg_cargado;          //Booleano para verificar si los datos de la pestaña de negocios han sido cargados
  boolean orden_cargado;        //Booleano para cargar el vector de ordenamiento de los jugadores
  int jug_vec[];                //Vector para ordenamiento de jugadores
  int cont_jug;                 //Contador de los jugadores que ya tiraron dados

  void inicializar () {
    this.p_inicio = new Pantalla_inicio ();
    this.p_opciones = new Pantalla_opciones ();
    this.tablero = new Tablero ();
    
    this.inv_cargado = false;
    this.neg_cargado = false;
    this.orden_cargado = true;
    
    this.cont_jug = 1;
  }

  
  //----------------------------|Pantalla de Inicio|----------------------------//
  void pantalla_inicio () {
    this.p_inicio.mostrar();
  }
  
  
  //----------------------------|Menú de Opciones|----------------------------//
  void opciones () {
    this.p_opciones.mostrar();
  }
  
  
  //----------------------------|Pantalla de Jugadores|----------------------------//
  void jugadores () {
    this.p_jugadores.mostrar();
  }
  
  
  //----------------------------|Pantalla de Selección|----------------------------//
  void seleccion () {
    this.p_seleccion.mostrar();  
  }
  
  
  //----------------------------|Pantalla de Carga|----------------------------//
  void pantalla_carga () {
    this.p_carga.mostrar();
  }
  
  
  //----------------------------|Mostrar Tablero|----------------------------//
  void mostrar_tablero () {
    this.tablero.mostrar();
  }
  

  //----------------------------|Mostrar Inventario|----------------------------//
  void mostrar_inventario() {
    //Cargar propiedades como ventanas
    if (!this.inv_cargado) {
      this.inventario = new Inventario (jugadores.jugador);
      this.inv_cargado = true;
    }
    
    this.inventario.mostrar();
  }

  
  //----------------------------|Mostrar Negociaciones|----------------------------//
  void mostrar_negocios () {
    //Cargar jugadores como ventanas
    if (!neg_cargado) {
      this.negocios = new Negociaciones (null);
      this.neg_cargado = true;
    }
    
    this.negocios.mostrar();
  }
  
  
  //----------------------------|Pasar turno|----------------------------//
  void pasar_turno () {
    partida.verificar_fin();
    if (fin_juego) {
      fin_partida.mostrar();
      return;
    }
    
    if ((jugadores.jugador.interfaz.contar_ventanas() > 0) && !ps_turno_pres) {    //Si tiene decisiones pendientes
      println(jugadores.jugador.interfaz.contar_ventanas());
      ps_turno = new V_Anuncio ("Tienes decisiones pendientes en tu bandeja de correos", loadImage("Anuncio_ps_turno.png"), (710*width)/1920, (390*height)/1080, (500*width)/1920, (300*height)/1080);
      ps_turno_pres = true;
      return;
    }
    
    if ((jugadores.jugador.saldo < 0) && !ps_turno_pres && !bancarrota) {          //Si el jugador está en deuda (si acepta se declarará en bancarrota)
      ps_turno = new V_Anuncio ("Te encuentras en Bancarrota, si vuelves a pasar turno perderás la partida", loadImage("Anuncio_ps_turno.png"), (710*width)/1920, (390*height)/1080, (500*width)/1920, (300*height)/1080);
      ps_turno_pres = true;
      bancarrota = true;
      return;
    } 
    
    if (ps_turno_pres) {  //Mostrar ventana 
      ps_turno.mostrar();
      
      if (ps_turno.decision) {  //Si se aceptó el mensaje
        
        if (bancarrota) {  //Declarar jugador en Bancarrota
          jugadores.jugador.estado = 3;
        }

        ps_turno_pres = false;
        ind = 6;
      }
      return;
    }
    
    partida.pasar_turno();
  }
  
  
  //----------------------------|Decidir Orden de Jugadores|----------------------------//
  //Para cuando sea presionado uno de los botones de alguna de las pestañas
  //Este método debe ser ejecutado en mousePressed()
  void decidir_orden () {
    if (orden_decidido)    //Si el orden ya fue decidido
      return;
    
    if (!orden_cargado) {  //Cargar el nuevo orden de los jugadores
      Lista_Jugadores nuevo_orden = new Lista_Jugadores ();  //Nuevo ordenamiento de los jugadores
      int may = 0;  //Número mayor
      jug_vec[0] = 0;
      
      do {
        for (int i = 0; i <= partida.cant_jug; i++) {  //Buscar el mayor
          if (jug_vec[i] >= jug_vec[may]) {              //Si encuentra uno mayor
            may = i;
          }
        }
        jug_vec[may] = -1;  //Eliminar número
        
        //Buscar al jugador correspondiente
        Lista_Jugadores temp = jugadores;
        for (int j = 1; j < may; j++) {
          temp = temp.siguiente;
        }
        
        //Añadir jugador a la nueva lista
        if (may != 0)
          nuevo_orden.añadir_jug(temp.jugador);
      } while (may != 0);
      
      jugadores = nuevo_orden;  //Actualizar nuevo orden de jugadores
      orden_decidido = true;
      return;
    }     
     
    //Lanzamiento de dados de todos los jugadores
    if (cont_jug > partida.cant_jug) {
      orden_cargado = false;
      return;
    }
    
    dado1 = int(random (1, 7));
    //this.animacion.lanzar_dados();
    println("Interfaz: El jugador " + jugadores.jugador.nombre + " ha lanzado " + dado1);
    
    jug_vec[cont_jug] = dado1;
    jugadores = jugadores.siguiente;
    
    
    cont_jug += 1;
    
  }
  
  
  //----------------------------|Presionar un Botón|----------------------------//
  //Para cuando sea presionado uno de los botones de alguna de las pestañas
  //Este método debe ser ejecutado en mousePressed()
  void presionar () {
    switch (menu) {
      case 0:    //Pantalla de Inicio
        this.p_inicio.presionar();
        
        if (this.p_inicio.inicio.sobre_boton())  //Si se presionó el botón de inicio
          this.p_jugadores = new Pantalla_jugadores ();
        break;
      case 1:    //Menu de Opciones
        this.p_opciones.presionar();
        break;
      case 2:    //Pantalla de Lectura de Jugadores
        this.p_jugadores.presionar();
        this.p_carga = new Pantalla_carga (this.p_jugadores.nombres, this.p_jugadores.color_ficha, this.p_jugadores.figura_ficha, this.p_jugadores.tipo);
        this.p_jugadores = null;
        break;
      case 3:    //Pantalla de Selección de Modalidad
        this.p_seleccion.presionar();
        break;
      case 4:    //Pantalla de Carga
        break;
      case 6:    //Inventario
        this.inventario.presionar();
        if (inventario.seleccionado != null) {    //Si se selecciona una propiedad
          if (inventario.inv_propio) {              
            if (inventario.vender.sobre_boton()) {                //Si se desea vender
              this.negocios = new Negociaciones (inventario.seleccionado);
              neg_cargado = true;
              menu = 9;
            } else if (inventario.hipotecar.sobre_boton()) {      //Si se desea hipotecar
              partida.hipotecar (inventario.seleccionado); // ------------------------------------------------------------------- |Para hacer|
            } else if (inventario.construir.sobre_boton()) {      //Si se desea construir
              partida.construir (inventario.seleccionado);
            }
          } else if (inventario.ofertar.sobre_boton() && !inventario.inv_propio) {     //Si se desea ofertar
            
          }
        }
          
        break;
      case 9:    //Negociaciones
        this.negocios.presionar();
        if (negocios.seleccionado != null) {      //Si se selecciona un jugador
          if (negocios.propiedades.sobre_boton() && (negocios.propiedad == null)) {    //Si se desea ver las propiedades
            this.inventario = new Inventario (negocios.seleccionado);
            inv_cargado = true;
            menu = 6;
          } else if (negocios.vender.sobre_boton() && (negocios.propiedad != null)) {  //Si se desea vender una propiedad
            negocios.seleccionado.prop_venta(jugadores.jugador, negocios.propiedad, 0); // Añadir ventana para ingresar precio ----------------------------------------------------- |Para hacer|
            neg_cargado = false;
            menu = 5;
          }
        }
        break;
    }
  }
}


/*
|====================================================================|
*                          |Animación|
* Descripción:                                                        
*   Objeto para generar una animación
*   Deberá ingresarse la cantidad de fotogramas y el nombre de la secuencia
*   Las imágenes deben estar guardadas de la siguiente manera:
*     -  Prefijo "An-"
*     -  Nombre de la secuencia
*     -  "-" y Número en la secuencia
|====================================================================|
*/
class Animacion {
  boolean finalizado;
  PImage[] secuencia;
  int tam;
  int pos;
  float x, y;
  float pr_x, pr_y;
  boolean cargar;
  
  boolean calc_tmp = true;
  int tiempo = 0;
  /* 
  ||===============================|Animación Independiente|===============================||
  */
  Animacion (String nombre, int tam) {
    this.tam = tam;
    this.pos = 1;
    this.finalizado = false;
    this.secuencia = new PImage[tam + 1];
    
    for (int i = 1; i <= tam; i++) {
      println(i);
      this.secuencia [i] = loadImage ("Dados/An-" + nombre + "-" + i + ".png");
    }
  }
  
  /* 
  ||===============================|Animación por coordenadas|===============================||
  */
  Animacion (int tam, float pr_x, float pr_y, float fn_x, float fn_y) {
    this.pos = 0;
    this.tam = tam * 15;
    this.pr_x = pr_x;
    this.pr_y = pr_y;
    this.x = fn_x;
    this.y = fn_y;
    this.finalizado = false;
  }
  
  
  
  //----------------------------|Cargar tamaño de Imágenes|----------------------------//
  void cargar (int tx, int ty) {
    for (int i = 1; i <= tam; i++) {
      this.secuencia [i].resize (tx, ty);
    }
  }
  
  
  //----------------------------|Ingresar Coordenadas|----------------------------//
  //Ingresa las coordenadas y tamaño de la animación para ser generada
  void ajustar (int x, int y, int tx, int ty) {
    this.x = x;
    this.y = y;
    this.cargar(tx, ty);
  }
  
  
  //----------------------------|Mostrar Animación|----------------------------//
  void lanzar_dados (int dado) {
    if (this.finalizado) {
      this.finalizado = false;
      this.calc_tmp = true;
    }
    
    if (calc_tmp) {
      tiempo = millis();
      calc_tmp = false;
    }
    
    if (millis() <= tiempo + 3000) {
      int num = int(random (1, 6));
      
      image (secuencia[num], x, y);
    } else if (millis() <= tiempo + 5000) {
      image (secuencia[dado], x, y);
    } else {
      this.finalizado = true;
    }
  }
  
  
  //----------------------------|Retornar Coordenadas|----------------------------//
  //Función para retornar las coordenadas de un movimiento ejecutado por tam/15 segundos
  float calc_pos (boolean variable) {
    float cord = 0;
    
    if (variable)     //Retornar x
      cord = this.pr_x + (this.pos * ((this.x - this.pr_x) / this.tam));
    else              //Retornar y
      cord = this.pr_y + (this.pos * ((this.y - this.pr_y) / this.tam));
      
    this.pos = this.pos + 1;
    if (pos >= tam)      //Terminar animación
      this.finalizado = true;
    
    return cord;
  }
}
