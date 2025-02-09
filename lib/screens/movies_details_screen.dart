import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../themes/balot_movies_colors.dart';
import '../models/movie.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    if (imageUrl.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImageViewer(imageUrl: imageUrl),
        ),
      );
    }
  }

  Widget _buildErrorWidget(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 500,
      color: isDarkMode ? Colors.grey[900] : Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: 100,
          color: isDarkMode ? Colors.white30 : Colors.black26,
        ),
      ),
    );
  }

  Widget _buildPosterImage(String posterPath, bool isDarkMode) {
    if (posterPath.isEmpty) {
      return _buildErrorWidget(isDarkMode);
    }

    return CachedNetworkImage(
      imageUrl: posterPath,
      width: double.infinity,
      height: 500,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[300],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => _buildErrorWidget(isDarkMode),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building MovieDetailScreen for movie ID: ${movie.id}');
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final bool isFavorite = movie.id != null && favoriteProvider.isFavorite(movie.id!);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : (isDarkMode ? Colors.white : Colors.black),
            ),
            onPressed: () {
              if (movie.id != null) {
                debugPrint('Toggling favorite for movie ID: ${movie.id}');
                favoriteProvider.toggleFavorite(movie.id!);
                
                // Añadir feedback visual
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite 
                          ? 'Eliminado de favoritos'
                          : 'Añadido a favoritos',
                      style: const TextStyle(fontSize: 16),
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: isFavorite 
                        ? Colors.red
                        : Colors.green,
                  ),
                );
              } else {
                debugPrint('Error: movie.id is null');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implementar funcionalidad de compartir
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode
                      ? [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.9)]
                      : [Colors.white, Colors.grey.shade200],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: 'movieImage${movie.id ?? "default"}',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: _buildPosterImage(movie.posterPath, isDarkMode),
                        ),
                      ),
                      if (movie.posterPath.isNotEmpty)
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: () => _showFullScreenImage(context, movie.posterPath),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.zoom_in,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                movie.title,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: BalotMoviesColors.yellow,
                                  size: 28,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${movie.voteAverage.toStringAsFixed(1)} / 10',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isDarkMode ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          movie.genres.isEmpty ? "Sin géneros" : movie.genres.join(", "),
                          style: TextStyle(
                            color: BalotMoviesColors.redPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          movie.description.isEmpty ? "Sin descripción disponible" : movie.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}