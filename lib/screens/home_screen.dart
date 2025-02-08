import 'package:flutter/material.dart';
import 'dart:async';
import 'package:final_api_laboratorio/screens/profile_screen.dart';
import 'package:final_api_laboratorio/screens/balot_list_screen.dart';
import 'package:final_api_laboratorio/widgets/drawner_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _movieImages = [
    'assets/images/movie1.jpg',
    'assets/images/movie2.jpg',
    'assets/images/movie3.jpg',
    'assets/images/movie4.jpeg',
    'assets/images/movie5.jpg',
    'assets/images/movie6.jpg',
  ];

  late Timer _timer;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Establecer el Timer para cambiar las imágenes cada 5 segundos
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        // Cambiar de página cada 5 segundos
        _currentIndex = (_currentIndex + 1) % _movieImages.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 800), // Animación más suave
          curve: Curves.easeInOut, // Suaviza la animación
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Detener el timer cuando la pantalla se destruye
    _pageController.dispose(); // Liberar el controlador de la página
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        centerTitle: true,
        toolbarHeight: 80,
        backgroundColor: Colors.teal,
      ),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mi perfil
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/avatar.jpg'), // Imagen del avatar UTN
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bienvenidos a mi proyectode Flutter!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Final de Laboratorio Computación IV - UTN',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Modificar mi perfil',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sección de navegación para Películas
              const Text(
                'Explorar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Sección de Películas más relevantes con imágenes cambiando cada 5 segundos
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200, // Ajusta el tamaño del contenedor
                      width: double.infinity,
                      child: PageView.builder(
                        itemCount: _movieImages.length,
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(_movieImages[index]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.movie, color: Colors.teal),
                      title: const Text('Películas más relevantes'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BalotListScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
