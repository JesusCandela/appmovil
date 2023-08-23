import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/basededatos/Ruta.dart';
import 'package:apptour/pantallas/pantallaLugar.dart';
import 'package:apptour/api/help.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

var basededatos = new DBmanager();

class pantallaLugares extends StatefulWidget {
  Ruta ruta;
  pantallaLugares(this.ruta);
  @override
  _pantallaLugaresState createState() => _pantallaLugaresState(this.ruta);
}

class _pantallaLugaresState extends State<pantallaLugares> {
  Ruta ruta;
  int _hoveredIndex = -1;
  _pantallaLugaresState(this.ruta);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lugares En " + ruta.nombre),
      ),
      body: Container(
        color: Colors.amber,
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
                        onTapDown: (_) {
                          setState(() {
                            _hoveredIndex = _i;
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            _hoveredIndex = -1;
                          });
                        },
                        child: Transform.scale(
                          scale: _hoveredIndex == _i ? 1.05 : 1.0,
                          child: Card(
                            elevation: _hoveredIndex == _i ? 80 : 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.all(5),
                            color: _hoveredIndex == _i
                                ? Colors
                                    .greenAccent // Color cuando está en "hover"
                                : Colors.white70, // Color normal

                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.network(
                                    "${url}img/lugar/" + s.data[_i].urlfoto,
                                    width: 160,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    height: 100,
                                    width: 180,
                                    child: Marquee(
                                      text: s.data[_i]
                                          .nombre, // El texto que quieres mostrar
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green,
                                      ),
                                      blankSpace:
                                          300, // Espacio en blanco al final del texto antes de reiniciar
                                      velocity:
                                          50, // Velocidad de desplazamiento en pixels por segundo
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
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
