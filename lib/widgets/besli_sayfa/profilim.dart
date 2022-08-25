import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/besli_sayfa/profilresimekle.dart';

import '../../database/database.dart';

class Profilim extends StatefulWidget {
  Profilim({Key? key}) : super(key: key);

  @override
  State<Profilim> createState() => _ProfilimState();
}

class _ProfilimState extends State<Profilim> {
  late FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser!.email.toString();
    List<String> kisi = ['Users/Pictures/$user'];
    return FutureBuilder(
      future: Data().userallinfo(user),
      builder: (context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var bilgi = snapshot.data!;
          return FutureBuilder(
            future: Data().imageList(kisi),
            builder: (context, AsyncSnapshot<List<Map>> snapshots) {
              if (snapshots.connectionState == ConnectionState.done &&
                  snapshots.hasData) {
                var followers = ((bilgi['Followers']) as List).length;
                var following = ((bilgi['Following']) as List).length;
                var posts = snapshots.data!.length;
                bilgi['User'] = user;
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white70,
                      expandedHeight: 200,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  profilekle(
                                    bilgi: bilgi,
                                    type: '',
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                    child: Text(
                                        '${bilgi['Info']['Isim']} ${bilgi['Info']['Soyisim']}'),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  followinfo('${posts.toString()}\nPosts', 80),
                                  followinfo(
                                      '${followers.toString()}\nFollowers', 100,
                                      kisi: user,
                                      tur: 'Followers',
                                      kisiler: (bilgi['Followers']) as List),
                                  followinfo(
                                      '${following.toString()}\nFollowing', 100,
                                      kisi: user,
                                      tur: 'Following',
                                      kisiler: (bilgi['Following']) as List),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return fotolarGridDelegate(snapshots, index);
                        }, childCount: snapshots.data!.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3)),
                  ],
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

  Widget fotolarGridDelegate(AsyncSnapshot snapshots, var index) {
    try {
      final images = snapshots.data![index];
      return GestureDetector(
        onTap: () {
          images['current'] = FirebaseAuth.instance.currentUser!.email;
          images['index'] = index;
          images['snapshot'] = snapshots;
          Navigator.pushNamed(context, '/goruntuleme', arguments: images);
        },
        child: Image.network(
          images['url'],
          fit: BoxFit.fill,
        ),
      );
    } catch (e) {
      return Text(e.toString());
    }
  }

  Widget followinfo(String bilgi, double width,
      {String? kisi, String? tur, List? kisiler}) {
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
        child: ElevatedButton(
          onPressed: () {
            Map bilgiler = {'tur': '$tur', 'bilgiler': kisiler};
            if (tur == 'Following') {
              Navigator.pushNamed(context, '/kisiler', arguments: bilgiler);
            } else if (tur == 'Followers') {
              Navigator.pushNamed(context, '/kisiler', arguments: bilgiler);
            }
          },
          child: Text(
            bilgi,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(primary: Colors.white),
        ),
      ),
    );
  }
}
