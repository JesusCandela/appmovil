import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/basededatos/Ruta.dart';
import 'package:apptour/pantallas/pantallaLugar.dart';
import 'package:apptour/api/help.dart';
import 'package:flutter/material.dart';

var basededatos = new DBmanager();

class pantallaLugares extends StatefulWidget {
  Ruta ruta;
  pantallaLugares(this.ruta);
  @override
  _pantallaLugaresState createState() => _pantallaLugaresState(this.ruta);
}

class _pantallaLugaresState extends State<pantallaLugares> {
  Ruta ruta;
  _pantallaLugaresState(this.ruta);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Lugares En "+ruta.nombre),
      ),
      backgroundColor: Colors.amber,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.blue
        ),
        child: FutureBuilder(
          future: basededatos.obtenerLugares("ruta_id=" + ruta.id.toString()),
          builder: (BuildContext c, AsyncSnapshot s) {
            if (s.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                  itemCount: s.data == null ? 0 : s.data.length,
                  itemBuilder: (_c, _i) {
                    return GestureDetector(
                      onTap: () {

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext) =>
                                pantallaLugar(s.data[_i])));

                      },
                      child: Card(
                        color: Colors.blue[150],
                        elevation: 10,
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              "${url}img/lugar/" +
                                  s.data[_i].urlfoto,
                              width: 220,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                           Padding(padding: EdgeInsets.all(10),child:  Text(                           
                           
                             s.data[_i].nombre,
                             textAlign: TextAlign.center,
                             style: const TextStyle(
                               fontSize: 20,
                               fontWeight: FontWeight.w700,
                               color: Colors.green,
                             ),
                           ),)
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const  Center(
                child: Text("NO EXISTEN EMPRESAS"),
              );
            }
          },
        ),
      ),
    );
  }
}
