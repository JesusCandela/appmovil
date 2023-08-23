import 'dart:convert';
import 'dart:io';
import 'package:apptour/api/Api.dart';
import 'package:apptour/pantallas/pantallaAdmin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/basededatos/Empresa.dart';
import 'package:apptour/pantallas/pantallaRutas.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var basededatos = new DBmanager();

class pantallaAdminEditar extends StatefulWidget {
  Empresa empresa;
  pantallaAdminEditar(this.empresa);

  @override
  _pantallaAdminEditarState createState() =>
      _pantallaAdminEditarState(this.empresa);
}

class _pantallaAdminEditarState extends State<pantallaAdminEditar> {
  Empresa empresa;
  _pantallaAdminEditarState(this.empresa);
  TextEditingController _title = new TextEditingController();
  TextEditingController _razonsocial = new TextEditingController();
  TextEditingController _descripcion = new TextEditingController();
  //ruta_id
  var _rutaelegida;
  var _listarutas = <DropdownMenuItem>[];
  _obtenerListaRutas() async {
    var lista = await basededatos.obtenerRutas("1");
    lista.forEach((element) {
      setState(() {
        _listarutas.add(DropdownMenuItem(
          child: Text(element.nombre),
          value: element.id,
        ));
      });
    });
  }

  // logo
  String __path;
  String image64_1;
  String _path;
  String _image64;
  // user_id
  var user_id = 0;
  void _verificarUsuario() async {
    SharedPreferences preferencia = await SharedPreferences.getInstance();
    var user = json.decode(preferencia.getString("user"));
    if (user != null) {
      setState(() {
        user_id = user['id'];
      });
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext) => pantallaRutas()));
    }
  }

  @override
  void initState() {
    _title.text = empresa.title;
    _razonsocial.text = empresa.razonsocial;
    _descripcion.text = empresa.descripcion;
    _rutaelegida = empresa.ruta_id;
    _verificarUsuario();
    _obtenerListaRutas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EDITAR EMPRESA"),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.amber, Colors.blue])),
        child: ListView(
          children: [
            Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: Colors.yellow[200],
                    borderRadius: BorderRadius.circular(10),
                    ),
              child: TextField(
              controller: _title,
              decoration: new InputDecoration(hintText: "TITLE:"),
            ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: Colors.yellow[200],
                    borderRadius: BorderRadius.circular(10),
                    ),
              
              child:TextField(
              controller: _razonsocial,
              decoration: new InputDecoration(hintText: "RAZÓN SOCIAL:"),
            ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: Colors.yellow[200],
                    borderRadius: BorderRadius.circular(10),
                    ),
              child: TextField(
              controller: _descripcion,
              decoration: new InputDecoration(hintText: "DESCRIPCIÓN:"),
            ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: Colors.yellow[200],
                    borderRadius: BorderRadius.circular(10),
                    ),
              child: TextField(
              controller: _descripcion,
              decoration: new InputDecoration(hintText: "DESCRIPCIÓN:"),
            ),),
            
            DropdownButtonFormField(
              items: _listarutas,
              value: _rutaelegida,
              onChanged: (valor) {
                setState(() {
                  _rutaelegida = valor;
                });
              },
            ),
            (__path == null)
                ? Container()
                : Image.file(
                    File(__path),
                    width: 200,
                  ),
            ElevatedButton(
              autofocus: true,
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                PickedFile _archivo =
                    await _picker.getImage(source: ImageSource.gallery);
                setState(() {
                  _path = _archivo.path;
                });

                List b = await File(_path).readAsBytesSync();
                image64_1 = base64.encode(b);
              },
              child: const Text("SELECCIONAR IMAGEN DE LA EMPRESA"),
            ),
            (_path == null)
                ? Container()
                : Image.file(
                    File(_path),
                    width: 150,
                  ),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                PickedFile _archivo =
                    await _picker.getImage(source: ImageSource.gallery);
                setState(() {
                  _path = _archivo.path;
                });

                List b = await File(_path).readAsBytesSync();
                _image64 = base64.encode(b);
              },
              child: const Text("SELECCIONAR IMAGEN PARA EL LOGO"),
            ),
            ElevatedButton(
              onPressed: () async {
                _enviarFormulario();
              },
              child: const Text("ENVIAR FORMULARIO"),
            ),
          ],
        ),
      ),
    );
  }

  void _enviarFormulario() async {
    var data = {
      'title': _title.text,
      'razonsocial': _razonsocial.text,
      'descripcion': _descripcion.text,
      'ruta_id': _rutaelegida
    };
    if (_image64 != null) {
      data = {
        'title':_title.text,
        'razonsocial': _razonsocial.text,
        'descripcion': _descripcion.text,
        'ruta_id': _rutaelegida,
        'urlfoto': image64_1,
        'urllogo': _image64,
      };
    }
    ;
    var respuesta =
        await Api().editarData(data, "empresasapi", empresa.id.toString());
    var contenido = json.decode(respuesta.body);
    if (contenido['success']) {
      print(contenido.toString());
      basededatos.actualizarEmpresa(
        Empresa(
            contenido['empresa']['id'],
            contenido['empresa']['title'],
            contenido['empresa']['razonsocial'],
            contenido['empresa']['descripcion'],
            contenido['empresa']['latitud'],
            contenido['empresa']['longitud'],
            contenido['empresa']['urlfoto'],
            contenido['empresa']['urllogo'],
            contenido['empresa']['likes'],
            contenido['empresa']['ruta_id'],
            contenido['empresa']['user_id']),
      );

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
      print("fallo la edición");
    }
  }
}
