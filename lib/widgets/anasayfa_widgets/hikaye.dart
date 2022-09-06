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
          print('hikaye kısmı snapshot');
          print(snapshot.data);
          print(snapshot.data[widget.index]['time']);
          List sayilar = snapshot.data;
          print(sayilar.length);
          print(widget.bilgi);
          /*if (DateTime.now()
                    .difference(DateTime.parse(snapshot.data[i]['time']))
                    .inHours <
                24) {
              return customlistim(widget.bilgi, snapshot.data);
            }*/

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
    try {
      return FutureBuilder(
        future: Data().ProfilePicShow('Users/ProfilePics/$profilepic'),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (tumbilgi.length == index && !tumbilgi.contains(profilepic)) {
              return Container();
            } else {
              return GestureDetector(
                onTap: () async {
                  print(tumbilgi);
                  try {
                    final tumbilgifinal;
                    print(index);
                    print('****************************');
                    print('burdayım');
                    print(tumbilgi);
                    if (tumbilgi[index]['uploader'] !=
                            FirebaseAuth.instance.currentUser!.email &&
                        tumbilgi[0].isNotEmpty &&
                        tumbilgi[0]['url'] != '') {
                      tumbilgi.insert(0, {
                        'url': '',
                        'uploader': FirebaseAuth.instance.currentUser!.email
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
                    await Data().hikayeler(context, index, tumbilgifinal,
                        tumbilgi[index]['uploader']);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(snapshot.data),
                      ),
                    ),
                    Center(child: Text(widget.bilgi[index])),
                  ],
                ),
              );
            }
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
