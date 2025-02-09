import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_api_laboratorio/screens/screens.dart';
import 'package:final_api_laboratorio/helpers/preferences.dart';
import 'package:final_api_laboratorio/providers/theme_provider.dart';
import 'package:final_api_laboratorio/providers/favorite_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:final_api_laboratorio/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Inicializar servicios de forma paralela
    await Future.wait([
      SharedPreferences.getInstance(),
      Preferences.initShared(),
      dotenv.load(fileName: ".env"),
    ]);

    runApp(const AppState());
  } catch (e) {
    debugPrint('Error initializing app: $e');
  }
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Balot Movies',
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: 'home',
          onGenerateRoute: (settings) {
            if (settings.name == 'movie_details') {
              final movie = settings.arguments as Movie;
              return MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
                fullscreenDialog: true,
              );
            }

            return switch (settings.name) {
              'home' => MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              'profile' => MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              'balot_list' => MaterialPageRoute(
                  builder: (context) => const BalotListScreen(),
                ),
              _ => MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
            };
          },
        );
      },
    );
  }
}