import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // Para selección de imágenes

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String userName = "Cargando...";
  String userEmail = "";
  String userPhoneNumber = "No disponible";
  String userAddress = "No disponible";
  String profileImageUrl = ""; // URL de la imagen de perfil
  // Más variables según sea necesario

  @override
  void initState() {
    super.initState();
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
          userEmail = document.data()?['Correo'] ?? "Correo no disponible";
          userPhoneNumber =
              document.data()?['Teléfono'] ?? "Teléfono no disponible";
          userAddress =
              document.data()?['Dirección'] ?? "Dirección no disponible";
          profileImageUrl = document.data()?['ImagenPerfil'] ?? "";
        });
      }
    });
  }

  Future<void> _updateProfileData() async {
    // Método para actualizar los datos del perfil
  }

  Future<void> _selectAndUploadProfilePicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Subir imagen a Firebase y actualizar URL en Firestore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildProfileDetails(),
            _buildEditProfileButton(),
            // Otros widgets según sea necesario
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(userName),
      accountEmail: Text(userEmail),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(profileImageUrl.isNotEmpty
            ? profileImageUrl
            : "https://via.placeholder.com/150"), // Imagen de perfil
        child: Text(
          userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : "A",
          style: TextStyle(fontSize: 40.0),
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    // Widget para mostrar más detalles del perfil
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Teléfono: $userPhoneNumber"),
          Text("Dirección: $userAddress"),
          // Más campos según sea necesario
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return ElevatedButton(
      onPressed: () {
        // Lógica para editar el perfil
      },
      child: Text("Editar Perfil"),
    );
  }

  // Otros métodos según sea necesario
}
