class Video {
  final int id;
  final String titulo;
  final String url_video;
  final int empresa_id;
  

  Video(this.id, this.titulo, this.url_video, this.empresa_id,);

  Map<String, dynamic> toMap() {
    var map =  Map<String, dynamic>();
    map['id'] = id;
    map['titulo'] = titulo;
    map['url_video'] = url_video;
    map['empresa_id'] = empresa_id;

    return map;
  }
}
