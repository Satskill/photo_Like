import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';

class sohbetgoruntule extends StatefulWidget {
  sohbetgoruntule({Key? key}) : super(key: key);

  @override
  State<sohbetgoruntule> createState() => _sohbetgoruntuleState();
}

class _sohbetgoruntuleState extends State<sohbetgoruntule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: Data().sohbetgoruntule(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final bilgiler = snapshot.data[index];
                return ListTile(
                  title: Text(bilgiler['sohbet']),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
