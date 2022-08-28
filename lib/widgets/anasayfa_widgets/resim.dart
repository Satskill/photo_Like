import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/alt.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/ana.dart';

import '../../database/database.dart';

class resim extends StatefulWidget {
  final auth;
  final images;
  final kullanici;
  var begeni;
  var yorum;
  final Map bilgiler;
  resim(
      {required this.auth,
      required this.images,
      required this.kullanici,
      required this.begeni,
      required this.yorum,
      required this.bilgiler,
      Key? key})
      : super(key: key);

  @override
  State<resim> createState() => _resimState();
}

class _resimState extends State<resim> {
  Map yazi = {};
  @override
  Widget build(BuildContext context) {
    yazi = Map.from(widget.bilgiler['UsersComment'] ?? {});
    return Column(
      children: [
        doubler(widget.images, widget.kullanici),
        begenyorum(widget.begeni, widget.yorum)
      ],
    );
  }

  static bool begendimi = false;

  void update(begendimi) {
    setState(() {
      print(this);
      this;
    });
  }

  Widget doubler(Map images, String kullanici) {
    final ValueChanged begeni;
    begendimi = widget.bilgiler['begenivarmi'] ?? false;
    print('************************************************************');
    print(begendimi);
    print(widget.bilgiler);
    print(widget.bilgiler['UsersComment']);
    Alt? alt;
    return Container(
      height: 360,
      child: GestureDetector(
        onDoubleTap: () async {
          await Data().Like(kullanici, images['name'], widget.auth);
          print(begendimi);
          if (begendimi == true) {
            widget.bilgiler['begenivarmi'] = false;
            widget.begeni--;
          } else {
            widget.bilgiler['begenivarmi'] = true;
            widget.begeni++;
          }
          print(begendimi);
          update(begendimi);
        },
        child: Image.network(
          images['url'],
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget begenyorum(int begeni, int yorum) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Data().Like(
                      widget.kullanici, widget.images['name'], widget.auth);
                  if (begendimi == true) {
                    widget.bilgiler['begenivarmi'] = false;
                    widget.begeni--;
                  } else {
                    widget.bilgiler['begenivarmi'] = true;
                    widget.begeni++;
                  }
                  print(begendimi);
                  update(begendimi);
                },
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
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/yorumlar',
                    arguments: widget.bilgiler);
                setState(() {});
              },
              icon: Icon(
                Icons.mode_comment_outlined,
                size: 36,
                color: Colors.black,
              ),
              label: Center(),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 255, 255, 255),
                elevation: 0,
              ),
            ),
            /* LikeButton(
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
            )*/
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                widget.begeni != 0
                    ? ElevatedButton(
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
                            elevation: 0,
                            primary: Color.fromARGB(255, 255, 255, 255)),
                      )
                    : Container()
              ],
            ),
            yazi.containsKey('Yorum1')
                ? FutureBuilder(
                    future:
                        Data().userallinfo(yazi['Yorum1']['Yorum1']['Yorumcu']),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        final bilgi = snapshot.data['Info'];
                        print(
                            'Rasim içi **********//////////////*************** ${bilgi}');
                        return Row(children: [
                          Text('    ${bilgi['Isim']} ${bilgi['Soyisim']}  ',
                              style: TextStyle(
                                  color: Colors.black,
                                  decorationStyle: TextDecorationStyle.solid)),
                          Text('${yazi['Yorum1']['Yorum1']['Yorum']}'),
                        ]);
                      }
                      return Container();
                    },
                  )
                : Container(),
            widget.yorum != 0
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/yorumlar',
                          arguments: widget.bilgiler);
                      setState(() {});
                    },
                    child: Text(
                      '${widget.yorum} Yorum',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Color.fromARGB(255, 255, 255, 255)),
                  )
                : Container()
          ],
        )
      ],
    );
  }
}
