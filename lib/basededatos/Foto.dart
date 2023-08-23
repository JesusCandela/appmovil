class Foto {
  final int id;
  final String nombre;
  final String urlfoto;
  final int tipo;
  final int empresa_id;
  final int lugar_id;
  final int likes;

  Foto(this.id, this.nombre, this.urlfoto, this.tipo, this.empresa_id, this.lugar_id,
       this.likes);

  Map<String, dynamic> toMap() {
    var map =  Map<String, dynamic>();
    map['id'] = id;
    map['nombre'] = nombre;
    map['urlfoto'] = urlfoto;
    map['tipo'] = tipo;
    map['empresa_id'] = empresa_id;
    map['lugar_id'] = lugar_id;
    map['likes'] = likes;

    return map;
  }
}
