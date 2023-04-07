import 'package:apptour/basededatos/Empresa.dart';
import 'package:apptour/api/help.dart';
import 'package:flutter/material.dart';
class pantallaEmpresa extends StatefulWidget {
  Empresa _empresa;
  pantallaEmpresa(this._empresa);
  @override
  _pantallaEmpresaState createState() => _pantallaEmpresaState( this._empresa);
}

class _pantallaEmpresaState extends State<pantallaEmpresa> {
  Empresa _empresa;
  _pantallaEmpresaState(this._empresa);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_empresa.razonsocial),),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.topCenter,
        color: Colors.yellow[50],
        child: Column(
          children:<Widget> [
            const Padding(padding: EdgeInsets.all(0.0)),
            Image.network("${url}img/empresa/"+_empresa.urlfoto, fit: BoxFit.cover),
            const Padding(padding: EdgeInsets.all(8.0)),
            Text(_empresa.descripcion, textAlign: TextAlign.justify,)
          ],
        ),
      ),
    );
  }
}
