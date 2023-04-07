import 'package:apptour/basededatos/Foto.dart';
import 'package:apptour/api/help.dart';
import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class pantallaFoto extends StatefulWidget {
  Foto foto;
  pantallaFoto(this.foto);
  @override
  _pantallaFotoState createState() => _pantallaFotoState(this.foto);
}

class _pantallaFotoState extends State<pantallaFoto> {
  Foto _foto;
  _pantallaFotoState(this._foto);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_foto.nombre),
      ),
      body:  Container(
        child: Center(
          //foto plana
          child: _foto.tipo == 0
              ?  Image.network("${url}img/foto/" +
                  _foto.urlfoto,  
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,) 
                  
              : Panorama(
                //foto 360
                  child:  Image.network(
                      "${url}img/foto/" +
                          _foto.urlfoto,  
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,) ,
                ),
        ),
      ),
    );
  }
}
