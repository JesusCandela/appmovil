import 'package:apptour/basededatos/Empresa.dart';
import 'package:apptour/basededatos/Foto.dart';
import 'package:apptour/basededatos/Lugar.dart';
import 'package:apptour/basededatos/Ruta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';

class DBmanager {
  // BASE

  static Future<Database> _openDb() async {
    return openDatabase(join(await getDatabasesPath(), 'apptuor'),
        onCreate: (db, version) {
          return db.execute(
              "CREATE TABLE ruta(id INTEGER, nombre TEXT, urlfoto TEXT);"
              "CREATE TABLE empresa(id INTEGER,title TEXT, razonsocial TEXT, descripcion TEXT, urlfoto TEXT, urllogo TEXT, ruta_id INTEGER, user_id INTEGER);"
              "CREATE TABLE lugar(id INTEGER, nombre TEXT, descripcion TEXT, urlfoto TEXT, latitud TEXT, longitud TEXT, ruta_id INTEGER);"
              "CREATE TABLE foto(id INTEGER, nombre TEXT, urlfoto TEXT, tipo INTEGER, lugar_id INTEGER);");
        },
        version: 1,
        onOpen: (db) {
          //db.execute("ALTER TABLE empresa ADD urlfoto TEXT AFTER descripcion");
          db.execute(
              "CREATE TABLE IF NOT EXISTS ruta(id INTEGER, nombre TEXT, urlfoto TEXT);");
          db.execute(
              "CREATE TABLE IF NOT EXISTS empresa(id INTEGER,title TEXT, razonsocial TEXT, descripcion TEXT,urlfoto TEXT, urllogo TEXT, ruta_id INTEGER, user_id INTEGER);");
          db.execute(
              "CREATE TABLE IF NOT EXISTS lugar(id INTEGER, nombre TEXT, descripcion TEXT, urlfoto TEXT, latitud TEXT, longitud TEXT, ruta_id INTEGER);");
          db.execute(
              "CREATE TABLE IF NOT EXISTS foto(id INTEGER, nombre TEXT, urlfoto TEXT, tipo INTEGER, lugar_id INTEGER);");
       });
  }

// métodos
// rutas
  Future<int> insertarRuta(Ruta modelo) async {
    var bd = await _openDb();

    return await bd.insert("ruta", modelo.toMap());
  }

  Future<List<Ruta>> obtenerRutas(String condicion) async {
    var basededatos = await _openDb();
    List<Map> lista =
        await basededatos.rawQuery("SELECT * FROM ruta WHERE " + condicion);
    List<Ruta> rutas = [];
    for (int i = 0; i < lista.length; i++) {
      rutas.add(Ruta(lista[i]['id'], lista[i]['nombre'], lista[i]['urlfoto']));
    }
    return rutas;
  }

// EMPRESA
  Future<int> insertarEmpresa(Empresa empresa) async {
    var basedetados = await _openDb();
    int respuesta = await basedetados.insert("empresa", empresa.toMap());
    return respuesta;
  }

  Future<List<Empresa>> obtenerEmpresas(String condicion) async {
    var basededatos = await _openDb();
    List<Map> lista =
        await basededatos.rawQuery("SELECT * FROM empresa WHERE " + condicion);
    List<Empresa> empresas = [];
    for (int i = 0; i < lista.length; i++) {
      empresas.add(Empresa(
        lista[i]['id'],
        lista[i]['title'],
        lista[i]['razonsocial'],
        lista[i]['descripcion'],
        lista[i]['urlfoto'],
        lista[i]['urllogo'],
        lista[i]['ruta_id'],
        lista[i]['user_id'],
      ));
    }
    return empresas;
  }

  Future<int> actualizarEmpresa(Empresa empresa) async {
    var base = await _openDb();
    return await base.update("empresa", empresa.toMap(),
        where: 'id= ?', whereArgs: [empresa.id]);
  }

  Future<int> borrarTablaId(tabla, id) async {
    var base = await _openDb();
    return await base.delete(tabla, where: 'id= ?', whereArgs: [id]);
  }

  // LUGAR
  Future<int> insertarLugar(Lugar lugar) async {
    var base = await _openDb();
    int respuesta = await base.insert("lugar", lugar.toMap());
    return respuesta;
  }

  Future<List<Lugar>> obtenerLugares(String condicion) async {
    var base = await _openDb();
    List<Map> lista =
        await base.rawQuery("SELECT * FROM lugar WHERE " + condicion);
    List<Lugar> lugares = [];
    for (int i = 0; i < lista.length; i++) {
      lugares.add(Lugar(
          lista[i]['id'],
          lista[i]['nombre'],
          lista[i]['descripcion'],
          lista[i]['urlfoto'],
          lista[i]['latitud'],
          lista[i]['longitud'],
          lista[i]['ruta_id']));
    }
    return lugares;
  }

  // FOTOS
  Future<int> insertarFoto(Foto foto) async {
    var base = await _openDb();
    int respuesta = await base.insert("foto", foto.toMap());
    return respuesta;
  }

  Future<List<Foto>> obtenerFotos(String condicion) async {
    var base = await _openDb();
    List<Map> lista =
        await base.rawQuery("SELECT * FROM foto WHERE " + condicion);
    List<Foto> fotos = [];
    for (int i = 0; i < lista.length; i++) {
      fotos.add(Foto(lista[i]['id'], lista[i]['nombre'], lista[i]['urlfoto'],
          lista[i]['tipo'], lista[i]['lugar_id']));
    }
    return fotos;
  }

  // delete
  Future<int> borrarTabla(String tabla) async {
    var base = await _openDb();
    return await base.rawDelete("DELETE FROM " + tabla);
  }
}
