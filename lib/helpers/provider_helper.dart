import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:testappeclipse/model/user_model.dart';

class ProviderHelper with ChangeNotifier {
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

  void updateListOfUsers() async {
    var response =
        await get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    List temp = jsonDecode(response.body);
    listOfUsers = temp.map((e) => UserModel.fromJson(e)).toList();
  }

  List<PostModel> _posts = [];

  List<PostModel> get posts {
    if (_posts.isEmpty) updatePosts();
    return _posts;
  }

  set posts(List<PostModel> posts) {
    _posts = posts;
    notifyListeners();
  }

  void updatePosts() async {
    var response =
        await get(Uri.parse('https://jsonplaceholder.typicode.com/posts/'));

    List temp = jsonDecode(response.body);
    posts = temp.map((e) => PostModel.fromJson(e)).toList();
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
    var response =
        await get(Uri.parse('https://jsonplaceholder.typicode.com/albums/'));

    List temp = jsonDecode(response.body);
    albums = temp.map((e) => AlbumModel.fromJson(e)).toList();
  }
}
