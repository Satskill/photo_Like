import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/hikaye.dart';
import 'package:photo_like_app/widgets/besli_sayfa/anasayfawidget.dart';

import '../../database/database.dart';
import '../anasayfa_widgets/ana.dart';

class AnaSayfa extends StatefulWidget {
  AnaSayfa({Key? key}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
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
                        return Column(
                          children: [
                            hikaye(
                              followingphotos: bilgi,
                              index: index,
                              auth: auth.currentUser!.email,
                            ),
                            Ana(
                                snapshot: snapshots,
                                index: index,
                                kullanici: snapshots.data![index]['uploader']
                                    .toString(),
                                auth: auth.currentUser!.email),
                          ],
                        );
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
