import 'dart:ffi';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/basededatos/Ruta.dart';
import 'package:apptour/api/help.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:apptour/pantallas/MapScreen.dart';

import 'package:expandable_text/expandable_text.dart';

var basededatos = new DBmanager();

class pantallaRuta extends StatefulWidget {
  Ruta ruta;
  pantallaRuta(this.ruta);

  @override
  _pantallaRutaState createState() => _pantallaRutaState(this.ruta);
}

class _pantallaRutaState extends State<pantallaRuta> {
  GoogleMapController mapController;
  String _destinationsAddress;
  String _destinationsLat;
  String _destinationsLong;
  Ruta _ruta;
  _pantallaRutaState(this._ruta);
  int _likes = 0;
  bool _isLiked = false;
  var db = DBmanager();
  bool _expanded = false;
  @override
  void initState() {
    super.initState();
    _ruta = widget.ruta;
    _likes = _ruta.likes;
  }

  Future _incrementLikes(int rutaId) async {
    var db = DBmanager();
    // Incrementa el contador de likes en la base de datos y se cambia  el estado local
    _likes++;
    _isLiked = true;
    await db.actualizarLikesRuta(_likes, rutaId);
    setState(() {});
    // Realiza una solicitud POST al servidor
    final response = await http.post(
      Uri.parse(
          'http://192.168.100.39/appturismo/public/api/increment-likesruta/$rutaId'),
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
                              await _incrementLikes(_ruta.id);
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
                      basededatos.obtenerRutas("id=" + _ruta.id.toString()),
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
          title: Text(_ruta.nombre),
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
                  child: Image.network("${url}img/ruta/" + _ruta.urlfoto, 
                      height: 200, width: 500,
                      fit: BoxFit.cover),
                ),
                
                Container(
                  margin: const EdgeInsets.all(10),
                  child: _expanded
                    ? HtmlWidget(
                        _ruta.descripcion,
                        textStyle: const TextStyle(
                          height:
                              1.5, // Ajusta el espaciado entre líneas para justificar el texto
                        ),
                      )
                    : HtmlWidget(
                        _expanded
                            ? _ruta.descripcion
                            : _ruta.descripcion.split('\n').take(1).join('\n'),
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
               
              ],
            ),
          ),
        ));
  }
}
