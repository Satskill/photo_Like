import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_like_app/widgets/besli_sayfa/resimekle.dart';

import '../../database/database.dart';

class profilekle extends StatefulWidget {
  FileImage? image;
  dynamic fileimage;
  final bilgi;
  final type;
  profilekle({required this.bilgi, required this.type, Key? key})
      : super(key: key);

  @override
  State<profilekle> createState() => _profilekleState();
}

class _profilekleState extends State<profilekle> {
  ImageProvider<Object> imageim() {
    if (widget.image == null) {
      return AssetImage('assets/images/empty.jpg');
    } else {
      return widget.image!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Data().ProfilePicShow('Users/ProfilePics/${widget.bilgi['User']}'),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print(widget.bilgi.toString());
          print('bakalım neler var *********************************' +
              snapshot.data.toString() +
              widget.bilgi['User'].toString());
          return ElevatedButton(
            onPressed: () async {
              if (widget.type != 'baska') {
                try {
                  widget.fileimage = await Data().showImage(context);
                  if (widget.fileimage != null) {
                    await Data()
                        .uploadImage(widget.fileimage['file'], 'ProfilePics');
                    setState(() {});
                  }
                } catch (e) {
                  print(e);
                }
              }
            },
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(), padding: EdgeInsets.all(2)),
            child: CircleAvatar(
              minRadius: 50,
              maxRadius: 56,
              backgroundImage: new NetworkImage(!snapshot.hasData
                  ? 'https://firebasestorage.googleapis.com/v0/b/photo-like-92bf0.appspot.com/o/BlankUser%2Fblank-profile-picture.png?alt=media&token=43e4eadf-7f05-4303-a010-d4d2d60a1c81'
                  : '${snapshot.data}'),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
