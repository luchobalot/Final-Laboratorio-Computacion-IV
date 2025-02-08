class Movie {
  final String title;
  final String description;
  final String releaseDate;
  final List<String> genres;
  final double voteAverage;
  final String posterPath;
  final int? id; // Hacemos el id opcional ya que no viene en la respuesta

  Movie({
    required this.title,
    required this.description,
    required this.releaseDate,
    required this.genres,
    required this.voteAverage,
    required this.posterPath,
    this.id,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      releaseDate: json['release_date'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      posterPath: json['poster_path'] ?? '',
      id: json['id'], // Puede ser null
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