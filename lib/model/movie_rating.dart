import 'package:movie_list/model/user_model.dart';

const String tblRatingColMovieId='movie_id';
const String tblRatingColUserId='user_id';
const String tblRatingColDate='rating_date';
const String tblRatingColUserReviews='user_reviews';
const String tblColRating='rating';
const String tableRating='tbl_rating';

class MovieRating{
  int movie_id;
  int user_id;
  String? email;
  String rating_date;
  String user_reviews;
  double rating;

  MovieRating(
      {
        this.email,
        required this.movie_id,
        required this.user_id,
        required this.rating_date,
        required this.user_reviews,
        required this.rating});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      tblRatingColMovieId : movie_id,
      tblRatingColUserId : user_id,
      tblRatingColDate : rating_date,
      tblRatingColUserReviews : user_reviews,
      tblColRating : rating,
    };
  }

  factory MovieRating.fromMap(Map<String, dynamic> map) =>
      MovieRating(
        movie_id : map[tblRatingColMovieId],
        user_id : map[tblRatingColUserId],
        rating_date : map[tblRatingColDate],
        user_reviews : map[tblRatingColUserReviews],
        rating : map[tblColRating],
        email : map[tblUserColEmail],
      );

}