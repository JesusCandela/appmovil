class Empresa {
  final int id;
  final String title;
  final String razonsocial;
  final String descripcion;
  final String latitud;
  final String longitud;
  final String urlfoto;
  final String urllogo;
  final int likes;
  final int ruta_id;
  final int user_id;

  Empresa(this.id, this.title, this.razonsocial, this.descripcion,this.latitud,this.longitud, this.urlfoto,
      this.urllogo, this.likes, this.ruta_id, this.user_id);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['razonsocial'] = razonsocial;
    map['descripcion'] = descripcion;
    map['latitud'] = latitud;
    map['longitud'] = longitud;
    map['urlfoto'] = urlfoto;
    map['urllogo'] = urllogo;
    map['likes'] = likes;
    map['ruta_id'] = ruta_id;
    map['user_id'] = user_id;
    return map;
  }
}
