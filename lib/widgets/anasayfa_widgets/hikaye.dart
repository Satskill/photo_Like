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
          return customlistim(widget.bilgi, snapshot.data);
        }
        //List gecici = widget.bilgi[0];
        widget.bilgi.removeWhere((element) {
          return element != widget.auth;
        });
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
            return GestureDetector(
              onTap: () async {
                print(tumbilgi);
                print(tumbilgi[0]['time']);
                print(DateTime.parse(tumbilgi[0]['time']));
                print(DateTime.now());
                DateTime zaman = DateTime.parse(tumbilgi[0]['time']);
                print(zaman.year.toString());
                print(DateTime.now().difference(zaman));
                if (DateTime.now().difference(zaman).inHours < 24) {
                  print('ifteyim');
                }
                print(DateTimeRange(start: zaman, end: DateTime.now()));
                await Data().hikayeler(context, index, '');
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
                  Center(child: Text('Isim')),
                ],
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
