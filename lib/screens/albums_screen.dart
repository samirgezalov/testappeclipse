import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappeclipse/helpers/provider_helper.dart';

import 'detailed_album_screen.dart';

class AlbumsScreen extends StatelessWidget {
  // const AlbumsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ProviderHelper>(context);
    var userAlbums = data.albums
        .where((element) => element.userId == data.selectedUserID)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(data.listOfUsers[data.selectedUserID].username ?? ""),
      ),
      body: ListView.builder(
        itemCount: userAlbums.length,
        itemBuilder: (BuildContext context, int album) {
          return GestureDetector(
            onTap: () {
              data.selectedAlbumID = userAlbums[album].id!;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailedAlbumScreen()));
            },
            child: Card(
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
                          // border: Border.all(
                          //     color: Colors.red, width: 1.0),
                          // // shape: boxShape,
                          // borderRadius: BorderRadius.all(
                          //     Radius.circular(30.0)),
                          //cancelToken: cancellationToken,
                        ),
                  Text(userAlbums[album].title ?? ""),
                ],
              ),
            ),
          );

          // Provider.of<ProviderHelper>(context).posts[post];
        },
      ),
    );
  }
}
