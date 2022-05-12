/*
|-----------------------------//-----------------------------|
|  Página Secundaria - Funcionamiento del Motor Gráfico      |
|-----------------------------//-----------------------------|
*/

/*
|====================================================================|
*                 |Motor Gráfico para Juegos en 2D|         
* Descripción:                                                        
*   Clase utilizada para visualizar un entorno gráfico interactivo
*   Genera un mapa virtual del que según la posición de la cámara
*   se mostrarán las imágenes con unas coordenadas relativas
|====================================================================|
*/
class Motor_Grafico {
  //Proporción de Mapa y Cámara
    float MV_x, MV_y;         //Tamaño del Mapa Virtual
    float cam_x, cam_y;       //Tamaño de la Cámara
    float cam_px, cam_py;     //Posición de la Cámara
  
  //Ajuste de los objetos
    Lista_imagenes imagenes;  //Lista de Imágenes y su accionar
    float prop;               //Proporción de los objetos
  
  //Movimiento de la Cámara
    float inc;                //Incremento suavizado - Movimiento
    float incr;               //Incremento suavizado - Tamaño
    int tm_inc;               //Tiempo desde que se presionó el incremento
    boolean mov_mg = true;    //Movimiento de cámara
    int cargar = 0;           //Cargar Imágenes nuevamente
  
  //Ratón
    float rt_x, rt_y;         //Coordenadas virtuales del ratón 
  
  Motor_Grafico (int MV_x, int MV_y) {
    this.MV_x = MV_x;
    this.MV_y = MV_y;
    this.imagenes = new Lista_imagenes ();
  }
  
  
  //----------------------------|Inicialización del Motor|----------------------------//
  //Debe de ingresarse en setup() para arrancar datos necesarios para la ejecución del motor
  void inicializar () {
    this.imagenes.ingresar("defecto");
    
    this.cam_px = 0;
    this.cam_py = 0;
    this.cam_x = width;
    this.cam_y = height;
  }
  
  
  //----------------------------|Subrutina para Mostrar imagen|----------------------------//
  //Ingresar nombre de la imagen y sus coordenadas virtuales, mostrará la imagen en las coordenadas reales
  void mostrar (String imagen, float pos_x, float pos_y, float tm_x, float tm_y) {  
    Lista_imagenes temp = this.imagenes.encontrar(imagen);  //Encontrar imagen
    
    if (mov_mg) {                          //Si se acerca o aleja la cámara
      this.cambiar_prop();                     //Ajustar nueva proporción
      temp.ajustar(this.prop, tm_x, tm_y);     //Ajustar imagen
    }
    
    if (aparecer_cam(pos_x, pos_y, tm_x, tm_y)) {  //Si el objeto aparece en cámara
      float px = (pos_x - this.cam_px) * this.prop;      // Generar posición relativa en x
      float py = (pos_y - this.cam_py) * this.prop;      // Generar posición relativa en y
  
      image(temp.imagen, px, py);
    }
    
    temp = null;
  }
  
  
  //----------------------------|Función de Reconocimiento|----------------------------//
  //Lee la posición del objeto y reconoce si se encuentra en cámara, retornará [true] si se encuentra, [false] si no
  boolean aparecer_cam (float pos_x, float pos_y, float tm_x, float tm_y) {
    
  if (((pos_x >= this.cam_px) && (pos_x <= this.cam_px + this.cam_x) && (pos_y >= this.cam_py) && (pos_y <= this.cam_py + this.cam_y))                               //Esquina superior izquierda
    || ((pos_x + tm_x >= this.cam_px) && (pos_x + tm_x <= this.cam_px + this.cam_x) && (pos_y >= this.cam_py) && (pos_y <= this.cam_py + this.cam_y))                //Esquina superior derecha
    || ((pos_x >= this.cam_px) && (pos_x <= this.cam_px + this.cam_x) && (pos_y + tm_y >= this.cam_py) && (pos_y + tm_y <= this.cam_py + this.cam_y))                //Esquina inferior izquierda
    || ((pos_x + tm_x >= this.cam_px) && (pos_x + tm_x <= this.cam_px + this.cam_x) && (pos_y + tm_y >= this.cam_py) && (pos_y + tm_y <= this.cam_py + this.cam_y))  //Esquina inferior derecha
    ){
      return true;
      
    } else if (((this.cam_px >= pos_x) && (this.cam_px + this.cam_x <= pos_x + tm_x) && (this.cam_py >= pos_y) && (this.cam_py + this.cam_y <= pos_y + tm_y))                                                                         //Objeto más grande que la cámara - 4 vértices fuera de la pantalla
    || ((this.cam_px >= pos_x) && (this.cam_px + this.cam_x <= pos_x + tm_x) && (((this.cam_py >= pos_y) && (this.cam_py <= pos_y + tm_y)) || ((this.cam_py + this.cam_y >= pos_y) && (this.cam_py + this.cam_y <= pos_y + tm_y))))   //Objeto más grande que el eje x
    || ((this.cam_py >= pos_y) && (this.cam_py + this.cam_y <= pos_y + tm_y) && (((this.cam_px >= pos_x) && (this.cam_px <= pos_x + tm_x)) || ((this.cam_px + this.cam_x >= pos_x) && (this.cam_px + this.cam_x <= pos_x + tm_x))))   //Objeto más grande que el eje y
    ){
      return true;
      
    } else {
      return false;
      
    }
  }
  
  
  //----------------------------|Subrutina para Proporciones|----------------------------//
  //Calcula la proporción de los objetos en pantalla
  void cambiar_prop () {
    this.prop = width / this.cam_x;
    this.cam_y = height / this.prop;
  }
  
  
  //----------------------------|Subrutina para Presionar el tablero|----------------------------//
  //Subrutina para calcular la posición virtual del ratón
  void presionar () {
    this.rt_x = (mouseX / (height / this.cam_y)) + this.cam_px;
    this.rt_y = (mouseY / (height / this.cam_y)) + this.cam_py;
  }
  
  
  //----------------------------|Subrutina para Mover la cámara|----------------------------//
  //Subrutina para mover la cámara dentro del mapa virtual
  void mover () {
    this.tm_inc = millis();
    if (this.inc <= 49)         //Aceleración del incremento
      this.inc = this.inc + 1;
    
    float num = int(sin(3.14 * (this.inc/100)) * 20);
    
    if (keyCode == UP){             //Subir la Cámara
      if (this.cam_py - num >= 0){  
        this.cam_py = this.cam_py - num;
      } else if (this.cam_py - num < 0){
        this.cam_py = 0;
      }
    } else if (keyCode == DOWN){    //Bajar la Cámara
      if (this.cam_y + this.cam_py + num <= this.MV_y){
        this.cam_py = this.cam_py + num;
      } else if (this.cam_y + this.cam_py + num > this.MV_y){ 
        this.cam_py = this.MV_y - this.cam_y;
      }
    } else if (keyCode == RIGHT){   //Mover a la Derecha
      if (this.cam_x + this.cam_px + num <= this.MV_x){
        this.cam_px = this.cam_px + num;
      } else if (this.cam_x + this.cam_px + num > this.MV_x){
        this.cam_px = this.MV_x - this.cam_x;
      }
    } else if (keyCode == LEFT){    //Mover a la Izquierda
      if (this.cam_px - num >= 0){
        this.cam_px = this.cam_px - num;
      } else if (this.cam_px - num < 0){
        this.cam_px = 0;
      }
    }
  }
  
  
  //----------------------------|Subrutina para Zoom|----------------------------//
  //Acercamiento o alejamiento de la cámara según la rueda del ratón
  void zoom (float movimiento) {
    float num = 20;
    
    this.tm_inc = millis();
    if (this.incr <= 9) {
      this.incr = this.incr + 0.5;
    } else if (this.incr == 0) {
      this.incr = 1;
    }
    
    if (movimiento < 0) {          //Acercar Cámara (Disminuir tamaño)
      if((this.cam_y > this.MV_y/10) && (this.cam_x > this.MV_x/10)) {
        this.mov_mg = true;
        this.imagenes.reajustar();
        this.cam_y = this.cam_y - num;
        this.cam_x = this.cam_x - num;
      }
    } else if (movimiento > 0) {   //Alejar Cámara (Agrandar tamaño)
      if((this.cam_y + this.cam_py < this.MV_y) && (this.cam_x + this.cam_px < this.MV_x)) {
        this.mov_mg = true;
        this.imagenes.reajustar();
        this.cam_y = this.cam_y + num;
        this.cam_x = this.cam_x + num;
      }
    } 
  }
  
  
  //----------------------------|Subrutina para Reiniciar contadores|----------------------------//
  //Reinicia las variables de movimiento cada medio segundo
  void reiniciar () {
    if (millis() > tm_inc + 500) {
      inc = 0;  //Incremento de Movimiento
      incr = 0; //Incremento de Zoom
      
      this.imagenes.refrescar();
    }
  }
}
