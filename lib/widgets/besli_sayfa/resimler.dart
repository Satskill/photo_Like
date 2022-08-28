import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Resimler extends StatefulWidget {
  Resimler({Key? key}) : super(key: key);

  @override
  State<Resimler> createState() => _ResimlerState();
}

class _ResimlerState extends State<Resimler> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Data().user('Users/Pictures'),
      builder: (context, AsyncSnapshot<List<Map>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var index1 = 0;
          List<String> image = [];
          List<Map> deneme = snapshot.data!;
          deneme.forEach((element) {
            image.add(element['path']);
          });
          index1++;
          return FutureBuilder(
            future: Data().imageList(image),
            builder: (context, AsyncSnapshot<List<Map>> snapshots) {
              if (snapshots.connectionState == ConnectionState.done &&
                  snapshots.hasData) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    try {
                      final images = snapshots.data![index];

                      return GestureDetector(
                        child: Image.network(
                          images['url'],
                          fit: BoxFit.fill,
                        ),
                        onTap: () {
                          images['current'] = FirebaseAuth
                              .instance.currentUser!.email
                              .toString();
                          images['index'] = index;
                          images['snapshot'] = snapshots;
                          Navigator.pushNamed(context, '/goruntuleme',
                              arguments: images);
                        },
                      );
                    } catch (e) {
                      return Text(e.toString());
                    }
                  },
                  itemCount: snapshots.data?.length ?? 0,
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
