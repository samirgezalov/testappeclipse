import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappeclipse/helpers/provider_helper.dart';

class DetailedAlbumScreen extends StatelessWidget {
  // const DetailedAlbumScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ProviderHelper>(context);
    var albumSelected =
        data.albums.firstWhere((element) => element.id == data.selectedAlbumID);

    return Scaffold(
      appBar: AppBar(title: Text(albumSelected.title ?? "")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: CarouselSlider(
          options: CarouselOptions(
            scrollDirection: Axis.vertical,
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 0.5,
            aspectRatio: 2.0,
          ),
          items: [
            ...albumSelected.photos
                .map((e) => Card(
                      child: Stack(
                        children: [
                          ExtendedImage.network(
                            e.url ?? "",
                            // width: 150,
                            // height: 150,
                            fit: BoxFit.fill,
                            cache: true,
                            // border: Border.all(
                            //     color: Colors.red, width: 1.0),
                            // // shape: boxShape,
                            // borderRadius: BorderRadius.all(
                            //     Radius.circular(30.0)),
                            //cancelToken: cancellationToken,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 25, left: 10),
                              child: Text(e.title ?? ""))
                        ],
                      ),
                    ))
                .toList()
          ],
        ),
      ),
    );
  }
}
