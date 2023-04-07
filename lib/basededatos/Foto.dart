class Foto {
  final int id;
  final String nombre;
  final String urlfoto;
  final int tipo;
  final int lugar_id;

  Foto(this.id, this.nombre, this.urlfoto, this.tipo, this.lugar_id);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['nombre'] = nombre;
    map['urlfoto'] = urlfoto;
    map['tipo'] = tipo;
    map['lugar_id'] = lugar_id;

    return map;
  }
}
