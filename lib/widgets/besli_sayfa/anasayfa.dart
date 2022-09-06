import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/hikaye.dart';

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
          bilgi.insert(0, user);
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
                        delegate: SliverChildBuilderDelegate((context, index) {
                          print('hikaye gidecek bilgi');
                          print(bilgi);
                          return hikaye(
                            index: index,
                            auth: user,
                            bilgi: bilgi,
                          );
                        }, childCount: 1),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Column(
                            children: [
                              Ana(
                                  snapshot: snapshots,
                                  index: index,
                                  kullanici: snapshots.data![index]['uploader']
                                      .toString(),
                                  auth: user),
                            ],
                          );
                        }, childCount: snapshots.data!.length),
                      ),
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
