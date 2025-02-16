import 'package:flutter/material.dart';
import '../screens/favorites_screen.dart';  // Asegúrate de importar la pantalla de favoritos

class DrawerMenu extends StatelessWidget {
  final List<Map<String, String>> _menuItems = <Map<String, String>>[
    {'route': 'home', 'title': 'Home', 'subtitle': 'Home + counter app'},
    {'route': 'profile', 'title': 'Mi Perfil', 'subtitle': ''},
    {'route': 'balot_list', 'title': 'Peliculas', 'subtitle': 'Peliculas más relevantes 2025'},
    {'route': 'favorites_screen', 'title': 'Peliculas Favoritas', 'subtitle': 'Tus películas favoritas'},
  ];

  DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeaderAlternative(),
          ...ListTile.divideTiles(
              context: context,
              tiles: _menuItems
                  .map((item) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      dense: true,
                      minLeadingWidth: 25,
                      iconColor: Colors.blueGrey,
                      title: Text(item['title']!,
                          style: const TextStyle(fontFamily: 'FuzzyBubbles')),
                      subtitle: Text(
                          item['subtitle']!.isEmpty
                              ? 'Tap to go to ${item['title']}'
                              : item['subtitle']!,
                          style: const TextStyle(
                              fontFamily: 'RobotoMono', fontSize: 11)),
                      leading: const Icon(Icons.arrow_right),
                      onTap: () {
                        Navigator.pop(context);

                        // Navegar según la ruta
                        switch (item['route']) {
                          case 'home':
                            Navigator.pushNamed(context, 'home');
                            break;
                          case 'profile':
                            Navigator.pushNamed(context, 'profile');
                            break;
                          case 'balot_list':
                            Navigator.pushNamed(context, 'balot_list');
                            break;
                          case 'favorites_screen':  // Navegar directamente a FavoritesScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                            );
                            break;
                          default:
                            Navigator.pushNamed(context, 'home');
                        }
                      },
                    );
                  })
                  .toList())
        ],
      ),
    );
  }
}

class _DrawerHeaderAlternative extends StatelessWidget {
  const _DrawerHeaderAlternative({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Stack(children: [
        Positioned(
          top: -90,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)),
            transform: Matrix4.rotationZ(0.2),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 140,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)),
            transform: Matrix4.rotationZ(0.9),
          ),
        ),
        Positioned(
          top: 30,
          right: 35,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)),
            transform: Matrix4.rotationZ(0.9),
          ),
        ),
        Positioned(
          top: 70,
          right: -10,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.4),
                borderRadius: BorderRadius.circular(5)),
            transform: Matrix4.rotationZ(0.9),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text(
            '[  Menu  ]',
            style: TextStyle(
                fontSize: 13, color: Colors.black54, fontFamily: 'RobotoMono'),
            textAlign: TextAlign.right,
          ),
        ),
      ]),
    );
  }
}
