import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/sohbet/sohbetler.dart';

import '../../database/database.dart';

class sohbetliste extends StatefulWidget {
  final arama;
  sohbetliste({required this.arama, Key? key}) : super(key: key);

  @override
  State<sohbetliste> createState() => _sohbetlisteState();
}

class _sohbetlisteState extends State<sohbetliste> {
  List<Map> bilgilerim = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                child: TextField(
                    onChanged: (value) async {
                      if (value.length > 0) {
                        bilgilerim = await Data().sohbetisimara(value);
                        print(await Data().sohbetisimara(value));
                        print(bilgilerim);
                        print(value.length);
                        print('uzunluk');
                      } else if (value.length <= 0) {
                        bilgilerim = [];
                      }
                      setState(() {});
                    },
                    controller: widget.arama,
                    decoration: InputDecoration(labelText: 'Sohbet Arama')),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.fromLTRB(0, 6, 12, 0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/followsohbet');
                  },
                  child: Icon(Icons.add)),
            )*/
          ],
        ),
        bilgilerim.isEmpty
            ? Expanded(
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
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: bilgilerim.length,
                  itemBuilder: (context, index) {
                    print(bilgilerim[index].values.first['ProfilePic']);
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profil',
                            arguments: bilgilerim[index].values.first['Mail']);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              bilgilerim[index].values.first['ProfilePic']),
                        ),
                        title: Text(bilgilerim[index].keys.first.toString()),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
