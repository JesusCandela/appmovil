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
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _nombre,
                        decoration: const InputDecoration(
                            hintText: "Nombre :",
                            prefixIcon: Icon(Icons.person)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              hintText: "Correo :",
                              prefixIcon: Icon(Icons.email))),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _password,
                        decoration: const InputDecoration(
                            hintText: "Password :",
                            prefixIcon: Icon(Icons.lock)),
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
                    ),
                    TextButton(
                      onPressed: (_registro),
                      child: const Text(
                        "REGISTRO",
                        style: TextStyle(color: Colors.white),
                      ),
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  bool validarEmail(String email) {
    // Expresión regular para validar formato de correo electrónico
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void _registro() async {
    // validacion
    // Validar campos antes de enviar datos
    if (_nombre.text.isEmpty ||
        _password.text.isEmpty ||
        !validarEmail(_email.text)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: const Text(
              'Por favor, complete todos los campos y asegúrese de que el correo electrónico tenga un formato válido.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      var datos = {
        'name': _nombre.text,
        'email': _email.text,
        'password': _password.text
      };

      var respuesta = await Api().autenticacion(datos, "registro");
      var contenido = json.decode(respuesta.body);
      //var response = json.decode(respuesta);

      if (respuesta.statusCode == 422) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Aelrta!",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.00),
                ),
                content: const Text(
                    "El correo que desea registrar ya se encuentra en uso, intente  con un correo diferente"),
                actions: <Widget>[
                  TextButton(
                      child: const Text("Aceptar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      } else if (respuesta.statusCode == 200) {
        if (contenido['success']) {
          SharedPreferences registro = await SharedPreferences.getInstance();
          registro.setString("token", contenido['token']);
          registro.setString("user", json.encode(contenido['user']));

          print(contenido['token']);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return FutureBuilder(
                    future: Future.delayed(Duration(seconds: 4)),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return Container(
                          child: const AlertDialog(
                        content: Text("Registro realizado satisfactoriamente"),
                        actions: [],
                      ));
                    });
              });
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext) => pantallaAdmin()));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text("Error!"),
                    content: const Text(
                        "Al parecer ocurrio un problema, intenta nuevamente"),
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
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text("Error!"),
                  content: const Text(
                      "Al parecer ocurrio un problema en el lado del servidor, intenta nuevamente mas tarde "),
                  actions: <Widget>[
                    TextButton(
                        child: const Text("Aceptar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]);
            });
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
}
