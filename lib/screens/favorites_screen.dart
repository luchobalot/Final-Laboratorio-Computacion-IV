import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../services/balot_api_services.dart';
import '../models/movie.dart';
import '../screens/movies_details_screen.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Películas Favoritas")),
      body: FutureBuilder<List<Movie>>(
        future: BalotApiService.instance.getMovies(), // Cargar todas las películas
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hay películas favoritas"));
          }

          final favoriteMovies = snapshot.data!
              .where((movie) => movie.id != null && favoriteProvider.isFavorite(movie.id!))  // Asegurarse de que `movie.id` no sea null
              .toList();

          return ListView.builder(
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return ListTile(
                title: Text(movie.title),
                leading: Image.network(movie.posterPath, width: 50, height: 75, fit: BoxFit.cover),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
