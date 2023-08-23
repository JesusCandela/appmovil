import 'dart:convert';
import 'package:apptour/pantallas/pantallaAdmin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptour/api/Api.dart';
import 'package:apptour/pantallas/pantallaRegistro.dart';


class pantallaLogin extends StatefulWidget {
  const pantallaLogin({Key key}) : super(key: key);

  @override
  State<pantallaLogin> createState() => _pantallaLoginState();
}

final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

class _pantallaLoginState extends State<pantallaLogin> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void _verificarUsuario() async {
    SharedPreferences preferencia = await SharedPreferences.getInstance();
    var user = null;
    user = preferencia.getString("user");
    if (user != null) {
      user = json.decode(user);
    }

    if (user != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaAdmin()));
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
          title: const Text("Login"),
        ),
        body: Container(
          /*decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/plaza-sucre.jpg"),
            fit: BoxFit.cover,
          )),*/
          padding: EdgeInsets.all(20),
          child: Card(
            elevation: 20,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/login.png"),
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
                              prefixIcon: Icon(Icons.person)),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Ingrese datos';
                            }
                            if (!emailRegex.hasMatch(value)) {
                              return 'Los datos ingresados no tienen estructura de correo';
                            }
                            return null;
                          },
                        ), 
                        ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _password,
                        decoration: const InputDecoration(
                          hintText: "Password :",
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                    ),
                    TextButton(
                      onPressed: (_login),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.green),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No tienes una cuenta? ",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => pantallaRegistro()));
                          },
                          child: const Text("Sing Up",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _login() async {
    // validacion
    var datos = {'email': _email.text, 'password': _password.text};

    var respuesta = await Api().autenticacion(datos, "login");
    var contenido = json.decode(respuesta.body);

    if (contenido['success']) {
      SharedPreferences login = await SharedPreferences.getInstance();
      login.setString("token", contenido['token']);
      login.setString("user", json.encode(contenido['user']));

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
}
