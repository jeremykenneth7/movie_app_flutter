class Movie {
  final int id;
  final String title;
  final String backDropPath;
  final String overview;
  final String releaseDate;
  final double popularity;
  final String voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.releaseDate,
    required this.popularity,
    required this.voteAverage,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      backDropPath: map['backdrop_path'],
      overview: map['overview'],
      releaseDate: map['release_date'],
      popularity: (map['popularity'] as num).toDouble(),
      voteAverage: map['vote_average'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'backDropPath': backDropPath,
      'overview': overview,
      'releaseDate': releaseDate,
      'popularity': popularity,
      'voteAverage': voteAverage,
    };
  }
}
