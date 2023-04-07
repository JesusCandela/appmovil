import 'package:apptour/basededatos/DBmanager.dart';
import 'package:apptour/pantallas/pantallaLugar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:apptour/maps/click.dart';
import 'package:apptour/maps/mapa.dart';
import 'package:apptour/maps/animaciones.dart';
import 'package:apptour/maps/marcadores.dart';
import 'package:apptour/basededatos/Lugar.dart';

var basededatos = new DBmanager();

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class pantallaportadagps extends StatefulWidget {
  Lugar lugar;
  pantallaportadagps(this.lugar);

  final drawerItems = [
    new DrawerItem("Mapa UI", Icons.map),
    new DrawerItem("Click", Icons.mouse),
    new DrawerItem("Animaciones", Icons.animation),
    new DrawerItem("Marcadores", Icons.place)
  ];

  @override
  State<StatefulWidget> createState() => pantallaportadagpsState(this.lugar);

}

class pantallaportadagpsState extends State<pantallaportadagps> {
  Lugar lugar;
  pantallaportadagpsState(this.lugar);
  int _indiceDrawerItemSeleccionado = 0;

  _getDrawerFragment(int posicion) {
    switch (posicion) {
      case 0:
        return  Mapa(this.lugar);
      case 1:
        return new ClickPagina();
      case 2:
        return new AnimacionesPagina();
      case 3:
        return new MarcadorLugarPagina();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _indiceDrawerItemSeleccionado = index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> opcionesDrawer = [];

    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      opcionesDrawer.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _indiceDrawerItemSeleccionado,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar:  AppBar(
        title:
            new Text(widget.drawerItems[_indiceDrawerItemSeleccionado].title),
      ),
      drawer: new Drawer(
          child: Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: const Text("Jesus Candela"),
            accountEmail: new Text("jesuscandela2000@gmail.com"),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new AssetImage("assets/profile.png"),
            ),
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("assets/bg.jpg"), fit: BoxFit.cover)),
          ),
          new Column(children: opcionesDrawer)
        ],
      )),
      body: _getDrawerFragment(_indiceDrawerItemSeleccionado),
    );
  }
}
