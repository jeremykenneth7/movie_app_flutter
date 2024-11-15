import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_app/model/model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isFavorite = false;
  String selectedCurrency = 'IDR';
  double convertedPrice = 45000.0; 
  final double ticketPrice = 45000.0;
  String selectedTimeZone = 'WIB';
  String currentTime = '';

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _convertCurrency();
    _fetchCurrentTime();
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMovies = prefs.getStringList('favoriteMovies') ?? [];
    setState(() {
      isFavorite = favoriteMovies.contains(widget.movie.id.toString());
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMovies = prefs.getStringList('favoriteMovies') ?? [];

    if (isFavorite) {
      favoriteMovies.remove(widget.movie.id.toString());
    } else {
      favoriteMovies.add(widget.movie.id.toString());
    }

    await prefs.setStringList('favoriteMovies', favoriteMovies);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _convertCurrency() async {
    if (selectedCurrency == 'IDR') {
      setState(() {
        convertedPrice = ticketPrice;
      });
      return;
    }

    final response = await http
        .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/IDR'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rate = data['rates'][selectedCurrency];
      setState(() {
        convertedPrice = ticketPrice * rate;
      });
    } else {
      setState(() {
        convertedPrice = 0.0;
      });
    }
  }

  Future<void> _fetchCurrentTime() async {
    final response = await http
        .get(Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Jakarta'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final DateTime now = DateTime.parse(data['datetime']);
      _updateTime(now);
    } else {
      setState(() {
        currentTime = 'Error fetching time';
      });
    }
  }

  void _updateTime(DateTime now) {
    DateTime convertedTime;

    switch (selectedTimeZone) {
      case 'WITA':
        convertedTime = now.add(const Duration(hours: 1));
        break;
      case 'WIT':
        convertedTime = now.add(const Duration(hours: 2));
        break;
      case 'WIB':
      default:
        convertedTime = now;
        break;
    }

    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    setState(() {
      currentTime = formatter.format(convertedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.movie.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    "https://image.tmdb.org/t/p/original/${widget.movie.backDropPath}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Sinopsis Film",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.movie.overview,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 20, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    "Tanggal Rilis Film : ${DateFormat('d MMMM yyyy').format(DateTime.parse(widget.movie.releaseDate))}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.people_outline_sharp,
                      size: 20, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    "Popularitas Film : ${widget.movie.popularity}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star, size: 20, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    "Rating Film : ${widget.movie.voteAverage}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.price_change,
                      size: 20, color: Colors.black54),
                  const SizedBox(width: 5),
                  const Text(
                    "Harga Tiket Film : Rp. 45.000",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.attach_money,
                      size: 20, color: Colors.black54),
                  const SizedBox(width: 5),
                  DropdownButton<String>(
                    value: selectedCurrency,
                    items: const [
                      DropdownMenuItem(value: 'IDR', child: Text('IDR')),
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                      DropdownMenuItem(value: 'JPY', child: Text('JPY')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedCurrency = value!;
                        _convertCurrency();
                      });
                    },
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Konversi Mata Uang : $convertedPrice $selectedCurrency",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 20, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    "Waktu sekarang : $currentTime",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 20, color: Colors.black54),
                  const SizedBox(width: 5),
                  DropdownButton<String>(
                    value: selectedTimeZone,
                    items: const [
                      DropdownMenuItem(
                          value: 'WIB', child: Text('WIB (GMT+7)')),
                      DropdownMenuItem(
                          value: 'WITA', child: Text('WITA (GMT+8)')),
                      DropdownMenuItem(
                          value: 'WIT', child: Text('WIT (GMT+9)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedTimeZone = value!;
                        _fetchCurrentTime();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
