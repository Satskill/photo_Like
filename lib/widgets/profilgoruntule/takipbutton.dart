import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';
import 'package:photo_like_app/widgets/profilgoruntule/profilgoruntule.dart';

class Takip extends StatefulWidget {
  bool takipetme;
  List user;
  List follower;
  Map tumbilgiler;
  Takip(
      {required this.user,
      required this.follower,
      required this.takipetme,
      required this.tumbilgiler,
      Key? key})
      : super(key: key);

  @override
  State<Takip> createState() => _TakipState();
}

class _TakipState extends State<Takip> {
  @override
  Widget build(BuildContext context) {
    /*return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 2,
            primary: widget.takipetme != true ? Colors.white : Colors.black),
        onPressed: () async {
          if (widget.takipetme == true) {
            widget.takipetme = false;
          } else {
            widget.takipetme = true;
          }
          await Data().follow(widget.takipetme, widget.user, widget.follower);
          profil().takipetme = widget.takipetme;
          setState(() {});
        },
        child: Text(
          widget.takipetme != true ? 'Takip Etme' : 'Takip Et',
          style: TextStyle(
              color: widget.takipetme != true ? Colors.black : Colors.white),
        ),
      ),
    );*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ustbilgi(
            widget.tumbilgiler['posts'],
            widget.tumbilgiler['followers'],
            widget.tumbilgiler['user'],
            widget.tumbilgiler['bilgi'],
            widget.tumbilgiler['following']),
        takipbutton()
      ],
    );
  }

  Widget takipbutton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 2,
            primary: widget.takipetme != true ? Colors.white : Colors.black),
        onPressed: () async {
          if (widget.takipetme == true) {
            widget.takipetme = false;
          } else {
            widget.takipetme = true;
          }
          await Data().follow(widget.takipetme, widget.user, widget.follower);
          profil().takipetme = widget.takipetme;
          setState(() {});
        },
        child: Text(
          widget.takipetme != true ? 'Takip Etme' : 'Takip Et',
          style: TextStyle(
              color: widget.takipetme != true ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  Widget ustbilgi(
      var posts, var followers, var user, var bilgi, var following) {
    return Row(
      children: [
        followinfo('${posts.toString()}\nPosts', 80),
        followinfo('${followers.toString()}\nFollowers', 100,
            kisi: user,
            tur: 'Followers',
            kisiler: (bilgi['Followers']) as List),
        followinfo('${following.toString()}\nFollowing', 100,
            kisi: user,
            tur: 'Following',
            kisiler: (bilgi['Following']) as List),
      ],
    );
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
