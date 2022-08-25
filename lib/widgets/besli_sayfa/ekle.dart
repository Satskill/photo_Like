import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_like_app/widgets/besli_sayfa/resimekle.dart';

import '../../database/database.dart';

class ekle extends StatefulWidget {
  FileImage? image;
  dynamic fileimage;
  ekle({Key? key}) : super(key: key);

  @override
  State<ekle> createState() => _ekleState();
}

class _ekleState extends State<ekle> {
  ImageProvider<Object> imageim() {
    if (widget.image == null) {
      return AssetImage('assets/images/empty.jpg');
    } else {
      return widget.image!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 360,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.white),
        onPressed: () async {
          widget.fileimage = await Data().showImage(context);
          if (widget.fileimage != null) {
            setState(() {
              try {
                widget.image = FileImage(File(widget.fileimage['file'].path));
              } catch (e) {
                print(e);
              }
            });
          }
        },
        child: Image(
          image: imageim(),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
