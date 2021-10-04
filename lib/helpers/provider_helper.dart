import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testappeclipse/model/user_model.dart';

class ProviderHelper with ChangeNotifier {
  late SharedPreferences prefs;
  int _selectedUserID = 0;

  int get selectedUserID => _selectedUserID;

  set selectedUserID(int value) {
    _selectedUserID = value;
  }

  int _selectedPostID = 0;

  int get selectedPostID => _selectedPostID;

  set selectedPostID(int value) {
    _selectedPostID = value;
  }

  int _selectedAlbumID = 0;

  int get selectedAlbumID => _selectedAlbumID;

  set selectedAlbumID(int value) {
    _selectedAlbumID = value;
  }

  List<UserModel> _listOfUsers = [];

  List<UserModel> get listOfUsers {
    if (_listOfUsers.isEmpty) updateListOfUsers();
    return _listOfUsers;
  }

  set listOfUsers(List<UserModel> users) {
    _listOfUsers = users;
    notifyListeners();
  }

  void removeSP() async {
    await prefs.clear();
    print("delete Shared Preferences");
  }

  void initSP() async {
    print("initializing Shared Preferences");
    prefs = await SharedPreferences.getInstance();
  }

  void updateListOfUsers() async {
    //Алгоритм кеширования можно конечно улучшить, но для текущих целей сойдет
    prefs = await SharedPreferences.getInstance();
    bool isCached = prefs.getString("USERS") != null;
    var response;

    if (!isCached) {
      print("no users in SP");
      response =
          await get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      prefs.setString("USERS", response.body);
    }
    List temp = jsonDecode(isCached ? prefs.getString("USERS") : response.body);

    listOfUsers = temp.map((e) => UserModel.fromJson(e)).toList();
  }

  List<PostModel> _posts = [];

  List<PostModel> get posts {
    if (_posts.isEmpty) updatePosts();
    if (_selectedPostID > 0 && _posts[_selectedPostID].comments.isEmpty)
      downloadPostComments();

    return _posts;
  }

  set posts(List<PostModel> posts) {
    _posts = posts;
    prefs.setString("POSTS", jsonEncode(posts.map((e) => e.toJson()).toList()));

    notifyListeners();
  }

  void updatePosts() async {
    bool isCached = prefs.getString("POSTS") != null;
    var response;

    if (!isCached) {
      response =
          await get(Uri.parse('https://jsonplaceholder.typicode.com/posts/'));
    }
    List temp = jsonDecode(isCached ? prefs.getString("POSTS") : response.body);
    posts = temp.map((e) => PostModel.fromJson(e)).toList();
  }

  void downloadPostComments() async {
    print('downloading comment for post $selectedPostID');
    var response = await get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts/$selectedPostID/comments'));
    List temp = jsonDecode(response.body);
    var comments = temp.map((e) => CommentModel.fromJson(e)).toList();
    // posts[selectedPostID].comments = comments;
    posts[selectedPostID].comments = comments;
    posts = _posts;
    //костылек конечно, можно поэлегантнее
  }

  List<AlbumModel> _albums = [];

  List<AlbumModel> get albums {
    if (_albums.isEmpty) updateAlbums();
    return _albums;
  }

  set albums(List<AlbumModel> albums) {
    _albums = albums;
    notifyListeners();
  }

  void updateAlbums() async {
    bool isCached = prefs.getString("ALBUMS") != null;
    var response;

    if (!isCached) {
      response =
          await get(Uri.parse('https://jsonplaceholder.typicode.com/albums/'));
      prefs.setString("ALBUMS", response.body);
    }
    List temp =
        jsonDecode(isCached ? prefs.getString("ALBUMS") : response.body);
    albums = temp.map((e) => AlbumModel.fromJson(e)).toList();
  }
}
