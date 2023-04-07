import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Api {
  //final String dominio = "dominio";  // produccion
  final String dominio = "192.168.100.39"; // localhost
  final String _url1 = "/appturismo/public/api/";

  // autenticacion
  autenticacion(_data, String _url2) async {
    var ruta = _url1 + _url2;
    return await http
        .post(Uri.http(dominio, ruta), body: json.encode(_data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Connection": "Keep-Alive",
    });
  }

  // logout
  logout(String _url2) async {
    var ruta = _url1 + _url2;
    var parametros = {"token": await getToken()};
    return await http.post(Uri.http(dominio, ruta, parametros), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Connection": "Keep-Alive",
    });
  }

  // listar datos
  listarData(String _url2) async {
    var ruta = _url1 + _url2;
    var rutaFinal = dominio + ruta;
    print(rutaFinal);

    final respuesta = await http.get(Uri.http(dominio, ruta));

    return respuesta;
  }

  // insertar un registro
  agregarData(_data, _url2) async {
    var ruta = _url1 + _url2;
    var parametros = {"token": await getToken()};
    return await http.post(Uri.http(dominio, ruta, parametros),
        body: json.encode(_data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Connection": "Keep-Alive",
        });
  }

  //editar un registro
  editarData(_data, _url2, id) async {
    var ruta = _url1 + _url2 + "/" + id;
    var parametros = {"token": await getToken()};
    return await http.put(Uri.http(dominio, ruta, parametros),
        body: json.encode(_data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Connection": "Keep-Alive",
        });
  }

  // borrar un registro
  borrarData(_url2, id) async {
    var ruta = _url1 + _url2 + "/" + id;
    var parametros = {"token": await getToken()};
    return await http.delete(Uri.http(dominio, ruta, parametros), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Connection": "Keep-Alive",
    });
  }

  // recuperar token
  getToken() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    var token = local.getString("token");
    return token;
  }

  // guardar el token
  saveToken(String value) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    local.setString("token", value);
  }
}
