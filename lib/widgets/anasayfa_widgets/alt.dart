import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/ana.dart';
import 'package:photo_like_app/widgets/listeleme/kisiler.dart';

import '../../database/database.dart';

class Alt extends StatefulWidget {
  var begeni;
  var yorum;
  final Map bilgiler;
  Alt(
      {required this.begeni,
      required this.yorum,
      required this.bilgiler,
      Key? key})
      : super(key: key);

  @override
  State<Alt> createState() => _AltState();
}

class _AltState extends State<Alt> {
  @override
  Widget build(BuildContext context) {
    return begenyorum(widget.begeni, widget.yorum);
  }

  static bool begendimi = false;

  void update(begendimi) {
    if (!begendimi) {
      setState(() {
        print(this);
        this;
      });
    }
  }

  Widget begenyorum(int begeni, int yorum) {
    return Column(
      children: [
        /*  */
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () async {},
              icon: Icon(
                begendimi ? Icons.favorite : Icons.favorite_border_rounded,
                size: 36,
                color: begendimi ? Colors.red : Colors.black,
              ),
              label: Center(),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 255, 255, 255),
                elevation: 0,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/yorumlar',
                    arguments: widget.bilgiler);
                setState(() {});
              },
              icon: Icon(
                begendimi ? Icons.mode_comment_outlined : Icons.mode_comment,
                size: 36,
                color: begendimi ? Colors.red : Colors.black,
              ),
              label: Center(),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 255, 255, 255),
                elevation: 0,
              ),
            ),
            LikeButton(
              likeBuilder: (isLiked) {
                return Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                  size: 32,
                  color: isLiked ? Colors.red : Colors.black,
                );
              },
              size: 50,
              onTap: (isLiked) async {
                widget.begeni++;
                update(isLiked);
                return true;
              },
            ),
            LikeButton(
              likeBuilder: (isLiked) {
                return Icon(
                  Icons.mode_comment_outlined,
                  size: 32,
                );
              },
              size: 50,
              onTap: (isLiked) async {
                return true;
              },
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/kisiler',
                    arguments: widget.bilgiler);
                setState(() {});
              },
              child: Text(
                '${widget.begeni} Beğeni',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 255, 255)),
            ),
            Text('Kişi Yorumu'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/yorumlar',
                    arguments: widget.bilgiler);
                setState(() {});
              },
              child: Text(
                '${widget.begeni} Yorum',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 255, 255)),
            ),
          ],
        )
      ],
    );
  }
}




/*
ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/kisiler',
                    arguments: widget.bilgiler);
                setState(() {});
              },
              label: Text(
                '${widget.begeni} Beğeni',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              icon: Icon(
                  begeni == 0
                      ? Icons.heart_broken_sharp
                      : Icons.favorite_border_rounded,
                  color: Color.fromARGB(255, 185, 65, 65)),
              style: ElevatedButton.styleFrom(
                  primary: begeni == 0
                      ? Color.fromARGB(255, 40, 49, 56)
                      : Color.fromARGB(255, 141, 23, 23)),
            ),
 */