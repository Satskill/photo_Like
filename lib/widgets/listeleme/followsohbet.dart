import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';

class followsohbet extends StatefulWidget {
  followsohbet({Key? key}) : super(key: key);

  @override
  State<followsohbet> createState() => _followsohbetState();
}

class _followsohbetState extends State<followsohbet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: Data()
            .userallinfo(FirebaseAuth.instance.currentUser!.email.toString()),
        builder: (context, AsyncSnapshot snapshots) {
          if (snapshots.connectionState == ConnectionState.done &&
              snapshots.hasData) {
            return FutureBuilder(
              future: Data().userlist(),
              builder: (context, AsyncSnapshot snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final resim = snapshot.data![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/sohbetgoruntule',
                            arguments: resim['user']);
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image.network(resim['url']),
                          title: Text(resim['name']),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
