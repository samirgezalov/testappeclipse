import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappeclipse/helpers/provider_helper.dart';

class DetailedAlbumScreen extends StatelessWidget {
  // const DetailedAlbumScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ProviderHelper>(context);

    return Scaffold(
      appBar: AppBar(title: Text("album")),
      body: Column(
        children: [
          Text(data.albums[data.selectedAlbumID].title ?? ""),
        ],
      ),
    );
  }
}
