import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/besli_sayfa/profilresimekle.dart';
import 'package:photo_like_app/widgets/profilgoruntule/takipbutton.dart';

import '../../database/database.dart';

class profil extends StatefulWidget {
  final user;
  profil({this.user, Key? key}) : super(key: key);

  bool takipetme = false;
  void takipetmekte(takipetme) {
    if (takipetme == true) {
      takipetme = false;
    } else {
      takipetme = true;
    }
  }

  @override
  State<profil> createState() => _profilState();
}

class _profilState extends State<profil> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    print('geldi');
    print(user);
    List<String> kisi = ['Users/Pictures/$user'];
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: Data().userallinfo(user),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            Map bilgi = snapshot.data!;
            if (bilgi['Followers'].contains(auth.currentUser!.email)) {
              print('ifte true yaptım');
              widget.takipetme = true;
            } else {
              print('ifte false yaptım');
              widget.takipetme = false;
            }
            print(bilgi.keys);
            print(bilgi.values);
            print(bilgi.entries);
            print(bilgi['Following']);
            print(widget.takipetme);
            print(bilgi['Following'].contains(auth.currentUser!.email));
            print('***************************************************');
            print(bilgi.toString());
            return FutureBuilder(
              future: Data().imageList(kisi),
              builder: (context, AsyncSnapshot<List<Map>> snapshots) {
                if (snapshots.connectionState == ConnectionState.done &&
                    snapshots.hasData) {
                  var followers = ((bilgi['Followers']) as List).length;
                  var following = ((bilgi['Following']) as List).length;
                  var posts = snapshots.data!.length;
                  bilgi['User'] = user;
                  Map tumbilgiler = {};
                  tumbilgiler['posts'] = posts;
                  tumbilgiler['followers'] = followers;
                  tumbilgiler['user'] = user;
                  tumbilgiler['bilgi'] = bilgi;
                  tumbilgiler['following'] = following;
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
                                      type: 'baska',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 20),
                                      child: Text(
                                          '${bilgi['Info']['Isim']} ${bilgi['Info']['Soyisim']}'),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        followinfo(
                                            '${posts.toString()}\nPosts', 80),
                                        followinfo(
                                            '${followers.toString()}\nFollowers',
                                            100,
                                            kisi: user,
                                            tur: 'Followers',
                                            kisiler:
                                                (bilgi['Followers']) as List),
                                        followinfo(
                                            '${following.toString()}\nFollowing',
                                            100,
                                            kisi: user,
                                            tur: 'Following',
                                            kisiler:
                                                (bilgi['Following']) as List),
                                      ],
                                    ),

                                    /*Takip(
                                      takipetme: widget.takipetme,
                                      user: [user],
                                      follower: [auth.currentUser!.email],
                                      tumbilgiler: tumbilgiler,
                                    ),*/
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 20, 0, 0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 2,
                                            primary: widget.takipetme != true
                                                ? Colors.black
                                                : Colors.white),
                                        onPressed: () async {
                                          await Data().follow(
                                              widget.takipetme,
                                              [user],
                                              [auth.currentUser!.email]);
                                          if (widget.takipetme == true) {
                                            widget.takipetme = false;
                                          } else {
                                            widget.takipetme = true;
                                          }
                                          profil().takipetme = widget.takipetme;
                                          setState(() {});
                                        },
                                        child: Text(
                                          widget.takipetme != true
                                              ? 'Takip Et'
                                              : 'Takip Etme',
                                          style: TextStyle(
                                              color: widget.takipetme != true
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverGrid(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return fotolarGridDelegate(snapshots, index);
                          }, childCount: snapshots.data!.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
      ),
    );
  }

  Widget fotolarGridDelegate(AsyncSnapshot snapshots, var index) {
    try {
      final images = snapshots.data![index];
      return GestureDetector(
        onTap: () {
          images['current'] = FirebaseAuth.instance;
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
            print(bilgiler);
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
