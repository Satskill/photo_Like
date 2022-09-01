import 'package:flutter/material.dart';

class hikayeekrani extends StatefulWidget {
  final index;
  hikayeekrani({required this.index, Key? key}) : super(key: key);

  @override
  State<hikayeekrani> createState() => _hikayeekraniState();
}

class _hikayeekraniState extends State<hikayeekrani> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: hikayeler(),
      builder: (context, snapshot) {
        return Container();
      },
    );
  }

  Future hikayeler() {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black26,
          child: widget.index == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image_outlined),
                      Text('Hikayeniz bulunmuyor'),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Çık'))
                    ],
                  ),
                )
              : Container(),
        );
      },
    );
  }
}
