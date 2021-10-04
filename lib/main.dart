import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappeclipse/screens/initial_screen.dart';
import 'package:testappeclipse/screens/list_of_users_screen.dart';

import 'helpers/provider_helper.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => ProviderHelper(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => InitialScreen(),
        '/listOfUsers': (context) => ListOfUsersScreen(),
        // '/userPage': (context) => UserPageScreen(),
        // '/userPosts': (context) => UserPostsScreen(),
        // '/userAlbums': (context) => UserAlbumsScreen(),
        // '/detailedPost': (context) => DetailedPostScreen(),
        // '/detailedAlbums': (context) => DetailedAlbumScreen(),
      },
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
