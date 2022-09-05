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
                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 350,
                            ),
                            child: Column(
                              children: [
                                Card(
                                  elevation: 6,
                                  child: Text(
                                    bilgiler['Sohbet'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Text(DateTime.fromMicrosecondsSinceEpoch(
                                            time.seconds)
                                        .hour
                                        .toString() +
                                    ' : ' +
                                    DateTime.fromMicrosecondsSinceEpoch(
                                            time.seconds)
                                        .minute
                                        .toString())
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
                    child: Text('Gönder'),
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
