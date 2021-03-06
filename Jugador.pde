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
    this.ficha = "Jugadores/figura_jugador_" + figura_ficha + "-" + color_ficha;
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
    if (encarcelado) {  //Si encarcelaron a este jugador
      this.estado = 2;
      this.posicion = posicion;
      encarcelado = false;
      println(this.nombre + " [Jugador]: Acaba de ser encarcelado - deberá lanzar un doble para salir de prisión");
      return;
    }
    
    if (pagar_salario) {  //Si este jugador pasó por Inicio
      this.saldo += 200;
      println(this.nombre + " [Jugador]: reclama $200 por concepto de salario");
      println(this.nombre + " [Jugador]: nuevo saldo es " + this.saldo);
      pagar_salario = false;
    }
    
    if (this.estado == 1){  //Si el jugador está libre
      this.posicion = posicion;
      Casilla casilla = posicion.casilla;
      
      switch (casilla.tipo){  //Accionar según tipo de casilla
        case 1:  //Propiedad
          if (casilla.propietario == null) {  //Si no tiene dueño
            this.comprar(casilla, casilla.valor);
          } else {                             //Si tiene dueño
            int renta = casilla.calcular_renta();
            this.pagar(renta);
            casilla.propietario.saldo += renta;
          }
          break;
        case 2:  //Servicio
          if (casilla.propietario == null) {  //Si no tiene dueño
            this.comprar(casilla, casilla.valor);
          } else {                             //Si tiene dueño
            int renta = casilla.calcular_renta();
            this.pagar(renta);
            casilla.propietario.saldo += renta;
          }
          break;
        case 3:  //Inicio
          this.saldo = this.saldo + 200;
          break;
        case 4:  //Especial
          switch (posicion.casilla.efecto) {
            case 1:    //Ingreso
              periodico = new V_Anuncio ("Noticias La República:\nCongreso aprueba paquete de auxilios a empresas\n\nSe ha contemplado un nuevo paquete de auxilios a empresas por valor de "+posicion.casilla.efecto_esp, 
                                         loadImage("Periodico.png"), (710*width)/1920, (100*height)/1080, (500*width)/1920, (800*height)/1080);
              
              this.saldo += posicion.casilla.efecto_esp;
              println(this.nombre + " [Jugador]: gana "+posicion.casilla.efecto_esp+" por concepto de auxilios");
              println(this.nombre + " [Jugador]: nuevo saldo es " + this.saldo);
              break;
            case 2:    //Pago
              periodico = new V_Anuncio ("Noticias La República:\nCongreso aprueba reforma tributaria\n\nSe ha contemplado un nuevo paquete de "+posicion.casilla.nombre+" por valor de "+posicion.casilla.efecto_esp, 
                                         loadImage("Tablero/.png"), (710*width)/1920, (100*height)/1080, (500*width)/1920, (800*height)/1080);
              
              this.pagar(posicion.casilla.efecto_esp);
              println(this.nombre + " [Jugador]: paga "+posicion.casilla.efecto_esp+" por concepto de impuestos");
              println(this.nombre + " [Jugador]: nuevo saldo es " + this.saldo);
              break;
            case 3:    //Carcel
              periodico = new V_Anuncio ("Noticias La República:\n"+this.nombre+" es judicializado y encarcelado\n\nEl reconocido empresario ha sido acusado de enriquecimiento ilícito por el juzgado 15 de la ciudad, fue capturado en un retén mientras intentaba huir a otro país", 
                                         loadImage("Periodico.png"), (710*width)/1920, (100*height)/1080, (500*width)/1920, (800*height)/1080);
              
              //Buscar casilla de Cárcel
              Lista_casillas temp = partida.mapa;
              do {
                temp = temp.siguiente;
              } while (!(temp.casilla.tipo == 4 && temp.casilla.efecto == 5));
              pos = temp;
              
              //Mandar para la carcel al jugador
              cargar_an = false;
              encarcelado = true;
              break;
            case 4:    //Carta
              int efecto = 0;
              int efecto_esp = 0;
            
              if (posicion.casilla.efecto_esp == 2) {          //Fortuna
                periodico = new V_Anuncio ("", partida.fortuna.img, (710*width)/1920, (390*height)/1080, (500*width)/1920, (800*height)/1080);
                efecto = partida.fortuna.efecto;
                efecto_esp = partida.fortuna.efecto_esp;
                
                partida.fortuna = partida.fortuna.siguiente;
              } else if (posicion.casilla.efecto_esp == 1) {  //Boletín
                periodico = new V_Anuncio ("", partida.cofre.img, (710*width)/1920, (390*height)/1080, (500*width)/1920, (300*height)/1080);
                efecto = partida.cofre.efecto;
                efecto_esp = partida.cofre.efecto_esp;
                
                partida.cofre = partida.cofre.siguiente;
              }
              
              switch (efecto) {
                  case 1:    //Moverse
                    if (efecto_esp == 0) {        //Ir al Inicio
                      pos = partida.mapa;
                    } else if (efecto_esp > 0) {  //Avanzar
                      pos = jugadores.jugador.posicion.mover_posicion(partida.fortuna.efecto_esp, true);
                    } else if (efecto_esp < 0) {  //Retroceder
                      pos = jugadores.jugador.posicion.mover_posicion(-partida.fortuna.efecto_esp, false);
                    }
                    cargar_an = false;
                    mov = true;
                    break;
                  case 2:    //Ganar Dinero
                    jugadores.jugador.saldo += efecto_esp;
                    break;
                  case 3:    //Perder Dinero
                    jugadores.jugador.pagar(efecto_esp);
                    break;
                  case 4:    //Cárcel
                    if (efecto_esp == 1) {          //Liberar presos
                      Lista_Jugadores temp1 = jugadores;
                    
                      for (int i = 1; i <= partida.cant_jug; i++) {
                        if (temp1.jugador.estado == 2)
                          temp1.jugador.estado = 1;
                        temp1 = temp1.siguiente;
                      }
                    } else if (efecto_esp == 2) {   //Encarcelar jugador
                      //Buscar casilla de Cárcel
                      Lista_casillas temp2 = partida.mapa;
                      do {
                        temp2 = temp2.siguiente;
                      } while (!(temp2.casilla.tipo == 4 && temp2.casilla.efecto == 5));
                      pos = temp2;
                      
                      //Mandar para la carcel al jugador
                      cargar_an = false;
                      encarcelado = true;
                    }
                    break;
                }
              break;
          }
          //-------------------------------------------------------------------------------------------------|Para hacer|
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
  ingresar Jugador que está ofreciendo la propiedad, la propiedad en cuestión y su precio
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
    this.pagar(precio);                       //Pagar propiedad
    jugador.saldo = jugador.saldo + precio;   //Recibir pago
    
    //Traspaso de Escrituras
    propiedad.propietario = this;
    
    //Actualización de inventarios
    jugador.eliminar_prop(propiedad);
    this.registrar_prop(propiedad); 
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
  
  
  //----------------------------|Subrutina para Registrar una propiedad|----------------------------
  void eliminar_prop (Casilla propiedad) {
    if (this.propiedades == null)                             //Si NO tiene propiedades
      this.propiedades = null;
    else if (this.propiedades.siguiente == this.propiedades)  //Si solo tiene una tiene propiedad
      this.propiedades = null;
    else                                                      //Si tiene varias propiedades
      this.propiedades = this.propiedades.eliminar_propiedad(propiedad.nombre);
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
