import 'dart:convert';
import 'package:apptour/api/Api.dart';
import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/pantallas/pantallaAdminAgregar.dart';
import 'package:apptour/pantallas/pantallaAdminEditar.dart';
import 'package:apptour/pantallas/pantallaLogin.dart';
import 'package:apptour/pantallas/pantallaRutas.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

var basededatos = DBmanager();

class pantallaAdmin extends StatefulWidget {
  @override
  State<pantallaAdmin> createState() => _pantallaAdminState();
}

String Texto;

class _pantallaAdminState extends State<pantallaAdmin> {
  var user_id = 0;

  void _verificarUsuario() async {
    SharedPreferences preferencia = await SharedPreferences.getInstance();
    var user = json.decode(preferencia.getString("user"));
    if (user != null) {
      if (user['expired_at'] != null &&
          user['expired_at'] < DateTime.now().millisecondsSinceEpoch) {
        preferencia.clear();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext) => pantallaRutas()));
      } else {
        setState(() {
          user_id = user['id'];
          print(user_id);
        });
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaRutas()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _verificarUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administracion"),
        actions: [
          IconButton(
              icon: const Icon(Icons.input),
              onPressed: () {
                _logout();
              })
        ],
      ),
      body: SafeArea(
        child: Card(
          margin: const EdgeInsets.all(5),
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/fondo.jpg"),
              fit: BoxFit.cover,
            )),
            child: user_id != 0
                ? FutureBuilder(
                    future: basededatos
                        .obtenerEmpresas(" user_id=" + user_id.toString()),
                    builder: (c, s) {
                      if ((s.hasData) && (s.data.length > 0)) {
                        return Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                                itemCount: s.data == null ? 0 : s.data.length,
                                itemBuilder: (_c, _i) {
                                  return Container(
                                    margin: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.yellow[200],
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(5, 5),
                                              blurRadius: 10)
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: SizedBox(
                                    height: 60,
                                    width: 120,
                                    child: Marquee(
                                      text: s.data[_i].razonsocial, // El texto que quieres mostrar
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green,
                                      ),
                                      blankSpace:
                                          90, // Espacio en blanco al final del texto antes de reiniciar
                                      velocity:
                                          50, // Velocidad de desplazamiento en pixels por segundo
                                    ),
                                  ),
                                        ),
                                       
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0))),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext) =>
                                                        pantallaAdminEditar(
                                                            s.data[_i])));
                                          },
                                          child: const Text("EDITAR"),
                                        ),
                                        
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0))),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Eliminar empresa"),
                                                  content: const Text(
                                                    "¿Estás seguro de que deseas eliminar la empresa?",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.red),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text("No"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text("Sí"),
                                                      onPressed: () {
                                                        _eliminarEmpresa(
                                                            s.data[_i].id);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Text("ELIMINAR"),
                                        )
                                      ],
                                    ),
                                  );
                                }));
                      } else {
                        return const Center(child: Text("No tienes empresa"));
                      }
                    })
                : const Center(child: Text("No tienes empresas")),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          extendedPadding: const EdgeInsets.all(20),
          elevation: 2.0,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext) => pantallaAdminAgregar()));
          },
          label: const Text("AGREGAR")),
    );
  }

  void _logout() async {
    // validacion
    var respuesta = await Api().logout("logout");
    var contenido = json.decode(respuesta.body);
    if (contenido['success'] != null) {
      SharedPreferences logout = await SharedPreferences.getInstance();
      logout.remove("token");
      logout.remove("user");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaRutas()));
    } else {
      checkSession();
      print(contenido['mensaje']);
    }
  }

  void checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var expirationTime = prefs.getInt("expirationTime");
    var currentTime = DateTime.now().millisecondsSinceEpoch;

    if (expirationTime == null || currentTime > expirationTime) {
      // Token ha expirado, limpiar los datos de sesión y redirigir a la pantalla de inicio de sesión
      prefs.remove("token");
      prefs.remove("user");
      prefs.remove("expirationTime");

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaLogin()));
    }
  }

  void _eliminarEmpresa(id) async {
    var respuesta = await Api().borrarData("empresas", id.toString());
    var contenido = json.decode(respuesta.body);
    checkSession();

    if (contenido['success']) {
      print(contenido.toString());

      basededatos.borrarTablaId("empresa", id.toString());

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaAdmin()));
    }
  }
}
