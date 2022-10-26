import 'package:flutter/material.dart';
import 'package:movie_list/pages/launcherpage.dart';
import 'package:movie_list/pages/loginpages.dart';
import 'package:movie_list/pages/movie_detailspage.dart';
import 'package:movie_list/pages/movie_list_pages.dart';
import 'package:movie_list/pages/new_movie_add.dart';
import 'package:movie_list/provider/movie_provider.dart';
import 'package:movie_list/provider/userprovider.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute: LauncherPage.routeName,

      routes: {
        MovieListPage.routeName:(context) => const MovieListPage(),
        NewMoveAddPage.routeName:(context) => const NewMoveAddPage(),
        MovieDetailsPage.routeName:(context) => const MovieDetailsPage(),
        LoginPage.routeName:(context) =>const LoginPage(),
        LauncherPage.routeName:(context) =>const LauncherPage(),
      },
    );
  }
}


