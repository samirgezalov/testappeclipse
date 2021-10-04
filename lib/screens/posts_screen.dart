import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappeclipse/helpers/provider_helper.dart';
import 'package:testappeclipse/screens/detailed_post_screen.dart';

class PostsScreen extends StatelessWidget {
  // const PostsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ProviderHelper>(context);
    var userPosts = data.posts
        .where((element) => element.userId == data.selectedUserID)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(data.listOfUsers
                .firstWhere((element) => element.id == data.selectedUserID)
                .username ??
            ""),
      ),
      body: ListView.builder(
        itemCount: userPosts.length,
        itemBuilder: (BuildContext context, int post) {
          return GestureDetector(
            onTap: () {
              data.selectedPostID = userPosts[post].id!;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailedPostScreen()));
            },
            child: Card(
              child: ListTile(
                title: (Text(userPosts[post].title ?? "")),
                subtitle: (Text(userPosts[post]
                    .body!
                    .substring(0, userPosts[post].body!.indexOf("\n")))),
              ),
            ),
          );

          // Provider.of<ProviderHelper>(context).posts[post];
        },
      ),
    );
  }
}
