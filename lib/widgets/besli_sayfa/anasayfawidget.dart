import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/ana.dart';

import '../../database/database.dart';

class Sayfam extends StatefulWidget {
  Sayfam({Key? key}) : super(key: key);

  @override
  State<Sayfam> createState() => _SayfamState();
}

class _SayfamState extends State<Sayfam> {
  late FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser!.email.toString();
    List<String> following = [];
    return FutureBuilder(
      future: Data().userallinfo(user),
      builder: ((context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final bilgiler = snapshot.data!;
          var bilgi = bilgiler['Following'] as List;
          bilgi.forEach((element) {
            following.add('Users/Pictures/$element');
          });
          var kisisayisi = bilgi.length;
          return FutureBuilder(
              future: Data().imageList(following),
              builder: (context, AsyncSnapshot<List<Map>> snapshots) {
                if (snapshots.connectionState == ConnectionState.done &&
                    snapshots.hasData) {
                  return CustomScrollView(
                    slivers: [
                      SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        return Ana(
                            snapshot: snapshots,
                            index: index,
                            kullanici:
                                snapshots.data![index]['uploader'].toString(),
                            auth: auth.currentUser!.email);
                      }, childCount: snapshots.data!.length)),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
