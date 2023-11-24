import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Components/attraction.dart';

class RoutesScreen extends StatefulWidget {
  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final LatLng _center =
      const LatLng(-17.7833, -63.1820); // Centro de Santa Cruz
  late GoogleMapController mapController;

  List<TourRoute> tourRoutes = [
    // Tus rutas turísticas aquí
  ];

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapPins();
    _setPolylines();
  }

  void _setMapPins() {
    setState(() {
      // Ejemplo de marcadores
      _markers.add(
        Marker(
          markerId: MarkerId('museo-historia'),
          position: LatLng(-17.7833, -63.1820),
          infoWindow: InfoWindow(title: 'Museo de Historia'),
        ),
        // Agrega más marcadores aquí
      );
    });
  }

  void _setPolylines() {
    List<LatLng> polylineCoordinates = [
      // Coordenadas para la ruta
    ];
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('tour_route'),
          visible: true,
          points: polylineCoordinates,
          color: Colors.blue,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutas Turísticas en Santa Cruz'),
        backgroundColor: Color.fromARGB(255, 25, 4, 157),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 13.0,
        ),
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
