import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';

class kisiler extends StatefulWidget {
  final tur;
  final List kisilerresimler;
  final Map bilgiler;
  kisiler(
      {required this.bilgiler,
      required this.kisilerresimler,
      this.tur,
      Key? key})
      : super(key: key);

  @override
  State<kisiler> createState() => _kisilerState();
}

class _kisilerState extends State<kisiler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: widget.tur != 'Beğeniler'
            ? Data().userlist(users: widget.kisilerresimler, type: widget.tur)
            : Data().userlist(
                type: widget.tur,
                user: widget.bilgiler['uploader'],
                image: widget.bilgiler['name']),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
                if(widget.tur != 'Sohbet'){
                  return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final resim = snapshot.data![index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profil',
                        arguments: resim['user']);
                  },
                  child: Card(
                    child: ListTile(
                      leading: Image.network(resim['url']),
                      title: Text(resim['name']),
                    ),
                  ),
                );
              },
            );
                }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final resim = snapshot.data![index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profil',
                        arguments: resim['user']);
                  },
                  child: Card(
                    child: ListTile(
                      leading: Image.network(resim['url']),
                      title: Text(resim['name']),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
