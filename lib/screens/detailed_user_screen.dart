import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappeclipse/helpers/provider_helper.dart';
import 'package:testappeclipse/model/user_model.dart';
import 'package:testappeclipse/screens/posts_screen.dart';
import 'package:testappeclipse/widgets/adress_view.dart';

import 'albums_screen.dart';

class DetailedUserScreen extends StatelessWidget {
  const DetailedUserScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ProviderHelper>(context);
    UserModel userModel = data.listOfUsers
        .firstWhere((element) => element.id == data.selectedUserID);
    var userPosts =
        data.posts.where((element) => element.userId == userModel.id).toList();
    var userAlbums =
        data.albums.where((element) => element.userId == userModel.id).toList();
    return Scaffold(
      appBar: AppBar(title: Text(userModel.username ?? "")),
      body: Container(
        child: Column(
          children: [
            Text(userModel.name ?? ""),
            Text(userModel.email ?? ""),
            Text(userModel.phone ?? ""),
            Text(userModel.website ?? ""),
            Text(userModel.company!.name ?? ""),
            Text(userModel.company!.bs ?? ""),
            Text(userModel.company!.catchPhrase ?? "",
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                )),
            SizedBox(height: 10),
            AdressView(adress: userModel.address),
            SizedBox(height: 10),
            Expanded(
              // height: 150,
              child: data.posts.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return PostsScreen();
                        }));
                      },
                      child: ListView.builder(
                        itemCount: userPosts.length > 3 ? 3 : userPosts.length,
                        itemBuilder: (BuildContext context, int post) {
                          return Card(
                            child: ListTile(
                              title: (Text(userPosts[post].title ?? "")),
                              subtitle: (Text(userPosts[post].body!.substring(
                                  0, userPosts[post].body!.indexOf("\n")))),
                            ),
                          );

                          // Provider.of<ProviderHelper>(context).posts[post];
                        },
                      ),
                    ),
            ),
            Expanded(
              // height: 150,
              child: data.albums.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return AlbumsScreen();
                        }));
                      },
                      child: ListView.builder(
                        itemCount:
                            userAlbums.length > 3 ? 3 : userAlbums.length,
                        itemBuilder: (BuildContext context, int album) {
                          return Card(
                            child: Column(
                              children: [
                                Text(userAlbums[album].title ?? ""),
                              ],
                            ),
                          );

                          // Provider.of<ProviderHelper>(context).posts[post];
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
