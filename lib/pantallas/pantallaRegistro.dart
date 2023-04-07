import 'dart:convert';
import 'package:apptour/pantallas/pantallaAdmin.dart';
import 'package:apptour/pantallas/pantallaRutas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptour/api/Api.dart';
import 'package:flutter/material.dart';

class pantallaRegistro extends StatefulWidget {
  @override
  _pantallaRegistroState createState() => _pantallaRegistroState();
}

class _pantallaRegistroState extends State<pantallaRegistro> {
  TextEditingController _nombre = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("REGISTRO"),
        ),
        backgroundColor: Colors.amber,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/plaza-sucre.jpg"),
            fit: BoxFit.cover,
          )),
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Card(
              color: Colors.transparent,
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset("assets/autentication.png"),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _nombre,
                        decoration: const InputDecoration(
                            hintText: "Nombre :", prefixIcon: Icon(Icons.person)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                          controller: _email,
                          decoration: const InputDecoration(
                              hintText: "Correo :",
                              prefixIcon: Icon(Icons.email))),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _password,
                        decoration: const InputDecoration(
                            hintText: "Password :", prefixIcon: Icon(Icons.lock)),
                        obscureText: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _password,
                        decoration: const InputDecoration(
                            hintText: "Repeat the Password :", prefixIcon: Icon(Icons.lock)),
                        obscureText: true,
                      ),
                    ),
                    TextButton(
                      onPressed: (_registro),
                      child: const Text(
                        "REGISTRO",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _registro() async {
    // validacion
    var datos = {
      'name': _nombre.text,
      'email': _email.text,
      'password': _password.text
    };

    var respuesta = await Api().autenticacion(datos, "registro");
    var contenido = json.decode(respuesta.body);
    if (contenido['success']) {
      SharedPreferences registro = await SharedPreferences.getInstance();
      registro.setString("token", contenido['token']);
      registro.setString("user", json.encode(contenido['user']));

      print(contenido['token']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaAdmin()));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Datos incorrectos"),
                content: const Text(
                    "Por favor, revisa los datos ingresados e intenta nuevamente."),
                actions: <Widget>[
                  TextButton(
                      child: const Text("Aceptar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          });
      print(contenido['mensaje']);
    }
  }

  void _verificarUsuario() async {
    SharedPreferences preferencia = await SharedPreferences.getInstance();
    if (preferencia.getString("user") != null) {
      var user = json.decode(preferencia.getString("user"));
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext) => pantallaAdmin()));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _verificarUsuario();
    super.initState();
  }
}
