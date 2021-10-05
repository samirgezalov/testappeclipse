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

////////////////////////////////////////////////
  int _selectedPostID = 0;

  int get selectedPostID => _selectedPostID;

  set selectedPostID(int value) {
    _selectedPostID = value;
  }

///////////////////////////////////////////////
  int _selectedAlbumID = 0;

  int get selectedAlbumID => _selectedAlbumID;

  set selectedAlbumID(int value) {
    _selectedAlbumID = value;
  }

//////////////////////////////////////////////////////////////////////////////////////////
  List<UserModel> _listOfUsers = [];
//Следующий метод будет вызван в начале, т.к первая же страница обращается к листу пользователей
  //если пользователи есть в базе (шерд преференс) то возьмет оттуда, иначе запросит с сервера,
  //попутно обновив базу
  List<UserModel> get listOfUsers {
    if (_listOfUsers.isEmpty) updateListOfUsers();
    return _listOfUsers;
  }

  set listOfUsers(List<UserModel> users) {
    _listOfUsers = users;
    notifyListeners();
  }

  void updateListOfUsers() async {
    //Алгоритм кеширования можно конечно улучшить, но для текущих целей сойдет
    prefs = await SharedPreferences.getInstance();

    ///Вообще инициализацию Шеред префенсез желательно делать как можно раньше, однако
    ///в данной ситуации благодоря нынешнему решению инициализация происходит по первому
    ///обращению, и не допускает ошибку обращения следующей строки к неинициализированной
    ///переменной prefs
    bool isCached = prefs.getString("USERS") != null;
    var response;

    if (!isCached) {
      print("User list doesn't exist in storage, downloading");
      response =
          await get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      prefs.setString("USERS", response.body);
      //При необходимости или просадке производительности  парсинг Json
      //можно производить в отдельном Isolate . В конкретном же случае
      //нет необходимости
    }
    List temp = jsonDecode(isCached ? prefs.getString("USERS") : response.body);

    listOfUsers = temp.map((e) => UserModel.fromJson(e)).toList();
  }

///////////////////////////////////////////////////////////////////////////////
  List<PostModel> _posts = [];

  List<PostModel> get posts {
    if (_posts.isEmpty) updatePosts();
    if (_selectedPostID > 0 && _posts[_selectedPostID].comments.isEmpty)
      downloadPostComments();
    //Здесь конечно не хватает интерактивности, но такой задачи не стояло.
    //Дело в том что однажды загруженная ветка коментов не будет обновлять себя,
    //А будет брать данные из базы

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
    _posts = temp.map((e) => PostModel.fromJson(e)).toList();
    if (!isCached) posts = _posts;
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

/////////////////////////////////////////////////////////////////////////////////////
  List<AlbumModel> _albums = [];

  List<AlbumModel> get albums {
    if (_albums.isEmpty) {
      updateAlbums();
    }
    // else {
    //   var listOfUserAlbums = _albums
    //       .where((element) => element.userId == _selectedUserID)
    //       .toList();
    //   if (listOfUserAlbums.last.photos.isEmpty)
    //     downloadAlbumPreview(listOfUserAlbums);
    // }
    return _albums;
  }

  set albums(List<AlbumModel> albums) {
    _albums = albums;
    prefs.setString(
        "ALBUMS", jsonEncode(_albums.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  void updateAlbums() async {
    bool isCached = prefs.getString("ALBUMS") != null;
    var response;
    print(isCached);
    if (!isCached) {
      response =
          await get(Uri.parse('https://jsonplaceholder.typicode.com/albums/'));
      prefs.setString("ALBUMS", response.body);
    }
    List temp =
        jsonDecode(isCached ? prefs.getString("ALBUMS") : response.body);
    _albums = temp.map((e) => AlbumModel.fromJson(e)).toList();
    if (!isCached) notifyListeners;
  }

  Future<bool> downloadAlbumPreview(List<AlbumModel> list) async {
    if (list.last.photos.isNotEmpty) return true;

    return await Future.forEach(list, (AlbumModel element) async {
      print('DOWNLOAD photo albums for user $_selectedUserID');
      List<PhotoModel> photos;
      var response = await get(Uri.parse(
          'https://jsonplaceholder.typicode.com/albums/${element.id}/photos'));
      List tmpListOfPhotos = jsonDecode(response.body);

      _albums.firstWhere((el) => element.id == el.id).photos =
          tmpListOfPhotos.map((e) => PhotoModel.fromJson(e)).toList();
    }).then((value) {
      albums = _albums;
      return true;
    });
  }

/////////////////////////////////////////////////////////////////////////////
  void removeVars() {
    _albums = [];
    _posts = [];
    print("delete Albums and Posts vars");
  }

  void removeSP() async {
    await prefs.clear();

    print("delete Shared Preferences");
  }
}
