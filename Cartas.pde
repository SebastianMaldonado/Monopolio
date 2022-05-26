/*
|------------------------------//------------------------------|
|  Página Secundaria - Funcionamiento de las Cartas            |
|------------------------------//------------------------------|
*/


/*
|====================================================================|
*                             |Cartas|
* Descripción:                                                        
*   Lista que se encarga de administrar las cartas de Fortuna y Cofre
|====================================================================|
*/

class Carta {
  PImage img;
  int efecto;
  int efecto_esp;
  
  Carta siguiente;
  
  Carta () {
    this.siguiente = null;
  }
  
  Carta (PImage img, int efecto, int efecto_esp) {
    this.img = img;
    this.efecto = efecto;
    this.efecto_esp = efecto_esp;
    this.siguiente = this;
  }
  
  
  
  void añadir_carta (PImage img, int efecto, int efecto_esp) {
    if (this.siguiente == null) {
      this.img = img;
      this.efecto = efecto;
      this.efecto_esp = efecto_esp;
      this.siguiente = this;
      return;
    }
      
    Carta nuevo = new Carta (img, efecto, efecto_esp);
    Carta temp = this;
    
    while (temp.siguiente != this) {
      temp = temp.siguiente;
    }
    
    nuevo.siguiente = this;
    temp.siguiente = nuevo;
  }
}
