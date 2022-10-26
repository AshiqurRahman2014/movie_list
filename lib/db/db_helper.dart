
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

import '../model/movie_favorit.dart';
import '../model/movie_model.dart';
import '../model/movie_rating.dart';
import '../model/user_model.dart';


class DbHelper {
  static const String createTableMovie = '''create table $tableMovie(
  $tblMovieColId integer primary key autoincrement,
  $tblMovieColName text,
  $tblMovieColDes text,
  $tblMovieColType text,
  $tblMovieColImage text,
  $tblMovieColRelease text,
  $tblMovieColBudget integer)''';

  static const String createTableUser = '''create table $tableUser(
  $tblUserColId integer primary key autoincrement,
  $tblUserColEmail text,
  $tblUserColPassword text,
  $tblUserColAdmin integer)''';

  static const String createTableRating = '''create table $tableRating(
  $tblRatingColMovieId integer,
  $tblRatingColUserId integer,
  $tblRatingColDate text,
  $tblRatingColUserReviews text,
  $tblColRating real)''';

  static const String createTableFavorite = '''create table $tableFavorite(
  $tblFavColMovieId integer,
  $tblFavColUserId integer,
  $tblFavColFavorite integer)''';


  static Future<Database> open() async {

    final rootPath = await getDatabasesPath();
    final dbPath = Path.join(rootPath, 'movie_db');

    return openDatabase(dbPath, version: 2, onCreate: (db, version) async {
      await db.execute(createTableMovie);
      await db.execute(createTableUser);
      await db.execute(createTableRating);
      await db.execute(createTableFavorite);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if(newVersion == 2) {
        db.execute('alter table $tableUser add column $tblUserColAdmin integer');
      }
    });
  }

  static Future<int> insertMovie(MovieModel movieModel) async {
    final db = await open();
    return db.insert(tableMovie, movieModel.toMap());
  }

  static Future<int> insertUser(UserModel userModel) async {
    final db = await open();
    return db.insert(tableUser, userModel.toMap());
  }

  static Future<int> insertRating(MovieRating movieRating) async {
    final db = await open();
    return db.insert(tableRating, movieRating.toMap());
  }

  static Future<List<MovieModel>> getAllMovies() async {
    final db = await open();
    final mapList = await db.query(tableMovie);
    return List.generate(mapList.length, (index) =>
        MovieModel.fromMap(mapList[index]));
  }

  static Future<MovieModel> getMovieById(int id) async {
    final db = await open();
    final mapList = await db.query(tableMovie, where: '$tblMovieColId = ?', whereArgs: [id]);
    return MovieModel.fromMap(mapList.first);
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    final db = await open();
    final mapList = await db.query(tableUser, where: '$tblUserColEmail = ?', whereArgs: [email]);
    if(mapList.isEmpty) return null;
    return UserModel.fromMap(mapList.first);
  }

  static Future<UserModel> getUserById(int id) async {
    final db = await open();
    final mapList = await db.query(tableUser,
      where: '$tblUserColId = ?', whereArgs: [id],);
    return UserModel.fromMap(mapList.first);
  }

  static Future<List<MovieRating>> getRatingsByMovieId(int id) async {
    final db = await open();
    final mapList = await db.query(tableRating,
      where: '$tblRatingColMovieId = ?', whereArgs: [id],);
    return List.generate(mapList.length, (index) =>
        MovieRating.fromMap(mapList[index]));
  }

  static Future<List<MovieRating>> getCommentsByMovieId(int id) async {
    final db = await open();
    final mapList = await db.rawQuery('select a.movie_id, a.user_id, a.rating, a.rating_date, a.user_reviews, b.email from $tableRating a inner join $tableUser b where a.user_id = b.user_id and a.movie_id = $id');
    return List.generate(mapList.length, (index) =>
        MovieRating.fromMap(mapList[index]));
  }

  static Future<bool> didUserRate(int movieId, int userId) async {
    final db = await open();
    final mapList = await db.query(tableRating,
      where: '$tblRatingColMovieId = ? and $tblRatingColUserId = ?', whereArgs: [movieId, userId],);
    return mapList.isNotEmpty;
  }

  static Future<int> deleteMovie(int id) async {
    final db = await open();
    return db.delete(tableMovie, where: '$tblMovieColId = ?', whereArgs: [id]);
  }

  static Future<int> updateMovie(MovieModel movieModel) async {
    final db = await open();
    return db.update(tableMovie, movieModel.toMap(),
        where: '$tblMovieColId = ?', whereArgs: [movieModel.id]);
  }

  static Future<int> updateRating(MovieRating movieRating) async {
    final db = await open();
    return db.update(tableRating, movieRating.toMap(),
      where: '$tblRatingColMovieId = ? and $tblRatingColUserId = ?', whereArgs: [movieRating.movie_id, movieRating.user_id],);
  }
}