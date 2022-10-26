import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/movie_model.dart';
import '../provider/movie_provider.dart';
import '../provider/userprovider.dart';
import '../utils/helper_function.dart';
import 'launcherpage.dart';
import 'movie_detailspage.dart';
import 'new_movie_add.dart';

class MovieListPage extends StatefulWidget {
  static const String routeName = '/home';

  const MovieListPage({Key? key}) : super(key: key);

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late UserProvider userProvider;
  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    Provider.of<MovieProvider>(context, listen: false).getAllMovies();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: userProvider.userModel.isAdmin ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NewMoveAddPage.routeName);
        },
        child: const Icon(Icons.add),
      ) : null,
      appBar: AppBar(
        title: const Text('Movie List'),
        actions: [
          IconButton(
            onPressed: () {
              setLoginStatus(false).then((value) {
                Navigator.pushReplacementNamed(context, LauncherPage.routeName);
              });
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.movieList.length,
          itemBuilder: (context, index) {
            final movie = provider.movieList[index];
            return MovieItem(movie: movie);
          },
        ),
      ),
    );
  }
}

class MovieItem extends StatelessWidget {
  const MovieItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, MovieDetailsPage.routeName,
          arguments: [movie.id, movie.name]),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Image.file(
                File(movie.image),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                movie.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                movie.type,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
