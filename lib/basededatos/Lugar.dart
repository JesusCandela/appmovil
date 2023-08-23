class Lugar {
  final int id;
  final String nombre;
  final String descripcion;
  final String urlfoto;
  final String latitud;
  final String longitud;
  final int likes;
  final int ruta_id;

  Lugar(this.id, this.nombre, this.descripcion, this.urlfoto, this.latitud,
      this.longitud, this.likes, this.ruta_id);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['nombre'] = nombre;
    map['descripcion'] = descripcion;
    map['urlfoto'] = urlfoto;
    map['latitud'] = latitud;
    map['longitud'] = longitud;
    map['likes'] = likes;
    map['ruta_id'] = ruta_id;
    return map;
  }
}
