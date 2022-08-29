import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';

class sohbetgoruntule extends StatefulWidget {
  final sohbetuser;
  sohbetgoruntule({required this.sohbetuser, Key? key}) : super(key: key);

  @override
  State<sohbetgoruntule> createState() => _sohbetgoruntuleState();
}

class _sohbetgoruntuleState extends State<sohbetgoruntule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: Data().sohbetgoruntule(widget.sohbetuser),
        builder: (context, AsyncSnapshot snapshot) {
          print(widget.sohbetuser);
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data,
              itemBuilder: (context, index) {
                final bilgiler = snapshot.data[index];
                print('sohbetgoruntule');
                print(bilgiler);
                return ListTile(
                  title: Text(bilgiler),
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
