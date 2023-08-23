import 'dart:ffi';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:apptour/basededatos/Empresa.dart';
import 'package:apptour/api/help.dart';
import 'package:flutter/material.dart';
import 'package:apptour/basededatos/DBmanager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:video_player/video_player.dart';

import 'MapScreen.dart';

class pantallaEmpresa extends StatefulWidget {
  Empresa _empresa;
  pantallaEmpresa(this._empresa);
  @override
  _pantallaEmpresaState createState() => _pantallaEmpresaState(this._empresa);
}

class _pantallaEmpresaState extends State<pantallaEmpresa> {
  Empresa _empresa;
  _pantallaEmpresaState(this._empresa);
  int _likes = 0;
  bool _isLiked = false;
  var db = DBmanager();
  bool _expanded = false;
  GoogleMapController mapController;
  String _destinationsAddress;
  String _destinationsLat;
  String _destinationsLong;

  @override
  void initState() {
    super.initState();
    _empresa = widget._empresa;
    _likes = _empresa.likes;
    _destinationsAddress = _empresa.razonsocial;
    _destinationsLat = _empresa.latitud;
    _destinationsLong = _empresa.longitud;
  }

  Future<Void> _incrementLikes(int empresaId) async {
    var db = DBmanager();
    // Incrementa el contador de likes en la base de datos y se cambia  el estado local
    _likes++;
    _isLiked = true;
    await db.actualizarLikesEmpresa(_likes, empresaId);
    setState(() {});
    // Realiza una solicitud POST al servidor
    final response = await http.post(
      Uri.parse(
          'http://192.168.100.39/appturismo/public/api/increment-likesempresa/$empresaId'),
    );

    if (response.statusCode == 200) {
      // Actualización exitosa en el servidor
      print('Likes actualizados en el servidor');
    } else {
      // Manejo de errores en caso de falla
      print('Error al actualizar likes en el servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: _isLiked
                    ? null
                    : () async {
                        await _incrementLikes(_empresa.id);
                      },
                icon: _isLiked
                    ? const Icon(
                        Icons.thumb_up_alt_outlined,
                        color: Colors.blue,
                        size: 40,
                      )
                    : const Icon(
                        Icons.thumb_up,
                        color: Colors.blue,
                        size: 40,
                      )),
            FutureBuilder(
              future: db.obtenerEmpresas("id=" + _empresa.id.toString()),
              builder: (c, s) {
                if (s.hasData) {
                  return FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapScreen(
                                    destinationAddress: _destinationsAddress,
                                    destinationLat:
                                        double.parse(_destinationsLat),
                                    destinationLong:
                                        double.parse(_destinationsLong))));
                      },
                      child: const Icon(Icons.navigation));
                } else {
                  return const Center(
                    child: Text("No hay guia para este destino"),
                  );
                }
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(_empresa.razonsocial),
      ),
      body: Container(
        height: 800,
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.topCenter,
        color: Colors.yellow[50],
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(0.0)),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black12,
                      width: 5.0,
                      style: BorderStyle.solid),
                  shape: BoxShape.rectangle,
                ),
                child: Image.network("${url}img/empresa/" + _empresa.urlfoto,
                    width: 500, height: 200, fit: BoxFit.cover),
              ),
              const Padding(padding: EdgeInsets.all(8.0)),
              _expanded
                  ? HtmlWidget(
                      _empresa.descripcion,
                      textStyle: const TextStyle(
                        height:
                            1.5, // Ajusta el espaciado entre líneas para justificar el texto
                      ),
                    )
                  : HtmlWidget(
                      _expanded
                          ? _empresa.descripcion
                          : _empresa.descripcion.split('\n').take(1).join('\n'),
                      textStyle: const TextStyle(
                        height:
                            1.5, // Ajusta el espaciado entre líneas para justificar el texto
                      ),
                    ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                child: Text(
                  _expanded ? "Mostrar menos" : "Mostrar más",
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              FutureBuilder(
                future: db.obtenerFotos("empresa_id=" + _empresa.id.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Error al cargar las fotos");
                  } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                    return const Center(child: Text("No hay fotos"));
                  } else {
                    return CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 0.5,
                        aspectRatio: 1.45,
                        autoPlay: true,
                        //enlargeCenterPage: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        onPageChanged: (index, reason) {
                          // Manejar el cambio de página (opcional)
                        },
                      ),
                      items: snapshot.data.map<Widget>((item) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Image.network(
                                    "${url}img/foto/" + item.urlfoto,
                                    width: 150,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Manejar errores aquí, por ejemplo, mostrar una imagen de error o un mensaje
                                      return Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 48.0,
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: 
                                      Center(child: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold),)),
                                    
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              FutureBuilder(
                future:
                    db.obtenerVideos("empresa_id=" + _empresa.id.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Error al cargar los videos");
                  } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                    return const Center(child: Text("No hay videos"));
                  } else {
                    return CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 0.8,
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        pauseAutoPlayOnTouch: true,

                        enlargeCenterPage: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 1800),
                        onPageChanged: (index, reason) {
                          // Manejar el cambio de página (opcional)
                        },
                      ),
                      items: snapshot.data.map<Widget>((item) {
                        final videoUrl = "${url}storage/${item.url_video}";
                        final videoController =
                            VideoPlayerController.network(videoUrl);

                        videoController.initialize().then((_) {
                          videoController
                              .setLooping(true); // Opcional: Repetir el video
                          videoController
                              .play();
                          // Opcional: Iniciar la reproducción automáticamente
                        });
                        // Opcional: Iniciar la reproducción automáticamente

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: AspectRatio(
                                aspectRatio: videoController.value.aspectRatio,
                                child: VideoPlayer(videoController),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              Text(
                " Likes: $_likes",
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
