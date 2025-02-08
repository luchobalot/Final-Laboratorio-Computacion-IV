import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_api_laboratorio/screens/screens.dart';
import 'package:final_api_laboratorio/helpers/preferences.dart';
import 'package:final_api_laboratorio/providers/theme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa dotenv

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initShared();
  await dotenv.load(fileName: ".env"); // Carga .env de forma asíncrona

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'home',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routes: {
            'home': (context) => const HomeScreen(),
            'profile': (context) => const ProfileScreen(),
            'balot_list': (context) => const BalotListScreen(),
            'movie_details': (context) => MovieDetailsScreen(),
          },
        );
      },
    );
  }
}
