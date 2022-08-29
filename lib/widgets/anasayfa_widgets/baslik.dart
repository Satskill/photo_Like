import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/profilgoruntule/profilgoruntule.dart';

import '../../database/database.dart';

class baslik extends StatefulWidget {
  final kisi;
  final sayi;
  baslik({required this.kisi, required this.sayi, Key? key}) : super(key: key);

  @override
  State<baslik> createState() => _baslikState();
}

class _baslikState extends State<baslik> {
  @override
  Widget build(BuildContext context) {
    return fotoprofil(widget.kisi);
  }

  Widget fotoprofil(String kisi) {
    List<String> donus = [kisi];
    return FutureBuilder(
      future: Data().userlist(users: donus),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length == 0
                ? widget.sayi
                : snapshot.data!.length,
            itemBuilder: (context, index) {
              final resim = snapshot.data![index];

              return ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/profil',
                      arguments: resim['user']);
                },
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(
                    resim['url'],
                  ),
                ),
                label: Text(
                  resim['name'],
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    alignment: Alignment.centerLeft,
                    primary: Colors.white,
                    fixedSize: Size(MediaQuery.of(context).size.width, 36)),
              );

              /*ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/profil',
                      arguments: resim['user']);
                },
                child: 
              );*/
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
