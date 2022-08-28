import 'package:flutter/material.dart';

import '../../database/database.dart';

class sohbetler extends StatefulWidget {
  sohbetler({Key? key}) : super(key: key);

  @override
  State<sohbetler> createState() => _sohbetlerState();
}

class _sohbetlerState extends State<sohbetler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: Data().sohbetler(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data,
              itemBuilder: (context, index) {
                final bilgiler = snapshot.data[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(bilgiler['profilepic']),
                    subtitle:
                        Text(bilgiler['sohbet'].toString().substring(0, 20)),
                    title: Text(bilgiler['kisi']),
                    onTap: () {
                      Navigator.pushNamed(context, '/sohbetgoruntule');
                    },
                  ),
                );
              },
            );
          }
          return Center(
            child: Column(
              children: [
                Icon(Icons.broken_image_outlined),
                Text('Sohbet kutunuz boş')
              ],
            ),
          );
        },
      ),
    );
  }
}
