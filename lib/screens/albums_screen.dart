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
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetailedAlbumScreen())),
            child: Card(
              child: Column(
                children: [
                  Text(Provider.of<ProviderHelper>(context, listen: false)
                          .albums[album]
                          .title ??
                      ""),
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
