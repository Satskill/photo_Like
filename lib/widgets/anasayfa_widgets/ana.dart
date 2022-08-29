import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/alt.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/baslik.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/hikaye.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/resim.dart';

import '../../database/database.dart';

class Ana extends StatefulWidget {
  final snapshot;
  final index;
  final kullanici;
  final auth;
  Ana({this.snapshot, this.index, required this.kullanici, this.auth, Key? key})
      : super(key: key);

  GlobalKey begenikey = GlobalKey();
  @override
  State<Ana> createState() => _AnaState();
}

class _AnaState extends State<Ana> {
  @override
  Widget build(BuildContext context) {
    return followingfotolar(widget.snapshot, widget.index, widget.kullanici);
  }

  Widget followingfotolar(var snapshot, var index, String kullanici) {
    try {
      final images = snapshot.data![index];

      final List<Map> sayi = snapshot.data!;

      final bilgiler = {
        'name': images['name'],
        'uploader': images['uploader'],
        'tur': 'Beğeniler'
      };

      return Column(
        children: [
          baslik(kisi: kullanici, sayi: sayi.length),
          //resim(images: images, kullanici: kullanici, auth: widget.auth),
          FutureBuilder(
            future: Data().likescomments(kullanici, images['name']),
            builder: (context, AsyncSnapshot snapshotim) {
              if (snapshotim.connectionState == ConnectionState.done &&
                  snapshotim.hasData) {
                bool begenivarmi = false;
                final List bilgianlik = snapshotim.data['UsersLike'];
                if (bilgianlik.contains(widget.auth)) {
                  begenivarmi = true;
                }
                bilgiler['images'] = images;
                bilgiler['kullanici'] = kullanici;
                bilgiler['auth'] = widget.auth;
                bilgiler['begenivarmi'] = begenivarmi;
                bilgiler['UsersComment'] = snapshotim.data['UsersComment'];
                return resim(
                  images: images,
                  kullanici: kullanici,
                  auth: widget.auth,
                  begeni: snapshotim.data!['Like'] as int,
                  yorum: snapshotim.data!['Comment'] as int,
                  bilgiler: bilgiler,
                )
                    /*Alt(
                  begeni: snapshotim.data!['Like'] as int,
                  yorum: snapshotim.data!['Comment'] as int,
                  bilgiler: bilgiler,
                )*/
                    ;
              }
              return resim(
                images: images,
                kullanici: kullanici,
                auth: widget.auth,
                begeni: 0,
                yorum: 0,
                bilgiler: bilgiler,
              )
                  /* Alt(
                begeni: 0,
                yorum: 0,
                bilgiler: bilgiler,
              )*/
                  ;
            },
          ),
          Container(
            height: 20,
          )
        ],
      );
    } catch (e) {
      return Text(e.toString());
    }
  }
}
