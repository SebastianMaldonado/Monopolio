/*
|----------------------------//----------------------------|
|  Página Secundaria - Funcionamiento de Interfaz          |
|----------------------------//----------------------------|
*/

class Interfaz {
  
  Animacion animacion;
  boolean pasar_turno;
  
  Interfaz () {
    Animacion animacion = new Animacion ();  //Generador de Animaciones
    this.animacion = animacion;
  }
  
  void pantalla_inicio () {  
  }

  void opciones () {  
  }

  void jugadores () {  
  }

  void seleccion () {  
  }

  void mostrar_tablero () {
  }
  
  void mostrar_inventario() {
  }
  
  void mostrar_cartera () { 
  }
  
  void anuncio () {
  }
  
  void activar_pase (Lista_interfaz cola) {
    boolean permiso = true;
    
    //Validar permiso para pasar turno
    if (cola.interfaz != null)
      permiso = false;
      
    if (permiso){  //Cuando se puede pasar turno
      
    } else {      //Cuando NO se puede pasar turno
    
    }
  }
  
}

class Animacion {
  
  void lanzar_dados () {
  }
  
  void mover_ficha () {
  }
  
  
}
