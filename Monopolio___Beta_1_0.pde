 /*
|----------------------------//----------------------------|
|  Monopolio - Versión Beta 1.0  (26/05/22)                |
|  Proyecto Estructura de Datos I                          |
|                                                          |
|  Desarrollador: Marudonado-kami-sama Studios             |
|----------------------------//----------------------------|

  Descripción de versión:
    Nuevas Implementaciones:
      - Primera versión finalizada y estable
      - Visualización del lanzamiento de dados
      - Visualización de la interfaz de usuario para la partida
      
    Arreglo de Errores:
      - Removed Herobrine
*/


/*
|----------------------------//----------------------------|
|  Página Principal - Interfaz Gráfica                     |
|----------------------------//----------------------------|
*/


//Imágenes
  Motor_Grafico motor = new Motor_Grafico (5000, 5000);
  PImage Pantalla_inicio;
  PImage Pantalla_opciones;
  PImage Pantalla_jugadores;
  PImage Tablero;
  PImage escritorio;
  PImage archivador;
  PImage img_carpeta;
  
//Variables de opciones
  float vol_m = 1;           //Volumen ambiente
  float vol_e = 1;           //Volumen efectos
  boolean modo_br = false;   //Modo de bajos recursos
  int modalidad = 1;         //Modalidad del juego [1] Normal | [2] Telón de Acero

//Objetos de Apliación Global
  Juego partida = new Juego();                          //Generar una partida nueva
  Lista_Jugadores jugadores = new Lista_Jugadores();    //Generar lista de jugadores
  Interfaz interfaz = new Interfaz ();                  //Conjunto de procedimientos para la generación de la interfaz gráfica

//Movimiento de Casilla
  Lista_casillas pos = null;       //Posición de movimiento
  int dado1, dado2;                //Dados
  boolean dados_lanzados = false;  //Dados lanzados
  int cant_lanz = 0;               //Cantidad de lanzamientos (para los jugadores presos)

//Interfaz
  boolean mouseDragged;            //Variable booleana para cuando se mantenga presionado el ratón
  int menu = 0;                    //Variable de definición del Menú (Revisar Documentación para más información)
  int ind = 0;                     //Variable de ciclo básico de la partida (Revisar Documentación para más información)
  boolean cargar_an = false;       //Cargar animación de fichas
  Animacion fichas;                //Animación de movimiento para las fichas
  boolean lanz_dados;              //Cargar animación de dados
  Animacion an_dados;              //Animación del lanzamiento de dados
  boolean ps_turno_pres = false;   //Variable para saber si el botón de pasar turno ya fue presionado
  
//Funcionales
  boolean fin_juego = false;       //Fin Juego
  boolean bancarrota = false;      //Variable para declarar en bancarrota a un jugador
  boolean encarcelado = false;     //Variable para mandar a un jugador a la cárcel
  boolean pagar_salario = false;   //Variable para pagarle el salario a un jugador (si pasa por Inicio)
  boolean orden_decidido = false;  //Variable para organizar a los jugadores en un orden
  boolean mov = false;             //Variable para repetir movimiento del jugador
  V_Anuncio periodico;             //Ventana de Anuncio que muestra al jugador qué sacó en cartas de suerte, arca comunal y pago de impuestos
  V_Anuncio fin_partida;           //Mensaje para acabar el juego
  Animacion an_dado1;              //Animación de lanzamiento de dados
  Animacion an_dado2;              //Animación de lanzamiento de dados

void setup(){ 
  fullScreen();
  
  //Motor Gráfico
  motor.inicializar();
  interfaz.inicializar ();
  
  //Carga de Imágenes
  Pantalla_inicio = loadImage ("Pantalla de Inicio - Boceto.png");
  Pantalla_jugadores = loadImage ("Pantalla de Jugadores - Boceto.png");
  an_dados = new Animacion ("dados", 50);
  escritorio = loadImage ("escritorio.jpg");
  archivador = loadImage ("Archivador.png");
  img_carpeta = loadImage ("Carpeta.png");
  an_dado1 = new Animacion ("dado", 6);
  an_dado2 = new Animacion ("dado", 6);
  fin_partida = new V_Anuncio ("Se ha acabado la partida", loadImage("Anuncio_ps_turno.png"), (710*width)/1920, (390*height)/1080, (500*width)/1920, (300*height)/1080);
  
  //Ajuste del tamaño
  Pantalla_inicio.resize(width, height);
  Pantalla_jugadores.resize(width, height);
  escritorio.resize(width, height);
  archivador.resize(width, height);
  an_dado1.ajustar (660*width/1920, height/2, 250*width/1920, 250*width/1920);
  an_dado2.ajustar (910*width/1920, height/2, 250*width/1920, 250*width/1920);
}


void draw(){
  switch (menu) {
    case 0:  //Página de Inicio
      interfaz.pantalla_inicio();
      break;
    case 1:  //Página de Opciones
      interfaz.opciones();
      break;   
    case 2:  //Página de Lectura de Jugadores
      interfaz.jugadores ();
      break;
    case 3:  //Página de Selección de Modalidad
      interfaz.seleccion();
      break;
    case 4:  //Pantalla de Carga
      interfaz.pantalla_carga();
      break;
    case 5:  //Página del Juego
      interfaz.mostrar_tablero();
    
      switch (ind) {
        case 0:  //Ordenar jugadores
          interfaz.decidir_orden();
          
          if (orden_decidido)  //Cuando se decida el orden los jugadores se empieza a jugar
            ind = 1;
          break;
        case 1:  //Lanzar dados
          partida.lanzar_dados();
          an_dado1.lanzar_dados(dado1);
          an_dado2.lanzar_dados(dado2);
          
          if (!an_dado1.finalizado)
            return;
            
          println("Dados lanzados:  "+dado1+"  "+dado2);
          ind = 2;
          break;
        case 2:  //Mover ficha
          if (jugadores.jugador.estado == 1) {           //Si el jugador está libre
            pos = jugadores.jugador.posicion.mover_posicion(dado1 + dado2, true);
            println("Casilla caída:  " + pos.casilla.nombre);
            ind = 3;
            return;
          } 
          
          if (jugadores.jugador.estado == 2) {           //Si el jugador está preso
            if (cant_lanz == 2) {      //Si se acabaron los intentos
              cant_lanz = 0;
              ind = 6;
              return;
            }
            
            cant_lanz += 1;
            
            if (dado1 == dado2) {     //Si los dados son pares
              jugadores.jugador.estado = 1;  //Jugador queda libre
              cant_lanz = 0;
              return;
            }
            
            //Volver a intentarlo
            ind = 1;
            dados_lanzados = false;
          }
          break;
        case 3:  //Animación
          if (!cargar_an) {            //Cargar objeto de animación
            float pr_x = jugadores.jugador.posicion.casilla.coordenadas_jug(1);
            float pr_y = jugadores.jugador.posicion.casilla.coordenadas_jug(2);
            float fn_x = pos.casilla.coordenadas_jug(1);
            float fn_y = pos.casilla.coordenadas_jug(2);
            fichas = new Animacion (5, pr_x, pr_y, fn_x, fn_y);
            cargar_an = true;
            mov = false;
          }
        
          if (fichas.finalizado) {      //Si acaba la animación
            cargar_an = false;
            jugadores.jugador.mover(pos);
            fichas = null;
            
            if (!encarcelado && !mov)  //Si el jugador no fue encarcelado: continuar
              ind = 5;
          }
          break;
        case 4:  //Acción de la casilla
          
          break;
        case 5:  //Anuncio de acción
          if (periodico == null) {  //Si no hay periódico
            ind = 6;
            return;
          }
          
          periodico.mostrar();  //Mostrar noticias
          
          if (periodico.decision) {
            periodico = null; 
            ind = 6;
          }
          break;
        case 6:  //Tiempo libre
          if (jugadores.jugador.tipo == 2) {
            ind = 7;
          }
          break;
        case 7:  //Acción de pasar turno
          interfaz.pasar_turno();
          break;
      }
      break;
    case 6:  //Inventario
      interfaz.mostrar_inventario();
      break;
    case 7:  //Cartera
      interfaz.mostrar_tablero();
      //interfaz.mostrar_cartera();
      break;
    case 8:  //Visualizar ventanas
      if (jugadores.jugador.interfaz.cola_acciones.interfaz == null) {  //Si no hay ventanas en cola
        menu = 5;
        return;
      }
      
      if (escritorio != null)
      image (escritorio , 0, 0);
      else
        rect (0, 0, width, height);
      jugadores.jugador.interfaz.cola_acciones.mostrar_interfaces();
      break;
    case 9:  //Negociaciones
      interfaz.mostrar_negocios();
      break;
    case 10: //Pantalla del Fin del Juego 
      break;
    case 15:
      break;
  }
}


//----------------------------|Lectura del ratón|----------------------------
void mousePressed(){
  interfaz.presionar();
  
  if (menu >= 5 && menu <= 9) //Si se encuentra mostrando el mapa
    motor.presionar();
  
  if (menu == 8) {  //Ventanas
    jugadores.jugador.interfaz.cola_acciones = jugadores.jugador.interfaz.cola_acciones.seleccionar();     //Seleccionar una ventana al presionarla
    jugadores.jugador.interfaz.cola_acciones.previo.interfaz.aceptar();                                    //Presionar el botón de una ventana
  }
  
  if (menu == 5 && ind == 7) {
    if (ps_turno_pres && interfaz.ps_turno != null) {
      interfaz.ps_turno.aceptar();
    }
  }
  
  if (menu == 5 && ind == 5) {  //Si se acepta el periódico
    if (periodico != null)
      periodico.aceptar();
  }
}

void keyPressed(){
  if (menu >= 5 && menu <= 9) //Si se encuentra mostrando el mapa
    motor.mover();
    
  if ((menu == 5) && (ind == 6)) {  //Tiempo libre del Juego
    if (key == '1') {           //Inventario
      menu = 6;      
      println("Menu [Inventario]: Activado");
    } else if (key == '2') {    //Cartera
      menu = 7;
      println("Menu [Cartera]: Activado");
    } else if (key == '3') {    //Visualizar Ventanas
      menu = 8;
      println("Menu [Ventanas]: Activado");
    } else if (key == '4') {    //Negociaciones
      menu = 9;
      println("Menu [Negocios]: Activado");
    } else if (key == ENTER) {  //Pasar turno
      ind = 7;
      println("Juego: Pasando turno");
    }
  } else if ((menu >= 6) && (menu <= 9)) {  //Si se encuentra en algún menú de jugador
    if (key == ENTER)  //Devolverse
      if (menu == 9)
        if (interfaz.negocios.propiedad != null)    //Si se había seleccionado una casilla para vender
          interfaz.neg_cargado = false;
      
      if (menu == 6)
        if (!interfaz.inventario.inv_propio)        //Si se había seleccionado el inventario de otro jugador
          interfaz.inv_cargado = false;
    
      menu  = 5;
  }
}

void mouseWheel (MouseEvent event) {
  if (menu >= 5 && menu <= 9) //Si se encuentra mostrando el mapa
    motor.zoom(event.getCount());
}

void mouseDragged() {
  mouseDragged = true;
}

void mouseReleased() {
  mouseDragged = false;
}
