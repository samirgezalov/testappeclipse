import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:testappeclipse/helpers/provider_helper.dart';
import 'package:testappeclipse/model/user_model.dart';
import 'package:testappeclipse/screens/posts_screen.dart';
import 'package:testappeclipse/widgets/adress_view.dart';

import 'albums_screen.dart';

class DetailedUserScreen extends StatelessWidget {
  DetailedUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ProviderHelper>(context, listen: false);
    UserModel userModel = data.listOfUsers
        .firstWhere((element) => element.id == data.selectedUserID);

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
            const SizedBox(height: 10),
            Expanded(
              // height: 150,
              child: Consumer<ProviderHelper>(builder: (context, itemRef, ch) {
                var userPosts = data.posts
                    .where((element) => element.userId == userModel.id)
                    .toList();
                print("Consumer & userpost loaded");
                return itemRef.posts.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return PostsScreen();
                          }));
                        },
                        child: ListView.builder(
                          itemCount:
                              userPosts.length > 3 ? 3 : userPosts.length,
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
                      );
              }),
            ),
            Expanded(
              child: Consumer<ProviderHelper>(builder: (context, itemRef, ch) {
                List<AlbumModel> userAlbums = itemRef.albums
                    .where((element) => element.userId == userModel.id)
                    .toList();
                print("Consumer & albums loaded");
                return FutureBuilder(
                  future: data.downloadAlbumPreview(userAlbums),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return AlbumsScreen();
                          }));
                        },
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              userAlbums.length > 3 ? 3 : userAlbums.length,
                          itemBuilder: (BuildContext context, int album) {
                            return Card(
                              child: Column(
                                children: [
                                  userAlbums[album].photos.isEmpty
                                      ? CircularProgressIndicator()
                                      : ExtendedImage.network(
                                          userAlbums[album].photos[0].url ?? "",
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.fill,
                                          cache: true,
                                        ),
                                  Container(
                                      width: 150,
                                      child: Text(
                                        userAlbums[album].title ?? "",
                                        softWrap: true,
                                      )),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }),
              // Expanded(
              //   // height: 150,
              //   child: userAlbums.isEmpty
              //       ? const Center(child: CircularProgressIndicator())
              //       : GestureDetector(
              //           onTap: () {
              //             Navigator.push(context,
              //                 MaterialPageRoute(builder: (BuildContext context) {
              //               return AlbumsScreen();
              //             }));
              //           },
              //           child: ListView.builder(
              //             scrollDirection: Axis.horizontal,
              //             itemCount:
              //                 userAlbums.length > 3 ? 3 : userAlbums.length,
              //             itemBuilder: (BuildContext context, int album) {
              //               return Card(
              //                 child: Column(
              //                   children: [
              //                     userAlbums[album].photos.isEmpty
              //                         ? CircularProgressIndicator()
              //                         : ExtendedImage.network(
              //                             userAlbums[album].photos[0].url ?? "",
              //                             width: 150,
              //                             height: 150,
              //                             fit: BoxFit.fill,
              //                             cache: true,
              //                             // border: Border.all(
              //                             //     color: Colors.red, width: 1.0),
              //                             // // shape: boxShape,
              //                             // borderRadius: BorderRadius.all(
              //                             //     Radius.circular(30.0)),
              //                             //cancelToken: cancellationToken,
              //                           ),
              //                     Container(
              //                         width: 150,
              //                         child: Text(
              //                           userAlbums[album].title ?? "",
              //                           softWrap: true,
              //                         )),
              //                   ],
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
