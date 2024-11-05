import 'dart:convert';
import 'dart:math';
import 'package:movie_app/model/model.dart';
import 'package:http/http.dart' as http;

const apiKey = "f95a6d45558dee5ab593965b75e80dfd";

class APIservices {
  final nowShowingApi =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=4c97e0e6b4cff39a4e17c055b2cd591f";
  final upComingApi =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=4c97e0e6b4cff39a4e17c055b2cd591f";
  final popularApi =
      "https://api.themoviedb.org/3/movie/popular?api_key=4c97e0e6b4cff39a4e17c055b2cd591f";

  // Now Showing Film
  Future<List<Movie>> getNowShowing() async {
    Uri url = Uri.parse(nowShowingApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }

  // Upcoming Film
  Future<List<Movie>> getUpComing() async {
    Uri url = Uri.parse(upComingApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      Random random = Random();
      int startIndex = random.nextInt(data.length);
      List<Movie> movies =
          data.skip(startIndex).map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }

  // Popular Film
  Future<List<Movie>> getPopular() async {
    Uri url = Uri.parse(popularApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      Random random = Random();
      int startIndex = random.nextInt(data.length);
      List<Movie> movies =
          data.skip(startIndex).map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }
}
