import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/listeleme/kisiler.dart';

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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                  child: TextField(
                      onChanged: (value) {},
                      controller: arama,
                      decoration: InputDecoration(labelText: 'Sohbet Arama')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 12, 0),
                child: ElevatedButton(onPressed: () {}, child: Icon(Icons.add)),
              )
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: Data().sohbetler(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final bilgiler = snapshot.data[index];
                      print('sohbetler');
                      print(bilgiler);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(bilgiler['Image']),
                        ),
                        title: Text(bilgiler['User']),
                        subtitle: Text(bilgiler['Info']['1']['Sohbet']
                            .toString()
                            .substring(
                                0,
                                bilgiler['Info']['1']['Sohbet']
                                            .toString()
                                            .length <=
                                        20
                                    ? bilgiler['Info']['1']['Sohbet']
                                        .toString()
                                        .length
                                    : 20)),
                        onTap: () {
                          Navigator.pushNamed(context, '/sohbetgoruntule',
                              arguments: bilgiler['ID']);
                        },
                      );
                    },
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat, size: 60),
                      Text('Sohbet kutunuz boş')
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
