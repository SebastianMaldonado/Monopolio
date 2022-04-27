/*
|----------------------------//----------------------------|
|  Página Secundaria - Ventanas Interactivas               |
|----------------------------//----------------------------|
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

  Ventana (float x, float y, float tx, float ty){
    this.x = x;
    this.y = y;
    this.tx = tx;
    this.ty = ty;
  }
  
  
  //-------------------------|Sobre Caja|-------------------------
  boolean sobre_caja (){
    if ((mouseX > this.x) && (mouseX < this.x + this.tx) && (mouseY > this.y) && (mouseY < this.y + this.ty)) {
      return true;    //Si el cursor está por encima de la ventana
    } else {
      return false;   //Si el cursor NO está por encima de la ventana
    }
  }
  
  
  //-------------------------|Mover Ventana|-------------------------
  void presionar () {
    
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
  
  
  //-------------------------|Mostrar Ventana|-------------------------
  void mostrar (){
    //Visualización de la pestaña
    rect (this.x, this.y, this.tx, this.ty);
  }
}
