import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../model/movie_rating.dart';
import '../model/user_model.dart';

class UserProvider extends ChangeNotifier {
  late UserModel _userModel;
  UserModel get userModel => _userModel;

  Future<UserModel?> getUserByEmail(String email) {
    return DbHelper.getUserByEmail(email);
  }

  Future<void> getUserById(int id) async {
    _userModel = await DbHelper.getUserById(id);
  }

  Future<int> insertNewUser(UserModel userModel) {
    return DbHelper.insertUser(userModel);
  }

  Future<int> insertRating(MovieRating movieRating) {
    return DbHelper.insertRating(movieRating);
  }

  Future<bool> didUserRate(int movieId) =>
      DbHelper.didUserRate(movieId, _userModel.userId!);

  Future<int> updateRating(MovieRating movieRating) =>
      DbHelper.updateRating(movieRating);

  Future<double> getMovieRating(int movieId) async {
    final ratingList = await DbHelper.getRatingsByMovieId(movieId);
    return _calculateRating(ratingList);
  }

  Future<List<MovieRating>> getCommentsByMovieId(int id) =>
      DbHelper.getCommentsByMovieId(id);

  double _calculateRating(List<MovieRating> ratingList) {
    double rating = 0.0;
    for(var rat in ratingList) {
      rating += rat.rating;
    }
    return rating / ratingList.length;
  }
}