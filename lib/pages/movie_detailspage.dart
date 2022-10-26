import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../customwidegt/all_comment_widegt.dart';
import '../model/movie_model.dart';
import '../model/movie_rating.dart';
import '../provider/movie_provider.dart';
import '../provider/userprovider.dart';
import '../utils/constants.dart';
import '../utils/helper_function.dart';
import 'new_movie_add.dart';

class MovieDetailsPage extends StatefulWidget {
  static const String routeName = '/details';

  const MovieDetailsPage({Key? key}) : super(key: key);

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late int id;
  late String name;
  late MovieProvider provider;
  late UserProvider userProvider;
  final txtController = TextEditingController();
  final focusNode = FocusNode();
  double rating = 1;

  @override
  void didChangeDependencies() {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    provider = Provider.of<MovieProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    id = argList[0];
    name = argList[1];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: userProvider.userModel.isAdmin
            ? [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, NewMoveAddPage.routeName,
                  arguments: id)
                  .then((value) {
                setState(() {
                  name = value as String;
                });
              });
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _deleteMovie(context, id, provider);
            },
            icon: const Icon(Icons.delete),
          )
        ]
            : null,
      ),
      body: Center(
        child: FutureBuilder<MovieModel>(
          future: provider.getMovieById(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final movie = snapshot.data!;
              return ListView(
                children: [
                  Image.file(
                    File(movie.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    title: Text(movie.name),
                    subtitle: Text(movie.type),
                    trailing: FutureBuilder<double>(
                      future: userProvider.getMovieRating(id),
                      builder: (context, snapshot) {
                        if(snapshot.hasError) {
                          return const Text('Unable to load');
                        }
                        if(snapshot.hasData) {
                          final rat = snapshot.data!;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(rat.toStringAsFixed(1)),
                            ],
                          );
                        }
                        return const Text('Loading');
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Budget'),
                    trailing: Text('\$${movie.budget}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(movie.description),
                  ),
                  if (!userProvider.userModel.isAdmin)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Rate this Movie',
                              style: TextStyle(fontSize: 24),
                            ),
                            RatingBar.builder(
                              initialRating: rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rat) {
                                rating = rat;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Give a Comment',
                              style: TextStyle(fontSize: 24),
                            ),
                            TextField(
                              focusNode: focusNode,
                              maxLines: 3,
                              controller: txtController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                            ),
                            TextButton(
                              onPressed: () {
                                focusNode.unfocus();
                                _saveRating();
                              },
                              child: const Text('SUBMIT'),
                            )
                          ],
                        ),
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'All Comments',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  AllCommentsWidget(
                    movieId: id,
                  )
                ],
              );
            }

            if (snapshot.hasError) {
              return const Text('Failed to load data');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _deleteMovie(BuildContext context, int id, MovieProvider provider) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete this Movie?'),
          content: const Text('Are you sure to delete this movie?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                provider.deleteMovie(id).then((value) {
                  Navigator.pop(context);
                  provider.getAllMovies();
                });
              },
              child: const Text('Yes'),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  void _saveRating() async {
    if (txtController.text.isEmpty) {
      showMsg(context, 'Please give a comment');
      return;
    }
    final movieRating = MovieRating(
      movie_id: id,
      user_id: userProvider.userModel.userId!,
      rating_date: getFormattedDate(DateTime.now(), dateTimePattern),
      user_reviews: txtController.text,
      rating: rating,
    );
    final didUserRate = await userProvider.didUserRate(id);
    if(didUserRate) {
      //update previous rating and comment
      userProvider.updateRating(movieRating)
          .then((value) {
        setState(() {
          txtController.clear();
          rating = 1;
        });
        showMsg(context, 'Your rating has been updated');
      })
          .catchError((error) {
        print(error.toString());
      });
    } else {
      userProvider.insertRating(movieRating)
          .then((value) {
        setState(() {
          txtController.clear();
          rating = 1;
        });
        showMsg(context, 'Your rating has been submitted');
      })
          .catchError((error) {
        print(error.toString());
      });
    }
  }
}
