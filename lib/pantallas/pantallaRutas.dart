import 'dart:convert';
import 'package:apptour/api/Api.dart';
import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/basededatos/Empresa.dart';
import 'package:apptour/basededatos/Foto.dart';
import 'package:apptour/basededatos/Lugar.dart';
import 'package:apptour/basededatos/Ruta.dart';
import 'package:apptour/pantallas/pantallaEmpresas.dart';
import 'package:apptour/pantallas/pantallaRegistro.dart';
import 'package:apptour/pantallas/pantallaLugares.dart';
import 'package:apptour/api/help.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apptour/pantallas/pantallaLogin.dart';
import 'package:flutter/rendering.dart';

var basededatos = DBmanager();

class pantallaRutas extends StatefulWidget {
  @override
  _pantallaRutasState createState() => _pantallaRutasState();
}

class _pantallaRutasState extends State<pantallaRutas> {
  bool descargacompleta = false;

  //Cargar datos a base de datos local
  void obtenerJson() async {
    var respuesta = await Api().listarData("listajson");
    var body = json.decode(respuesta.body);
    if (body['success']) {
      // ruta
      basededatos.borrarTabla("ruta");
      for (var registro in body['listarutas']) {
        Ruta ruta =
            Ruta(registro['id'], registro['nombre'], registro['urlfoto']);
        basededatos.insertarRuta(ruta);
      }
      // empresa
      basededatos.borrarTabla("empresa");
      for (var Data in body['listaempresas']) {
        Empresa empresa = Empresa(
            Data['id'],
            Data['title'],
            Data['razonsocial'],
            Data['descripcion'],
            Data['urlfoto'],
            Data['urllogo'],
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
            Data['ruta_id']);
        basededatos.insertarLugar(lugar);
      }

      // tabla foto
      basededatos.borrarTabla("foto");
      for (var Data in body['listafotos']) {
        Foto foto = Foto(Data['id'], Data['nombre'], Data['urlfoto'],
            Data['tipo'], Data['lugar_id']);
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
        title: Text("RUTAS"),
        actions: <Widget>[
  IconButton(
    icon: Icon(Icons.refresh),
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
                            return Card(
                              elevation: 20,
                              margin: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(
                                    "${url}img/ruta/" +
                                        snapshot.data[_i].urlfoto,
                                    width: 155,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Column(
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
                                        children: [
                                          ElevatedButton(
                                              child: const Text("Empresas"),
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
                                              child: const Text("Lugares"),
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
                                  )
                                ],
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("NO EXISTE INFORMACION"));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlue,
                        ),
                      );
                    }
                  })
              : const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: LinearProgressIndicator(
                      minHeight: 10.0,
                      semanticsLabel: "Cargando información",
                      backgroundColor: Colors.lightBlue,
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
