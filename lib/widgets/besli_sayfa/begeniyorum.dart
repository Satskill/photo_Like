import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';

class BegeniYorum extends StatefulWidget {
  BegeniYorum({Key? key}) : super(key: key);

  @override
  State<BegeniYorum> createState() => _BegeniYorumState();
}

class _BegeniYorumState extends State<BegeniYorum> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Data()
          .notifications(FirebaseAuth.instance.currentUser!.email.toString()),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final List bilgiler = snapshot.data;
          print(bilgiler[0]);
          Map mapim1 = bilgiler[0];
          Map mapim2 = bilgiler[1];
          Map mapim3 = bilgiler[2];
          if (mapim1.containsKey('Comments') ||
              mapim2.containsKey('Comments') ||
              mapim3.containsKey('Comments')) {
            print('var');
          }
          return ListView(
            children: [
              ListView.builder(
                itemCount: bilgiler.length,
                itemBuilder: (context, index) {
                  if (mapim1.containsKey('Comments') ||
                      mapim2.containsKey('Comments') ||
                      mapim3.containsKey('Comments')) {
                    print('var');
                    return ListTile();
                  }
                  return Text('yok');
                },
              )
            ],
          );
        }
        /* 
        mapim1.containsKey('Comments')
                      ? ListTile()
                      : mapim2.containsKey('Comments')
                          ? ListTile()
                          : mapim3.containsKey('Comments')
                              ? ListTile()
                              : Container(),
        */
        return Center(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notification_important_outlined,
                size: 60,
              ),
              Text(
                'Bildirimler Boş',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ));
      },
    );
  }
}
