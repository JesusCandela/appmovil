import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final String destinationAddress;
  final double destinationLat;
  final double destinationLong;

  MapScreen(
      {this.destinationAddress, this.destinationLat, this.destinationLong});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.destinationAddress)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                    target:
                        LatLng(widget.destinationLat, widget.destinationLong),
                    zoom: 14.0),
                markers: {
                  Marker(
                      markerId: MarkerId(widget.destinationAddress),
                      position:
                          LatLng(widget.destinationLat, widget.destinationLong),
                      infoWindow: InfoWindow(
                          title: widget.destinationAddress,
                          snippet: widget.destinationAddress))
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _navigateToDestination,
          child: const Icon(Icons.navigation),
        ));
  }
  void _navigateToDestination() async {
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=${widget.destinationLat},${widget.destinationLong}';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 
      ('No se puede abrir el mapa, tienes google maps intalado?');
    }
  }

  
}
