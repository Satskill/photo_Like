import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/ana.dart';

class goruntuleme extends StatefulWidget {
  final resimbilgisi;
  goruntuleme({required this.resimbilgisi, Key? key}) : super(key: key);

  @override
  State<goruntuleme> createState() => _goruntulemeState();
}

class _goruntulemeState extends State<goruntuleme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Ana(
          auth: widget.resimbilgisi['current'],
          index: widget.resimbilgisi['index'],
          kullanici: widget.resimbilgisi['uploader'],
          snapshot: widget.resimbilgisi['snapshot']),
    );
  }
}
