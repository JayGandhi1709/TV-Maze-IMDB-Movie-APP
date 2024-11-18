import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieProvider with ChangeNotifier {
  List<dynamic> _movies = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<dynamic> get movies => _movies;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchMovies({String query = '', int page = 0}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = query.isNotEmpty
          ? await http
              .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'))
          : await http
              .get(Uri.parse('https://api.tvmaze.com/shows?page=$page'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _movies =
            query.isNotEmpty ? data.map((item) => item['show']).toList() : data;
      } else {
        _errorMessage = 'Failed to load movies';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
