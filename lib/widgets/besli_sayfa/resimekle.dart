import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_like_app/database/database.dart';
import 'package:photo_like_app/widgets/besli_sayfa/ekle.dart';

class Resimekle extends StatefulWidget {
  static File? file;
  Resimekle({Key? key}) : super(key: key);

  @override
  State<Resimekle> createState() => _ResimekleState();
}

class _ResimekleState extends State<Resimekle> {
  File? filex;
  @override
  deger() {
    filex = Resimekle.file;
  }

  Widget build(BuildContext context) {
    TextEditingController yorum = new TextEditingController();

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ekle(),
            Container(
              width: 360,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.arrow_upward,
                        color: Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () async {
                        deger();
                        print(filex.toString());
                        await Data()
                            .uploadImage(filex!, 'Pictures', yorum: yorum.text);
                        setState(() {});
                      },
                      label: Text(
                        'Yükle',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Yorum',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                controller: yorum,
              ),
            ),
            /* ElevatedButton.icon(
                icon: Icon(Icons.arrow_upward),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 36, 74, 88),
                ),
                onPressed: () async {
                  deger();
                  print(filex.toString());
                  await Data()
                      .uploadImage(filex!, 'Pictures', yorum: yorum.text);
                  setState(() {});
                },
                label: Text('Yükle'))*/
          ],
        ),
      ),
    );
  }
}
