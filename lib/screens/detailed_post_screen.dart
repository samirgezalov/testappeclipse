import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:testappeclipse/helpers/provider_helper.dart';
import 'package:testappeclipse/model/user_model.dart';

class DetailedPostScreen extends StatelessWidget {
  // const DetailedPostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ProviderHelper>(context);
    var post = data.posts[data.selectedPostID];

    return Scaffold(
      appBar: AppBar(title: Text(post.title ?? "")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(post.body ?? ""),
            post.comments.isEmpty
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      ...post.comments
                          .map((e) => Card(
                                  child: ListTile(
                                title: Text(e.name ?? ""),
                                subtitle: Text(e.body ?? ""),
                              )))
                          .toList()
                    ],
                  )
          ],
        ),
      ),
      floatingActionButton: Tooltip(
          message: 'Add a comment',
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  TextEditingController nameController =
                      TextEditingController();
                  TextEditingController emailController =
                      TextEditingController();
                  TextEditingController commentController =
                      TextEditingController();
                  return AlertDialog(
                    // title: const Text('AlertDialog Title'),
                    content: Container(
                      height: 300,
                      child: Column(
                        children: [
                          Text("Add a comment"),
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Name'),
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Email'),
                          ),
                          TextFormField(
                            controller: commentController,
                            minLines: 3,
                            maxLines: 7,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Comment'),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Send'),
                        onPressed: () async {
                          if (nameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              commentController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("please fill all fields")));
                            //Костыль, т.к нужно немного болше усилий чтобы было великолепно, а именно изменять цвет границ тех
                            //полей, которые не заполнены. и Ошибка должна светится в них же.
                          } else {
                            var response = await http.post(
                                Uri.parse(
                                    'https://jsonplaceholder.typicode.com/posts/${post.id}/comments'),
                                body: jsonEncode(CommentModel(
                                    name: nameController.text,
                                    email: emailController.text,
                                    body: commentController.text)));
                            print(response.body.toString());
                            if (response.statusCode == 201) {
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'error ${response.statusCode}')));
                            }
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          )),
    );
  }
}
