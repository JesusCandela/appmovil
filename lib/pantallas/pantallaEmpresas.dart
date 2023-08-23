import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/basededatos/Ruta.dart';
import 'package:apptour/pantallas/pantallaEmpresa.dart';
import 'package:apptour/api/help.dart';
import 'package:flutter/material.dart';

var basededatos = new DBmanager();

class pantallaEmpresas extends StatefulWidget {
  Ruta ruta;
  pantallaEmpresas(this.ruta);
  @override
  _pantallaEmpresasState createState() => _pantallaEmpresasState(this.ruta);
}

class _pantallaEmpresasState extends State<pantallaEmpresas> {
  Ruta ruta;
  int _hoveredIndex = -1;

  _pantallaEmpresasState(this.ruta);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Empresas En " + ruta.nombre),
      ),
      backgroundColor: Colors.amber,
      body: FutureBuilder(
        future: basededatos.obtenerEmpresas("ruta_id=" + ruta.id.toString()),
        builder: (BuildContext c, AsyncSnapshot s) {
          if (s.hasData) {
            return ListView.builder(
                itemCount: s.data == null ? 0 : s.data.length,
                itemBuilder: (_c, _i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext) =>
                              pantallaEmpresa(s.data[_i])));
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
                            ? Colors.greenAccent // Color cuando está en "hover"
                            : Colors.white70, // Color normal

                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                "${url}img/empresa/" + s.data[_i].urllogo,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  s.data[_i].razonsocial,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else if (s.hasError) {
            return const Center(
              child: Text("NO EXISTEN EMPRESAS"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }
}
