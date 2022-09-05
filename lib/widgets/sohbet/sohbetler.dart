import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/listeleme/kisiler.dart';
import 'package:photo_like_app/widgets/sohbet/sohbetlerlistele.dart';

import '../../database/database.dart';

class sohbetler extends StatefulWidget {
  sohbetler({Key? key}) : super(key: key);

  @override
  State<sohbetler> createState() => _sohbetlerState();
}

class _sohbetlerState extends State<sohbetler> {
  TextEditingController arama = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: sohbetliste(
        arama: arama,
      ),
    );
  }
}
