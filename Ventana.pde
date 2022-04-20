/*
|----------------------------//----------------------------|
|  Página Secundaria - Ventanas Interactivas               |
|----------------------------//----------------------------|
*/


class Ventana {
  float x;
  float y;
  float tx;
  float ty;
  int cont = 0;
  boolean sobre_caja = false;
  boolean mov = false;
  float xOffset =  0.0;
  float yOffset =  0.0;
  boolean mouse_tm = false;
  boolean mouse_lb = false;

  Ventana (float x, float y, float tx, float ty){
    this.x = x;
    this.y = y;
    this.tx = tx;
    this.ty = ty;
  }
  
  void dibujar (boolean pres) {   
    //Si el cursor está por encima de la ventana
    if ((mouseX > this.x) && (mouseX < this.x + this.tx) && (mouseY > this.y) && (mouseY < this.y + this.ty)) {
      this.sobre_caja = true;  
      
      if(!this.mov) {  //Si la caja no se está moviendo
        stroke(255); 
        fill(153);
        //println("activo");
      } else {
        //println("detenido");
      }
    } else {  //Si el cursor NO está por encima de la ventana
      stroke(153);
      fill(153);
      this.sobre_caja = false;
    }
    
    //Visualización de la pestaña
    rect (this.x, this.y, this.tx, this.ty);
    
    //Presionar caja
    if ((mousePressed) && (!this.mouse_tm)){
      if(this.sobre_caja) {
        pres = true;
        this.mov = true; 
        fill(255, 255, 255);
      } else {
        this.mov = false;
      }
      
        this.xOffset = mouseX - this.x; 
        this.yOffset = mouseY - this.y; 
        mouse_tm = true;     
    }

    if (!mousePressed){
      mouse_tm = false;
    }

    
    //Mantenerla presionada
    if (mouseDragged){
      if(this.mov) {
        println("moviendo");
        this.x = mouseX - this.xOffset; 
        this.y = mouseY - this.yOffset; 
        println(this.x +"  =  "+mouseX +"  -  "+ this.xOffset);
      }
    }
  }
}
