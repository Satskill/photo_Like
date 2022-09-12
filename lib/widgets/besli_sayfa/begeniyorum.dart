import 'package:cloud_firestore/cloud_firestore.dart';
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
          Map Likes = {};
          List Follower = [];
          Map Comments = {};
          List listem = [];
          for (Map element in bilgiler) {
            if (element.containsKey('Likes')) {
              Likes = element.values.first;
              print(element.values);
            }
            if (element.containsKey('Follower')) {
              Follower = element.values.first;
              print(element.values.first);
            }
            if (element.containsKey('Comments')) {
              Comments = element.values.first;
              print('comment ifi');
              print(element.values.first);
            }
            print('döngü');
            print(element);
          }
          listem.add(Follower);
          for (var eleman in Likes.entries) {
            listem.add({eleman.key: eleman.value});
          }
          for (var eleman in Comments.entries) {
            print('çalıştı');
            listem.add({eleman.key: eleman.value});
          }
          Timestamp time = new Timestamp(0, 0);
          print(listem);
          return ListView.builder(
            itemCount: listem.length,
            itemBuilder: (context, index) {
              if (index != 0) {
                time = (((listem[index] as Map).values.first as List)[0] as Map)
                    .values
                    .last as Timestamp;
              }
              return ListTile(
                /* leading: index == 0
                    ? null
                    : Text('leading' +
                        '${FirebaseAuth.instance.currentUser!.email}/${(listem[index] as Map).keys.first}'),*/
                /*FutureBuilder(
                        future: Data().ProfilePicShow(
                            'Users/Pictures/${FirebaseAuth.instance.currentUser!.email}/${(listem[index] as Map).keys.first}'),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Image.network(snapshot.data);
                          }
                          return Container();
                        },
                      ),*/
                title: index == 0
                    ? Text(listem[0].length.toString() + ' Takipçi')
                    : Text((((listem[index] as Map).values.first as List)[0] as Map)
                                .keys
                                .first
                                .toString() ==
                            'Comment'
                        ? ((((listem[index] as Map).values.first as List)[0] as Map)
                                    .entries)
                                .where((element) => element.key == 'Commenter')
                                .first
                                .value
                                .toString() +
                            ' : ' +
                            (((listem[index] as Map).values.first as List)[0]
                                    as Map)
                                .values
                                .first
                                .toString()
                        : (((listem[index] as Map).values.first as List)[0] as Map)
                                .keys
                                .first
                                .toString() +
                            ' ve ' +
                            (((listem[index] as Map).values.first as List)[0]
                                    as Map)
                                .keys
                                .length
                                .toString() +
                            ' kişi beğendi'),
                subtitle: index == 0
                    ? null
                    : Text(
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 73, 73, 73)),
                        DateTime.parse(time.toDate().toString())
                                .hour
                                .toString() +
                            ':' +
                            (DateTime.parse(time.toDate().toString())
                                        .minute
                                        .toString()
                                        .length ==
                                    1
                                ? '0' +
                                    DateTime.parse(time.toDate().toString())
                                        .minute
                                        .toString()
                                : DateTime.parse(time.toDate().toString())
                                    .minute
                                    .toString())),
              );
            },
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
