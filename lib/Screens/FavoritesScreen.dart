import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Attraction {
  String name;
  String image;
  bool isFavorite;

  Attraction(
      {required this.name, required this.image, this.isFavorite = false});
}

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Attraction> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          favorites = List<String>.from(doc.data()?['favorites'] ?? [])
              .map((name) => Attraction(
                  name: name,
                  image: 'https://via.placeholder.com/150',
                  isFavorite: true))
              .toList();
        });
      }
    }
  }

  void _updateFavoriteStatus(Attraction attraction, int index) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);
      if (attraction.isFavorite) {
        await docRef.update({
          'favorites': FieldValue.arrayRemove([attraction.name])
        });
      }
      setState(() {
        favorites.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        backgroundColor: const Color.fromARGB(255, 25, 4, 157),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          Attraction favorite = favorites[index];
          return ListTile(
            title: Text(favorite.name),
            leading: Image.network(favorite.image),
            trailing: IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () => _updateFavoriteStatus(favorite, index),
            ),
          );
        },
      ),
    );
  }
}
