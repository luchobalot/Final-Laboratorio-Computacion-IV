import 'package:crypto/crypto.dart';
import 'dart:convert';

class Movie {
  final String title;
  final String description;
  final String releaseDate;
  final List<String> genres;
  final double voteAverage;
  final String posterPath;
  final int id; // Ya no es opcional

  Movie({
    required this.title,
    required this.description,
    required this.releaseDate,
    required this.genres,
    required this.voteAverage,
    required this.posterPath,
    int? id,
  }) : id = id ?? _generateId(title, posterPath); // Genera un ID si no se proporciona uno

  // Método para generar un ID único basado en el título y posterPath
  static int _generateId(String title, String posterPath) {
    final String combined = title + posterPath;
    final bytes = utf8.encode(combined);
    final hash = md5.convert(bytes);
    // Convertimos los primeros 8 caracteres del hash a un número
    return int.parse(hash.toString().substring(0, 8), radix: 16);
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      releaseDate: json['release_date'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      posterPath: json['poster_path'] ?? '',
      // El ID se generará automáticamente si no existe en el JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'release_date': releaseDate,
      'genres': genres,
      'vote_average': voteAverage,
      'poster_path': posterPath,
      'id': id,
    };
  }
}