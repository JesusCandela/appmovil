class Ruta{
  final int id;
  final String nombre;
  final String urlfoto;

  Ruta(this.id, this.nombre, this.urlfoto);
  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['nombre'] = nombre;
    map['urlfoto'] = urlfoto;
    return map;
  }
}