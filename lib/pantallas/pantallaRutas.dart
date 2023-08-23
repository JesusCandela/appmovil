import 'dart:convert';
import 'package:apptour/api/Api.dart';
import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/basededatos/Empresa.dart';
import 'package:apptour/basededatos/Foto.dart';
import 'package:apptour/basededatos/Lugar.dart';
import 'package:apptour/basededatos/Ruta.dart';
import 'package:apptour/basededatos/Video.dart';
import 'package:apptour/pantallas/pantallaEmpresas.dart';
import 'package:apptour/pantallas/pantallaRegistro.dart';
import 'package:apptour/pantallas/pantallaLugares.dart';
import 'package:apptour/api/help.dart';
import 'package:apptour/pantallas/pantallaRuta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apptour/pantallas/pantallaLogin.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

var basededatos = DBmanager();

class pantallaRutas extends StatefulWidget {
  @override
  _pantallaRutasState createState() => _pantallaRutasState();
}

class _pantallaRutasState extends State<pantallaRutas> {
  bool descargacompleta = false;
  int _hoveredIndex = -1;

  //Cargar datos a base de datos local
  void obtenerJson() async {
    var respuesta = await Api().listarData("listajson");
    var body = json.decode(respuesta.body);
    if (body['success']) {
      // ruta
      basededatos.borrarTabla("ruta");
      for (var registro in body['listarutas']) {
        Ruta ruta = Ruta(registro['id'], registro['nombre'],
            registro['urlfoto'], registro['descripcion'], registro['likes']);
        basededatos.insertarRuta(ruta);
      }
      basededatos.borrarTabla("video");
      for (var registro in body['listavideo']) {
        Video video = Video(registro['id'], registro['titulo'],
            registro['url_video'], registro['empresa_id']);
        basededatos.insertarVideo(video);
        print("video" + video.toString());
      }
      // empresa
      basededatos.borrarTabla("empresa");
      for (var Data in body['listaempresas']) {
        Empresa empresa = Empresa(
            Data['id'],
            Data['title'],
            Data['razonsocial'],
            Data['descripcion'],
            Data['latitud'],
            Data['longitud'],
            Data['urlfoto'],
            Data['urllogo'],
            Data['likes'],
            Data['ruta_id'],
            Data['user_id']);
        basededatos.insertarEmpresa(empresa);
        print("empresa" + empresa.toString());
      }
      // tabla lugar
      basededatos.borrarTabla("lugar");
      for (var Data in body['listalugares']) {
        Lugar lugar = Lugar(
            Data['id'],
            Data['nombre'],
            Data['descripcion'],
            Data['urlfoto'],
            Data['latitud'],
            Data['longitud'],
            Data['likes'],
            Data['ruta_id']);
        basededatos.insertarLugar(lugar);
      }

      // tabla foto
      basededatos.borrarTabla("foto");
      for (var Data in body['listafotos']) {
        Foto foto = Foto(Data['id'], Data['nombre'], Data['urlfoto'],
            Data['tipo'], Data['empresa_id'], Data['lugar_id'], Data['likes']);
        basededatos.insertarFoto(foto);
      }

      setState(() {
        descargacompleta = true;
      });
    } else {
      print("FALLO");
    }
  }

  @override
  void initState() {
    obtenerJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("RUTAS"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                descargacompleta = false;
              });
              obtenerJson();
            },
          ),
        ],
      ),
      backgroundColor: Colors.amber,
      body: Container(
          child: descargacompleta
              ? FutureBuilder(
                  future: basededatos.obtenerRutas("1"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // listview
                      return ListView.builder(
                          itemCount:
                              snapshot.data == null ? 0 : snapshot.data.length,
                          itemBuilder: (_c, _i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push((MaterialPageRoute(
                                    builder: (BuildContext) =>
                                        pantallaRuta(snapshot.data[_i]))));
                              },
                              onTapDown: (_) {
                                setState(() {
                                  _hoveredIndex = _i;
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  _hoveredIndex = -1;
                                });
                              },
                              child: Transform.scale(
                                scale: _hoveredIndex == _i ? 1.05 : 1.0,
                                child: Card(
                                  elevation: _hoveredIndex == _i ? 80 : 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  color: _hoveredIndex == _i
                                      ? Colors
                                          .greenAccent // Color cuando está en "hover"
                                      : Colors.white70, // Color normal
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 4),
                                        child: Image.network(
                                          "${url}img/ruta/" +
                                              snapshot.data[_i].urlfoto,
                                          width: 147,
                                          height: 93,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                snapshot.data[_i].nombre,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 18,
                                                    color: Colors.green),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    child:
                                                        const Text("Empresas"),
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext) =>
                                                                  pantallaEmpresas(
                                                                      snapshot.data[
                                                                          _i])));
                                                    }),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                ElevatedButton(
                                                    child:
                                                        const Text("Lugares"),
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext) =>
                                                                  pantallaLugares(
                                                                      snapshot.data[
                                                                          _i])));
                                                    })
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("NO EXISTE INFORMACION"));
                    } else {
                      return const Center(
                          child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: SpinKitFadingCircle(
                                color: Colors.lightBlue,
                                size: 50.0,
                              )));
                    }
                  })
              : const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: SpinKitFoldingCube(
                      color: Colors.blue,
                      size: 200,
                    ),
                  ),
                )),
      drawer: menuLateral(),
    );
  }
}

class menuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.amber, Colors.green])),
      child: Drawer(
        backgroundColor: Colors.lime,
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amber, Colors.green])),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                margin: const EdgeInsets.all(5.0),
                color: Colors.white,
                child: Center(
                  child: ElevatedButton(
                    child: const SizedBox(
                        height: 30.0,
                        width: 200,
                        child: Center(
                          child: Text("Login"),
                        )),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext) => pantallaLogin()));
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                color: Colors.white,
                child: Center(
                  child: ElevatedButton(
                    child: const SizedBox(
                        height: 30.0,
                        width: 200,
                        child: Center(
                          child: Text("Sing Up"),
                        )),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext) => pantallaRegistro()));
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
