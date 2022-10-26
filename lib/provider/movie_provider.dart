import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../model/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  List<MovieModel> movieList = [];

  Future<int> insertMovie(MovieModel movieModel) =>
      DbHelper.insertMovie(movieModel);

  Future<int> deleteMovie(int id) =>
      DbHelper.deleteMovie(id);

  void getAllMovies() async {
    movieList = await DbHelper.getAllMovies();
    notifyListeners();
  }

  Future<MovieModel> getMovieById(int id) =>
      DbHelper.getMovieById(id);

  Future<int> updateMovie(MovieModel movieModel) =>
      DbHelper.updateMovie(movieModel);

  MovieModel getItem(int id) {
    return movieList.firstWhere((element) => element.id == id);
  }
}