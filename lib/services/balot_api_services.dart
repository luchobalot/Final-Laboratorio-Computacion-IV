import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class BalotApiService {
  // Corregimos la baseUrl para no incluir /movies al final
  final String baseUrl = "https://api-movies-nodejs-final-laboratorio-iv.onrender.com/api/v1";

  BalotApiService._privateConstructor();
  static final BalotApiService instance = BalotApiService._privateConstructor();

  // Método para obtener la lista de películas
  Future<List<Movie>> getMovies({int page = 1, String lang = "es-ES"}) async {
    try {
      // Ahora agregamos /movies en la construcción de la URL
      final Uri url = Uri.parse("$baseUrl/movies?page=$page&lang=$lang");
      print("Llamando a la API: $url");

      final response = await http.get(url);
      
      print("Código de respuesta: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return (data["data"] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
      } else {
        throw Exception("Error al obtener películas: ${response.statusCode}");
      }
    } catch (e) {
      print("Error de conexión: $e");
      throw Exception("Error de conexión con getMovies");
    }
  }

  // Método para obtener detalles de una película por ID
  Future<Movie> getMovieById(int id) async {
    try {
      final Uri url = Uri.parse("$baseUrl/movies/$id");
      
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data["status"] == "ok") {
          return Movie.fromJson(data["data"]);
        } else {
          throw Exception("Error al obtener la película: ${data['msg']}");
        }
      } else {
        throw Exception("Error HTTP ${response.statusCode}: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error de conexión en getMovieById: $e");
    }
  }
}