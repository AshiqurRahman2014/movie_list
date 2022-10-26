import 'package:flutter/material.dart';

import '../model/movie_rating.dart';



class CommentItem extends StatelessWidget {
  final MovieRating movieRating;
  const CommentItem({Key? key, required this.movieRating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(movieRating.email ?? 'Unknown'),
          subtitle: Text(movieRating.rating_date),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber,),
              Text(movieRating.rating.toString())
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(movieRating.user_reviews),
        ),
      ],
    );
  }
}
