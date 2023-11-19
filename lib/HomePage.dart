import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfilePage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String userName = "Cargando...";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    userEmail = user?.email ?? "email@ejemplo.com";
    if (user != null) {
      _loadUserData();
    }
  }

  void _loadUserData() async {
    FirebaseFirestore.instance
        .collection('Users')
        .where('Correo', isEqualTo: user?.email)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first.data();
        setState(() {
          userName = doc['Nombre'] ?? "Nombre no disponible";
          userEmail = doc['Correo'] ?? userEmail;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel'),
        backgroundColor: Color.fromARGB(255, 25, 4, 157),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeMessage(),
            _buildImageCarousel(),
            _buildSearchBar(),
            _buildDestinationHighlight(),
            _buildRecommendedPlaces(),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildWelcomeMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Text(
        'Bienvenidos a Travel',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImageCarousel() {
    final List<String> imageList = [
      'https://cdn.pixabay.com/photo/2021/08/19/18/39/pink-flamingos-6558751_1280.jpg',
      'https://cdn.pixabay.com/photo/2021/01/04/16/12/uyuni-5888023_640.jpg',
      'https://cdn.pixabay.com/photo/2021/01/04/16/04/uyuni-5887992_640.jpg',
      // ... otras URLs de imágenes ...
    ];

    return Container(
      height: 200.0,
      child: PageView.builder(
        itemCount: imageList.length,
        pageSnapping: true,
        controller: PageController(viewportFraction: 0.8),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
              image: DecorationImage(
                image: NetworkImage(imageList[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Buscar lugares...',
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) {
          // Lógica de búsqueda
        },
      ),
    );
  }

  Widget _buildDestinationHighlight() {
    // Widget para mostrar destinos destacados
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          // Widgets para cada destino destacado
        ],
      ),
    );
  }

  Widget _buildRecommendedPlaces() {
    // Widget para mostrar lugares recomendados
    return Column(
      children: <Widget>[
        // Lista de lugares recomendados
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userName.isNotEmpty
                    ? userName.substring(0, 1).toUpperCase()
                    : "A",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 25, 4, 157),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.map),
            title: Text('Explorar'),
            onTap: () {
              // Navegación a Explorar
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Favoritos'),
            onTap: () {
              // Navegación a Favoritos
              Navigator.pop(context);
            },
          ),
          // ... Agrega más elementos según sea necesario ...
        ],
      ),
    );
  }
}
