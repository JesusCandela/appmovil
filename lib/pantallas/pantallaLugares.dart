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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.amber, Colors.green])),
        child: FutureBuilder(
          future: basededatos.obtenerLugares("ruta_id=" + ruta.id.toString()),
          builder: (BuildContext c, AsyncSnapshot s) {
            if (s.hasData) {
              return ListView.builder(
                  itemCount: s.data == null ? 0 : s.data.length,
                  itemBuilder: (_c, _i) {
                    return GestureDetector(
                      onTap: () {

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext) =>
                                pantallaLugar(s.data[_i])));

                      },
                      child: Card(
                        color: Colors.grey[200],
                        elevation: 10,
                        margin: const EdgeInsets.all(10),
                        child: Container(
                          decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/p4.jpg"), 
                          fit: BoxFit.cover) 
                          ),

                          child: SingleChildScrollView(                                                    
                            scrollDirection: Axis.horizontal,
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
                               Padding(padding: const EdgeInsets.all(10),
                               child:  Text(
                                 s.data[_i].nombre,
                                 style: const TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.w700,
                                   color: Colors.black54,
                                 ),
                               ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text("No Hay Lugares"),
              );
            }
          },
        ),
      ),
    );
  }
}
