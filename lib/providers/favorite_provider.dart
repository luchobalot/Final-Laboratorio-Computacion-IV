import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider with ChangeNotifier {
  Set<int> _favoriteMovies = {};
  bool _isLoading = true;

  Set<int> get favoriteMovies => _favoriteMovies;
  bool get isLoading => _isLoading;

  FavoriteProvider() {
    debugPrint('FavoriteProvider initialized');
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    debugPrint('Loading favorites...');
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorites');
      debugPrint('Loaded favorites from SharedPreferences: $favorites');
      
      if (favorites != null) {
        _favoriteMovies = favorites.map((id) => int.parse(id)).toSet();
        debugPrint('Parsed favorites: $_favoriteMovies');
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int movieId) async {
    debugPrint('Toggling favorite for movie: $movieId');
    debugPrint('Current favorites: $_favoriteMovies');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_favoriteMovies.contains(movieId)) {
        _favoriteMovies.remove(movieId);
        debugPrint('Removed movie $movieId from favorites');
      } else {
        _favoriteMovies.add(movieId);
        debugPrint('Added movie $movieId to favorites');
      }
      
      final listToSave = _favoriteMovies.map((id) => id.toString()).toList();
      await prefs.setStringList('favorites', listToSave);
      debugPrint('Saved favorites to SharedPreferences: $listToSave');

      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  bool isFavorite(int movieId) {
    final result = _favoriteMovies.contains(movieId);
    debugPrint('Checking if movie $movieId is favorite: $result');
    return result;
  }
}
