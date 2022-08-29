import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';

class yorumlar extends StatefulWidget {
  final Map image;
  yorumlar({required this.image, Key? key}) : super(key: key);

  @override
  State<yorumlar> createState() => _yorumlarState();
}

class _yorumlarState extends State<yorumlar> {
  //TextEditingController yorumyap = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Data()
            .likescomments(widget.image['uploader'], widget.image['name']),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final yorum = snapshot.data;

            Map mapim = yorum['UsersComment'];

            List<dynamic> listem = [];
            List<int> kacyorumalmis = [];
            List<TextEditingController> yorumyap = List.generate(
                mapim.keys.length + 1, (i) => TextEditingController());

            for (int i = 1; i <= mapim.keys.length; i++) {
              Map altmapim = Map.from(mapim['Yorum$i']);
              for (int j = 1; j <= altmapim.keys.length; j++) {
                listem.add(mapim['Yorum$i']['Yorum$j']['Yorumcu']);
              }
              kacyorumalmis.add(altmapim.keys.length);
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: mapim.keys.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future:
                            Data().userlist(type: 'ProfilePics', users: listem),
                        builder: (context, AsyncSnapshot snapshots) {
                          if (snapshots.connectionState ==
                                  ConnectionState.done &&
                              snapshots.hasData) {
                            final resim = snapshots.data![index];

                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(resim['url']),
                                ),
                                title: Text(resim['name'] +
                                    '\n${mapim['Yorum${index + 1}'] /*['Yorum${kacyorumalmis[index]}']*/ ['Yorum1']['Yorum'].toString()}'),
                                subtitle: Column(
                                  children: [
                                    Column(
                                        children: digeryorumlar(
                                            mapim['Yorum${index + 1}'])),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: SizedBox(
                                        height: 50,
                                        child: TextField(
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            suffixIcon: ElevatedButton(
                                              onPressed: () async {
                                                await Data().Comment(
                                                    widget.image['uploader']
                                                        .toString(),
                                                    widget.image['name']
                                                        .toString(),
                                                    FirebaseAuth.instance
                                                        .currentUser!.email
                                                        .toString(),
                                                    yorumyap[index].text,
                                                    index + 1,
                                                    kacyorumalmis[index] + 1);
                                                setState(() {});
                                              },
                                              child: Text(
                                                'Yap',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  primary: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            labelText: 'Yorum yap',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                          ),
                                          controller: yorumyap[index],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Center(
                            child: index == 0
                                ? CircularProgressIndicator()
                                : Container(),
                          );
                        },
                      );
                    },
                  ),
                ),
                TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await Data().Comment(
                              widget.image['uploader'].toString(),
                              widget.image['name'].toString(),
                              FirebaseAuth.instance.currentUser!.email
                                  .toString(),
                              yorumyap[mapim.keys.length].text,
                              mapim.keys.length + 1,
                              1);
                          setState(() {});
                        },
                        child: Text(
                          'Onayla',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                    labelText: 'Yorum',
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  controller: yorumyap[mapim.keys.length],
                ),
              ],
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Widget> digeryorumlar(Map mapim) {
    List<Text> textler = [];
    for (int i = 1; i <= mapim.keys.length; i++) {
      /*Map altmapim = Map.from(mapim['Yorum$i']);
      for (int j = 1; j <= altmapim.keys.length; j++) {
        if (j == 1) {
          continue;
        }*/
      if (i == 1) {
        continue;
      }
      textler.add(
          Text('${mapim['Yorum$i']['Yorumcu']} ${mapim['Yorum$i']['Yorum']}'));
      //}
    }
    return textler;
  }
}
