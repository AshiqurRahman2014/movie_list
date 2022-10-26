import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/movie_rating.dart';
import '../provider/userprovider.dart';
import 'comment_item.dart';

class AllCommentsWidget extends StatelessWidget {
  final int movieId;
  const AllCommentsWidget({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    return Center(
      child: FutureBuilder<List<MovieRating>>(
        future: provider.getCommentsByMovieId(movieId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final commentMapList = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: commentMapList.length,
              itemBuilder: (context, index) {
                final rating = commentMapList[index];
                return CommentItem(movieRating: rating,);
              },
            );
          }
          if(snapshot.hasError) {
            return const Text('Failed to load comments');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
