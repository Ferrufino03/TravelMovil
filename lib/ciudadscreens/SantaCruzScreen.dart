import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Components/attraction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SantaCruzScreen extends StatefulWidget {
  @override
  _SantaCruzScreenState createState() => _SantaCruzScreenState();
}

class _SantaCruzScreenState extends State<SantaCruzScreen> {
  final LatLng _initialCameraPosition = const LatLng(-17.784156, -63.180678);

  List<Attraction> attractions = [
    Attraction(
      name: 'Parque Nacional Amboró',
      image:
          'https://i.pinimg.com/736x/a6/20/74/a620747042d1b3e0f025a04d1a947bbe.jpg',
      latitude: -17.784156, // Ejemplo de coordenadas
      longitude: -63.180678, // Ejemplo de coordenadas
    ),
    // Más atracciones...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Santa Cruz',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 25, 4, 157),
      ),
      body: Column(
        children: [
          _buildMap(context),
          _buildSectionTitle(context, "Atracciones cercanas"),
          _buildAttractionList(),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.25, // 25% de la altura de la pantalla
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialCameraPosition,
          zoom: 14.4746,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          const Icon(Icons
              .arrow_forward), // Este icono podría ser un botón para ver más
        ],
      ),
    );
  }

  Widget _buildAttractionCard(Attraction attraction, BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            title: Text(attraction.name),
            trailing: IconButton(
              icon: Icon(
                attraction.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                _toggleFavorite(attraction);
              },
            ),
          ),
          Image.network(
            attraction.image,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(Attraction attraction) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);

      // Actualiza el estado local de la atracción
      setState(() {
        attraction.isFavorite = !attraction.isFavorite;
      });

      if (attraction.isFavorite) {
        // Añade a favoritos en Firestore
        await docRef.update({
          'favorites': FieldValue.arrayUnion([attraction.name])
        });
      } else {
        // Elimina de favoritos en Firestore
        await docRef.update({
          'favorites': FieldValue.arrayRemove([attraction.name])
        });
      }
    }
  }

  Widget _buildAttractionList() {
    return Expanded(
      child: ListView.builder(
        itemCount: attractions.length,
        itemBuilder: (context, index) {
          return _buildAttractionCard(attractions[index], context);
        },
      ),
    );
  }
}
