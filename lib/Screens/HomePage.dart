import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfilePage.dart';
import '../ciudadscreens/CochabambaScreen.dart';
import '../ciudadscreens/SantaCruzScreen.dart';
import '../ciudadscreens/LaPazScreen.dart';
import 'FavoritesScreen.dart';
import 'RoutesScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String userName = "Cargando...";
  String userEmail = "";
  int _selectedIndex = 0;

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
        .doc(user?.uid)
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          userName = document.data()?['Nombre'] ?? "Nombre no disponible";
          userEmail = document.data()?['Correo'] ?? userEmail;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 25, 4, 157),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeMessage(),
            _buildSearchBar(),
            _buildImageCarousel(context),
            _buildDestinationHighlight(),
            _buildRecommendedPlaces(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
        BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Rutas'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: const Color.fromARGB(
          255, 25, 4, 157), // Color cuando el ítem está seleccionado
      unselectedItemColor:
          Colors.grey, // Color cuando el ítem no está seleccionado
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Navegación a Explorar
        break;
      case 1: // Asumiendo que el índice 1 es para 'Rutas'
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RoutesScreen()),
        );
        break;
      case 2:
        // Navegación a Favoritos
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritesScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  Widget _buildWelcomeMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Text(
        'Bienvenidos a Travel!!',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    return Container(
      height: 163.0,
      child: PageView(
        pageSnapping: true,
        controller: PageController(
          initialPage: 0,
          viewportFraction: 0.85,
        ),
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SantaCruzScreen()),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.network(
                      'https://blog.uber-cdn.com/cdn-cgi/image/width=2160,height=1080,quality=80,onerror=redirect,format=auto/wp-content/uploads/2018/07/BO_Descubre-algunos-de-los-lugares-ma%CC%81s-bonitos-para-visitar-en-Santa-Cruz-.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Santa Cruz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CochabambaScreen()),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.network(
                      'https://estaticos-noticias.unitel.bo/binrepository/1024x638/0c63/1024d512/none/125450566/PILM/cbba-frio_101-6273733_20230627224150.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Cochabamba',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LaPazScreen()),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.network(
                      'https://billiken.lat/wp-content/uploads/2022/01/WEB3-LA-PAZ-BOLIVIA-Shutterstock_1791153806-R.M.-Nunes.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'La Paz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Agrega más imágenes si es necesario
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        decoration: const InputDecoration(
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
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          // Widgets para cada destino destacado
        ],
      ),
    );
  }

  Widget _buildRecommendedPlaces() {
    // Widget para mostrar lugares recomendados
    return const Column(
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
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 25, 4, 157),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Explorar'),
            onTap: () {
              // Navegación a Explorar
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.route),
            title: Text('Rutas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoutesScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Favoritos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),

          // ... Agrega más elementos según sea necesario ...
        ],
      ),
    );
  }
}
