import 'package:actividad2wearables/data/sp_helper.dart';
import 'package:actividad2wearables/model/profile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SpHelper helper = SpHelper();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtImage = TextEditingController();
  final TextEditingController txtGender = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    Profile profile = await helper.getProfile();
    txtName.text = profile.name;
    txtImage.text = profile.urlImage;
    txtGender.text = profile.gender;
    txtName.text = profile.name == '' ? 'Guest' : profile.name;
    txtImage.text = profile.urlImage == ''
        ? 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
        : profile.urlImage;
    txtGender.text = profile.gender == '' ? 'Hombre' : profile.gender;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Perfil",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Bienvenido ${txtName.text}',
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
          ),
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage(
              txtImage.text.isNotEmpty
                  ? txtImage.text
                  : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',
            ),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Nombre de perfil',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          TextField(
            controller: txtName,
            decoration: InputDecoration(
              hintText: 'Introduce tu nombre de perfil',
              border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 143, 110, 201), width: 10),
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'URL de la imagen de perfil',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          TextField(
            controller: txtImage,
            decoration: InputDecoration(
              hintText: 'Introduce la URL de la foto de tu perfil',
              border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 143, 110, 201), width: 10),
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Género',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: DropdownMenu(
                  initialSelection: txtGender.text,
                  controller: txtGender,
                  dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                    DropdownMenuEntry(value: 'Hombre', label: 'Hombre'),
                    DropdownMenuEntry(value: 'Mujer', label: 'Mujer'),
                  ])),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveProfile().then((value) {
            String message = value
                ? 'Perfil guardado correctamente'
                : 'Error al guardar el perfil';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.deepPurple,
                duration: const Duration(seconds: 2),
              ),
            );
            setState(() {});
          });
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<bool> saveProfile() async {
    return await helper.setProfile(txtName.text, txtImage.text, txtGender.text);
  }

  @override
  void dispose() {
    txtName.dispose();
    txtImage.dispose();
    super.dispose();
  }
}
