class Movie {
  final String title;
  final String backDropPath;
  final String overview;
  final String releaseDate;
  final double popularity;

  Movie({
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.releaseDate,
    required this.popularity,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'],
      backDropPath: map['backdrop_path'],
      overview: map['overview'],
      releaseDate: map['release_date'],
      popularity: (map['popularity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'backDropPath': backDropPath,
      'overview': overview,
      'releaseDate': releaseDate,
      'popularity': popularity,
    };
  }
}
