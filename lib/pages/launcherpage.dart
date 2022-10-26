import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/userprovider.dart';
import '../utils/helper_function.dart';
import 'loginpages.dart';
import 'movie_list_pages.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = '/launcher';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    redirectUser();
    super.initState();
  }

  Future<void> redirectUser() async {
    if(await getLoginStatus()) {
      final id = await getUserId();
      await Provider.of<UserProvider>(context, listen: false).getUserById(id);
      Navigator.pushReplacementNamed(context, MovieListPage.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
