import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testappeclipse/helpers/provider_helper.dart';

import 'detailed_user_screen.dart';

class ListOfUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // data.prefs=

    return Scaffold(
      appBar: AppBar(
        title: const Text("List of users"),
      ),
      // body: ListView.builder(itemBuilder: itemBuilder),
      body: Consumer<ProviderHelper>(builder: (context, itemRef, ch) {
        return ListView.builder(
          itemCount: itemRef.listOfUsers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // print(index);
                itemRef.selectedUserID = itemRef.listOfUsers[index].id!;
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DetailedUserScreen();
                }));
              },
              child: Card(
                child: Column(children: [
                  Text(itemRef.listOfUsers[index].username ?? ""),
                  Text(itemRef.listOfUsers[index].name ?? ""),
                ]),
              ),
            );
          },
        );
      }),
      floatingActionButton: Tooltip(
        message: "Clear Stored Data",
        child: FloatingActionButton(
            onPressed:
                Provider.of<ProviderHelper>(context, listen: false).removeSP,
            child: Icon(Icons.delete)),
      ),
    );
  }
}
