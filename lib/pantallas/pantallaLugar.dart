import 'dart:ui';
import 'dart:ffi';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/basededatos/Lugar.dart';
import 'package:apptour/pantallas/PantallaFoto.dart';
import 'package:apptour/api/help.dart';
import 'package:flutter/material.dart';
import 'package:apptour/pantallas/pantallaportadagps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apptour/pantallas/MapScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:expandable_text/expandable_text.dart';

var basededatos = new DBmanager();

class pantallaLugar extends StatefulWidget {
  Lugar lugar;
  pantallaLugar(this.lugar);

  @override
  _pantallaLugarState createState() => _pantallaLugarState(this.lugar);
}

class _pantallaLugarState extends State<pantallaLugar> {
  GoogleMapController mapController;
  String _destinationsAddress;
  String _destinationsLat;
  String _destinationsLong;
  Lugar _lugar;
  _pantallaLugarState(this._lugar);
  int _likes = 0;
  bool _isLiked = false;
  bool _expanded = false;
  var db = DBmanager();
  @override
  void initState() {
    super.initState();
    _lugar = widget.lugar;
    _destinationsLat = _lugar.latitud;
    _destinationsLong = _lugar.longitud;
    _likes = _lugar.likes;
    _destinationsAddress = _lugar.nombre;
  }

  Future<Void> _incrementLikes(int lugarId) async {
    var db = DBmanager();
    // Incrementa el contador de likes en la base de datos y se cambia  el estado local
    _likes++;
    _isLiked = true;
    await db.actualizarLikesLugar(_likes, lugarId);
    setState(() {});
    // Realiza una solicitud POST al servidor
    final response = await http.post(
      Uri.parse(
          'http://192.168.100.39/appturismo/public/api/increment-likeslugar/$lugarId'),
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
        margin: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
             IconButton(
                      onPressed: _isLiked
                          ? null
                          : () async {
                              await _incrementLikes(_lugar.id);
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
                            )
                    ),
          
                FutureBuilder(
                  future:
                      basededatos.obtenerLugares("id=" + _lugar.id.toString()),
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
                
        ),
        
          ],
          )
        
        ),
    
           
        appBar: AppBar(
          title: Text(_lugar.nombre),
        ),
        body: Container(
          height: 1000,
          color: Colors.yellow.shade50,          
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(padding: EdgeInsets.all(0.0)),
                Container(
                  decoration:  BoxDecoration( 
                  border: Border.all( color: Colors.black12,width: 5.0, style: BorderStyle.solid),
                    shape: BoxShape.rectangle,
                    ),
                  child: Image.network("${url}img/lugar/" + _lugar.urlfoto, 
                      height: 200, width: 500,
                      fit: BoxFit.cover),
                ),
                
                Container(
                  margin: const EdgeInsets.all(10),
                  child: _expanded
                    ? HtmlWidget(
                        _lugar.descripcion,
                        textStyle: const TextStyle(
                          height:
                              1.5, // Ajusta el espaciado entre líneas para justificar el texto
                        ),
                      )
                    : HtmlWidget(
                        _expanded
                            ? _lugar.descripcion
                            : _lugar.descripcion.split('\n').take(1).join('\n'),
                        textStyle: const TextStyle(
                          height:
                              1.5, // Ajusta el espaciado entre líneas para justificar el texto
                        ),
                      ),
                ),
              
               GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                child: Padding(                  
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    _expanded ? "Mostrar menos" : "Mostrar más",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ),
                FutureBuilder(
                  future: basededatos
                      .obtenerFotos("lugar_id=" + _lugar.id.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text("Error al cargar las fotos");
                    } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                      return const Center(child: const Text("No hay fotos"));
                    } else {
                      return CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 0.8,
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          onPageChanged: (index, reason) {
                            // Manejar el cambio de página (opcional)
                          },
                        ),
                        items: snapshot.data.map<Widget>((item) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 400,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black38,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  "${url}img/foto/" + item.urlfoto,
                                  width: 150,
                                  height: 400,
                                  fit: BoxFit.cover,
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
        ));
  }
}
