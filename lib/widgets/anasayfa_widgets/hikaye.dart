import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';

class hikaye extends StatefulWidget {
  final List followingphotos;
  final index;
  final auth;
  hikaye(
      {required this.followingphotos,
      required this.index,
      required this.auth,
      Key? key})
      : super(key: key);

  @override
  State<hikaye> createState() => _hikayeState();
}

class _hikayeState extends State<hikaye> {
  @override
  Widget build(BuildContext context) {
    print('hikaye tarafı');
    print(widget.followingphotos);
    print(widget.followingphotos[0]);
    return Row(
      children: [
        widget.index == -1
            ? Row(
                children: [
                  futureim(widget.auth),
                  futureim(widget.followingphotos[0])
                ],
              )
            : futureim(widget.followingphotos[widget.index])
      ],
    );
  }

  Widget futureim(String profilepic) {
    try {
      return FutureBuilder(
        future: Data().ProfilePicShow('Users/ProfilePics/$profilepic'),
        builder: (context, AsyncSnapshot snapshot) {
          print('hikaye devamı');
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            print('hikaye devamı');
            print(snapshot.data);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(snapshot.data),
                  ),
                ),
                Center(child: Text('Isim')),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    } catch (e) {
      return Container();
    }
  }
}
