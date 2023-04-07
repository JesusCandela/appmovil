import 'dart:ui';
import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/basededatos/Lugar.dart';
import 'package:apptour/pantallas/PantallaFoto.dart';
import 'package:apptour/api/help.dart';
import 'package:flutter/material.dart';
import 'package:apptour/pantallas/pantallaportadagps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apptour/pantallas/MapScreen.dart';


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
  double _destinationsLat;
  double _destinationsLong;
  Lugar _lugar;
  _pantallaLugarState(this._lugar);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_lugar.nombre),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.amber, Colors.green]),
          ),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize : MainAxisSize.max,
            children: [
              Image.network("${url}img/lugar/" + _lugar.urlfoto),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(_lugar.descripcion),
              ),
              Expanded(
                flex: 2,
                child: FutureBuilder(
                  future: basededatos
                      .obtenerFotos("lugar_id=" + _lugar.id.toString()),
                  builder: (c, s) {
                    if (s.hasData) {
                      return GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: s.data == null ? 0 : s.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1.5)),
                          itemBuilder: (_c, _i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext) =>
                                        pantallaFoto(s.data[_i])));
                              },
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Image.network(                                      
                                      "${url}img/foto/" + s.data[_i].urlfoto,
                                      width: 150,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(s.data[_i].nombre),
                                ],
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: Text("No hay fotos"),
                      );
                    }
                  },
                ),
              ),
              Expanded(                
                child: FutureBuilder(
                  future:
                      basededatos.obtenerLugares("id=" + _lugar.id.toString()),
                  builder: (c, s) {
                    if (s.hasData) {
                      return GridView.builder(
                          itemCount: s.data == null ? 0 : s.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1.5)),
                          itemBuilder: (_c, _i) {
                            _destinationsAddress = s.data[_i].nombre;
                            _destinationsLat = double.parse(s.data[_i].latitud);
                            _destinationsLong =
                                double.parse(s.data[_i].longitud);

                            return 
                            
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: [ 
                                                           
                             FloatingActionButton(
                                  onPressed:   () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapScreen(
                destinationAddress: _destinationsAddress,
                destinationLat: _destinationsLat,
                destinationLong: _destinationsLong
              )
            )
          );
        },
        child: const Icon(Icons.navigation))
        
                                  ,],
                            );
                          });
                    } else {
                      return const Center(
                        child: Text("No hay guia para este destino"),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }

 
}
