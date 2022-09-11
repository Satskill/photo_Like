import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';

class sohbetgoruntule extends StatefulWidget {
  final sohbetuser;
  sohbetgoruntule({required this.sohbetuser, Key? key}) : super(key: key);

  @override
  State<sohbetgoruntule> createState() => _sohbetgoruntuleState();
}

class _sohbetgoruntuleState extends State<sohbetgoruntule> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController sohbetet = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Data().sohbetgoruntule(widget.sohbetuser),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final bilgiler = snapshot.data['${index + 1}'];
                      print('burası');
                      print(widget.sohbetuser);
                      print('sohbetgoruntule');
                      print('burası');
                      print(bilgiler);
                      Timestamp time = bilgiler['Time'];
                      print(time.seconds);
                      return Container(
                        alignment: bilgiler['Sender'].toString() ==
                                auth.currentUser!.email
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 350,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Card(
                                  elevation: 6,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 8, 2),
                                    child: Text.rich(
                                        textAlign:
                                            bilgiler['Sender'].toString() ==
                                                    auth.currentUser!.email
                                                ? TextAlign.right
                                                : TextAlign.left,
                                        TextSpan(children: <TextSpan>[
                                          new TextSpan(
                                              style: TextStyle(fontSize: 16),
                                              text: bilgiler['Sohbet']
                                                      .toString() +
                                                  '\n'),
                                          new TextSpan(
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color.fromARGB(
                                                      255, 73, 73, 73)),
                                              text: DateTime.parse(time
                                                          .toDate()
                                                          .toString())
                                                      .hour
                                                      .toString() +
                                                  ':' +
                                                  (DateTime.parse(time.toDate().toString())
                                                              .minute
                                                              .toString()
                                                              .length ==
                                                          1
                                                      ? '0' +
                                                          DateTime.parse(time
                                                                  .toDate()
                                                                  .toString())
                                                              .minute
                                                              .toString()
                                                      : DateTime.parse(
                                                              time.toDate().toString())
                                                          .minute
                                                          .toString()))
                                        ])
                                        /*'${bilgiler['Sohbet']}\n${DateTime.parse(time.toDate().toString()).hour.toString() + ':' + (DateTime.parse(time.toDate().toString()).minute.toString().length == 1 ? '0' + DateTime.parse(time.toDate().toString()).minute.toString() : DateTime.parse(time.toDate().toString()).minute.toString())}',
                                      style: TextStyle(fontSize: 18),
                                      textAlign:
                                          bilgiler['Sender'].toString() ==
                                                  auth.currentUser!.email
                                              ? TextAlign.right
                                              : TextAlign.left,*/
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: Icon(Icons.comments_disabled),
                );
              },
            ),
          ),
          TextField(
            maxLines: null,
            controller: sohbetet,
            decoration: InputDecoration(
                hintText: 'Mesaj..',
                suffixIcon: Padding(
                  padding: EdgeInsets.all(2),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white, elevation: 0),
                    child: Text(
                      'Gönder',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      Data().sohbetekle(widget.sohbetuser, sohbetet.text);
                      sohbetet.text = '';
                    },
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
