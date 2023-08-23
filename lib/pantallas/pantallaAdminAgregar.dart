import 'dart:convert';
import 'dart:io';
import 'package:apptour/api/Api.dart';
import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/basededatos/Empresa.dart';
import 'package:apptour/pantallas/pantallaAdmin.dart';
import 'package:apptour/pantallas/pantallaRutas.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

var basededatos = new DBmanager();

class pantallaAdminAgregar extends StatefulWidget {
  @override
  _pantallaAdminAgregarState createState() => _pantallaAdminAgregarState();
}

class _pantallaAdminAgregarState extends State<pantallaAdminAgregar> {
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
  String _path;
  String __path;
  String _image64;
  String _image64_1;
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
    // TODO: implement initState
    _verificarUsuario();
    _obtenerListaRutas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("INSERTAR EMPRESA"),
      ),
      body: Container(
        color: Colors.grey[400],
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: Colors.yellow[200],
                    borderRadius: BorderRadius.circular(10),
                    ),
                  child: TextField(
                  controller: _title,
                  decoration: InputDecoration(
                      
                      hintText: "Titulo: ",
                      hoverColor: Colors.blue[100],
                      fillColor: Colors.amber[200]),
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
                  decoration: InputDecoration(
                      hintText: "RAZÓN SOCIAL: ",
                      hoverColor: Colors.blue[100],
                      fillColor: Colors.amber[200]),
                ), 
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: Colors.yellow[200],
                    borderRadius: BorderRadius.circular(10),
                    ),
                    child: 
                    TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 6,
                      maxLines: null,

                      controller: _descripcion,
                      decoration: InputDecoration(
                          hintText: "DESCRIPCIÓN: ",
                          hoverColor: Colors.blue[100],
                          fillColor: Colors.amber[200]),
                    ),
                    ),

                
                Container(
                  color: Colors.amber[100],
                  child: DropdownButtonFormField(
                    focusColor: Colors.amberAccent[100],
                    dropdownColor: Colors.blue[100],
                    items: _listarutas,
                    value: _rutaelegida,
                    decoration: const InputDecoration(hintText: "Seleccione  una ruta",  ),
                    onChanged: (valor) {
                      setState(() {
                        _rutaelegida = valor;
                      });
                    },
                  ),
                ),
                (__path == null)
                    ? Container()
                    : Image.file(
                        File(__path),
                        width: 150,
                        height: 200,
                      ),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    /* PickedFile */ XFile _archivo = await _picker
                        .pickImage /* getImage */ (source: ImageSource.gallery);
                    setState(() {
                      __path = _archivo.path;
                    });
                    

                    List b = await File(__path).readAsBytesSync();
                    _image64_1 = base64.encode(b);
                  },
                  style:
                    ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      primary: Colors.green,
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image),
                      SizedBox(width: 8,),
                       Text("SELECCIONAR FOTO DE LA EMPRESA"),
                    ],
                  ),
                ),
                (_path == null)
                    ? Container()
                    : Image.file(
                        File(_path),
                        width: 100,
                        height: 150,
                      ),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    XFile _archivo =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      _path = _archivo.path;
                    });
                    

                    List b = await File(_path).readAsBytesSync();
                    _image64 = base64.encode(b);
                  },
                  style:
                    ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      primary: Colors.green,
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image),
                      SizedBox(width: 8,),
                      Text("SELECCIONAR LOGO DE LA EMPRESA"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _enviarFormulario();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.send_and_archive),
                      SizedBox(width: 8,),
                      Text("ENVIAR FORMULARIO"),
                    ],
                  ),
                ),
              ],
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
      'user_id': user_id,
      'ruta_id': _rutaelegida,
      'urlfoto': _image64_1,
      'urllogo': _image64,
    };
    var respuesta = await Api().agregarData(data, "empresasapi");
    var contenido = json.decode(respuesta.body);
    if (contenido['success'] != null) {
      print(contenido.toString());
      basededatos.insertarEmpresa(Empresa(
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
          contenido['empresa']['user_id']));

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
      print("fallo la inserción");
    }
  }
}
