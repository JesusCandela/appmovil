import 'package:apptour/pantallas/pantallaRutas.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Tour',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PaginaInicio()
    );
  }
}

class PaginaInicio extends StatefulWidget {
  @override
  _PaginaInicioState createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(      
        decoration: const BoxDecoration(
          gradient:  LinearGradient(
            colors:[Colors.green,Colors.orange],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/Chone_Logo.jpg",
                  fit: BoxFit.cover,
                  scale: 1.2,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 80, top:20),
                child: Text(
                  "Difusion de Informacion Turistica",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepOrange, fontSize: 25),
                ),
                
              ),
              
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext) => pantallaRutas())
                  );
                },
                //explore_rounded
                
                style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20.0),
                /*primary: Colors.green,
                onPrimary: Colors.white,*/         
                

                ),
                child: const Icon(Icons.explore_rounded, color: Colors.white,size: 40.0,),

                ) ,
                
                

              
            ],
          ),
        ),
      ),
    );
  }
}

