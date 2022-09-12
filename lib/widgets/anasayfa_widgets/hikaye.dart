import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/hikayeekrani.dart';

class hikaye extends StatefulWidget {
  final index;
  final auth;
  final List bilgi;
  hikaye(
      {required this.index, required this.auth, required this.bilgi, Key? key})
      : super(key: key);

  @override
  State<hikaye> createState() => _hikayeState();
}

class _hikayeState extends State<hikaye> {
  List<String> refs = [];
  @override
  Widget build(BuildContext context) {
    widget.bilgi.forEach((element) {
      refs.add('Story/$element');
    });
    return FutureBuilder(
      future: Data().imageList(refs),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List sayilar = snapshot.data;
          print(sayilar);
          print(snapshot.data);
          /*if (DateTime.now()
                    .difference(DateTime.parse(snapshot.data[i]['time']))
                    .inHours <
                24) {
              return customlistim(widget.bilgi, snapshot.data);
            }*/
          print('girdim data gönderdim');
          if (sayilar.length == 0) {
            print('ife girdim');
            widget.bilgi.removeWhere((element) =>
                element != FirebaseAuth.instance.currentUser!.email);
          } else if (sayilar.length == 1) {
            sayilar.forEach((element) {
              if (element['name'].contains(widget.auth)) {
                widget.bilgi.removeWhere(
                    (e) => e != FirebaseAuth.instance.currentUser!.email);
              }
            });
          }

          print(widget.bilgi);
          return customlistim(widget.bilgi, snapshot.data);
        }
        //List gecici = widget.bilgi[0];
        /*widget.bilgi.removeWhere((element) {
          return element != widget.auth;
        });*/
        return customlistim(widget.bilgi, []);
      },
    );
  }

  Widget customlistim(List bilgi, List<Map> tumbilgiler) {
    return Container(
      height: 120,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              print('sayısı bura ***************** ${bilgi.length}');
              return futureim(bilgi[index], index, tumbilgiler);
            }, childCount: bilgi.length),
          ),
        ],
      ),
    );
  }

  Widget futureim(String profilepic, int index, List<Map> tumbilgi) {
    Map bilgi = {};
    try {
      return FutureBuilder(
        future: Data().ProfilePicShow('Users/ProfilePics/$profilepic'),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print('abooo ne var');
            return GestureDetector(
              onTap: () async {
                print(tumbilgi);
                //try {
                final tumbilgifinal;
                print(index);
                print('****************************');
                print('burdayım');
                print(tumbilgi);
                if (tumbilgi.isEmpty ||
                    tumbilgi[index]['uploader'] !=
                            FirebaseAuth.instance.currentUser!.email &&
                        tumbilgi[0].isNotEmpty &&
                        tumbilgi[0]['url'] != '') {
                  tumbilgi.insert(0, {
                    'url': '',
                    'uploader': FirebaseAuth.instance.currentUser!.email,
                    'time': DateTime.now().toString()
                  });
                }
                if (tumbilgi.isEmpty) {
                  print('ife girdim');
                  tumbilgifinal = '';
                } else {
                  print('else girdim');
                  tumbilgifinal = tumbilgi[index]['url'];
                  print('sorunyok');
                }
                await Data().hikayeler(
                    context,
                    index,
                    tumbilgifinal,
                    tumbilgi[index]['uploader'],
                    DateTime.now()
                        .difference(DateTime.parse(tumbilgi[index]['time']))
                        .inDays,
                    bilgi['Info']['Username']);
                /*   } catch (e) {
                  print(e);
                  print('hata');
                }*/
              },
              child: FutureBuilder(
                future: Data().userallinfo(widget.bilgi[index]),
                builder: (context, AsyncSnapshot snapshotim) {
                  if (snapshotim.connectionState == ConnectionState.done &&
                      snapshotim.hasData) {
                    bilgi = snapshotim.data;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(snapshot.data ??
                                'https://firebasestorage.googleapis.com/v0/b/photo-like-92bf0.appspot.com/o/BlankUser%2Fblank-profile-picture.png?alt=media&token=43e4eadf-7f05-4303-a010-d4d2d60a1c81'),
                          ),
                        ),
                        Center(child: Text(bilgi['Info']['Username'])),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    } catch (e) {
      return Container();
    }
  }
}
