import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_like_app/widgets/besli_sayfa/ekle.dart';
import 'package:photo_like_app/widgets/besli_sayfa/resimekle.dart';

class Data {
  late FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> userim = [];
  StreamSubscription? streamsub;
  File? fileimage;
  XFile? xfileimage;
  String? usernamedata;

  void SignsWithMail(String _mail, String _password, BuildContext _context,
      {String? isim, String? soyisim, String? username}) async {
    final info = await firestore.collection('Users').doc('Usernames').get();

    bool varmi = false;

    print(info.data()!.entries);

    for (var element in info.data()!.keys) {
      if (element == username) {
        print(element);
        varmi = true;
      }
    }

    if (varmi == false) {
      try {
        print('ife girdim');
        var _user = await auth.signInWithEmailAndPassword(
            email: _mail, password: _password);
        final bilgim =
            await firestore.collection('Users').doc('Usernames').get();
        for (var element in bilgim.data()!.entries) {
          print(element.value);
          if (element.value['Mail'] == _mail) {
            print(element.key);
            usernamedata = element.key;
          }
        }
        Navigator.pushReplacementNamed(_context, '/fives');
      } catch (e) {
        try {
          var _newuser = await auth.createUserWithEmailAndPassword(
              email: _mail, password: _password);
          Navigator.pushReplacementNamed(_context, '/fives');
          //Navigator.pushNamed(_context, '/fives');
          firestore.collection('Users').doc('$_mail').set({
            'Followers': [],
            'Following': [],
            'Info': {'Isim': isim, 'Soyisim': soyisim, 'Username': username}
          });
          firestore.collection('Users').doc('Usernames').set({
            '$username': {
              'Mail': _mail,
              'ProfilePic':
                  'https://firebasestorage.googleapis.com/v0/b/photo-like-92bf0.appspot.com/o/BlankUser%2Fblank-profile-picture.png?alt=media&token=43e4eadf-7f05-4303-a010-d4d2d60a1c81'
            }
          }, SetOptions(merge: true));
          usernamedata = username;
        } catch (e) {
          AlertDialog _alert = AlertDialog(
            title: Text('Hata!'),
            content: Text(e.toString()),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(_context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        }
      }
    } else {
      AlertDialog(
        title: Text('Username mevcut'),
      );
    }
  }

  Future<dynamic> showImage(BuildContext context) async {
    await selectImage(context);
    Map files = {'file': fileimage, 'xfile': xfileimage};
    return files;
  }

  Future<void> selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        XFile? file;
        return AlertDialog(
          title: Text('Choose'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(
                  height: 1,
                ),
                ListTile(
                  onTap: () async {
                    try {
                      final ImagePicker imagePicker = new ImagePicker();
                      file = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      File filem = File(file!.path);
                      if (filem != null) {
                        fileimage = filem;
                        xfileimage = file;
                        Resimekle.file = filem;
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  title: Text('Gallery'),
                  leading: Icon(Icons.image),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  onTap: () async {
                    try {
                      final ImagePicker imagePicker = new ImagePicker();
                      file = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      File filem = File(file!.path);
                      if (filem != null) {
                        fileimage = filem;
                        xfileimage = file;
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  title: Text('Camera'),
                  leading: Icon(Icons.camera),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadImage(File filepath, String type, {String? yorum}) async {
    File file = File(filepath.path);
    String name = getRndString(32);
    String refpath;
    final email = FirebaseAuth.instance.currentUser!.email;

    if (type == 'ProfilePics') {
      refpath = 'Users/$type/$email';
    } else if (type == 'Story') {
      refpath = '$type/$email/$name';
    } else {
      refpath = 'Users/$type/$email/$name';
    }

    try {
      var metam = {'uploader': '$email', 'date': '${DateTime.now()}'};
      await storage.ref(refpath).putFile(
          file, firebase_storage.SettableMetadata(customMetadata: metam));
      if (type != 'ProfilePics' && type != 'Story') {
        firestore
            .collection('Posts')
            .doc('$email')
            .collection('$name')
            .doc('Likers')
            .set({});
        firestore
            .collection('Posts')
            .doc('$email')
            .collection('$name')
            .doc('Comments')
            .set({
          'Yorum1': {
            'Yorum1': {'Yorum': yorum, 'Date': DateTime.now(), 'Yorumcu': email}
          }
        });
      } else if (type == 'ProfilePics') {
        final profilfotom =
            await storage.ref('Users/ProfilePics/$email').getDownloadURL();
        firestore.collection('Users').doc('Usernames').set({
          '$usernamedata': {'Mail': email, 'ProfilePic': profilfotom}
        });
      }
      print(type);
      print(refpath);
      print(name);
      print('yüklendi');
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    } finally {
      print('sorunsuz çalıştım');
    }
  }

  Future<List<Map>> imageList(List<String> ref) async {
    List<Map> files = await [];

    await Future.forEach(ref, (value) async {
      firebase_storage.ListResult results =
          await storage.ref(value.toString()).listAll();
      final List<firebase_storage.Reference> allimages = results.items;

      await Future.forEach<firebase_storage.Reference>(allimages,
          (element) async {
        final String fileurl = await element.getDownloadURL();
        final firebase_storage.FullMetadata filemeta =
            await element.getMetadata();
        files.add({
          'url': fileurl,
          'path': element.fullPath,
          'name': element.name,
          'uploader': filemeta.customMetadata!['uploader'],
          'time': filemeta.customMetadata!['date']
        });
      });
      files.forEach((value) {
        //print(value.toString());
      });
    });
    files.sort(
      (a, b) {
        return (DateTime.parse(b['time'])).compareTo(DateTime.parse(a['time']));
      },
    );
    return files;
  }

  Future ProfilePicShow(String ref) async {
    try {
      return await storage.ref(ref).getDownloadURL();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> user(String ref) async {
    List<Map<String, dynamic>> users = [];

    firebase_storage.ListResult uploaders = await storage.ref(ref).list();

    final List<firebase_storage.Reference> allUsers = uploaders.prefixes;

    await Future.forEach<firebase_storage.Reference>(
        allUsers, (element) => users.add({'path': element.fullPath}));

    users.forEach((element) {
      print(element);
    });

    return users;
  }

  Future<Map> userallinfo(String user) async {
    var bilgiler = await firestore.collection('Users').get();
    Map geridonus = {};

    for (var element in bilgiler.docs) {
      if (element.id == user) {
        geridonus = element.data();
      }
    }
    return geridonus;
  }

  Future<List> userlist(
      {List? users, String? type, String? user, String? image}) async {
    List<Map> files = await [];

    if (type == 'Beğeniler') {
      Map gelenler = await likescomments(user!, image!);
      users = gelenler['UsersLike'] as List<String>;
    }

    await Future.forEach(users!, (element) async {
      firebase_storage.ListResult result =
          await storage.ref('Users/ProfilePics').listAll();

      bool varmi = false;

      result.items.forEach((eleman) {
        if (eleman.fullPath == 'Users/ProfilePics/$element') {
          varmi = true;
        }
      });

      if (!varmi) {
        result = await storage.ref('BlankUser').listAll();
      }

      final List<firebase_storage.Reference> allpics = result.items;
      await Future.forEach<firebase_storage.Reference>(allpics, (pics) async {
        final String url = await pics.getDownloadURL();
        final String uploader = element.toString();

        var isimget = await firestore.collection('Users').get();

        String isimsoyisim = '';
        for (var eleman in isimget.docs) {
          if (eleman.id == uploader) {
            isimsoyisim =
                eleman['Info']['Isim'] + ' ' + eleman['Info']['Soyisim'];
          }
        }
        if (pics.fullPath == 'Users/ProfilePics/$element') {
          files.add({'url': url, 'name': '$isimsoyisim', 'user': element});
        }
      });
    });

    return files;
  }

  Future Like(String user, String image, String liker) async {
    final post =
        await firestore.collection('Posts').doc(user).collection(image).get();

    for (var element in post.docs) {
      if (element.id == 'Likers') {
        try {
          if (element.data().containsKey(liker) &&
              element.data().containsValue(1)) {
            firestore
                .collection('Posts')
                .doc(user)
                .collection(image)
                .doc('Likers')
                .set(
              {'$liker': 0},
              SetOptions(merge: true),
            );
          } else {
            throw Error();
          }
        } catch (e) {
          firestore
              .collection('Posts')
              .doc(user)
              .collection(image)
              .doc('Likers')
              .set(
            {'$liker': 1},
            SetOptions(merge: true),
          );
        }
      }
    }
  }

  Future Comment(String user, String image, String commenter, String comment,
      int commentnumber, int altcommentnumber) async {
    final post =
        await firestore.collection('Posts').doc(user).collection(image).get();

    int yorumlar = 1;
    List<int> altyorumlar = [];

    print('Database comment');

    for (var element in post.docs) {
      if (element.id == 'Comments') {
        yorumlar = element.data().keys.length + 1;
      }
    }

    firestore
        .collection('Posts')
        .doc(user)
        .collection(image)
        .doc('Comments')
        .set({
      'Yorum$commentnumber': {
        'Yorum$altcommentnumber': {
          'Yorum': comment,
          'Yorumcu': commenter,
          'Date': DateTime.now()
        }
      }
    }, SetOptions(merge: true));
  }

  Future<Map> likescomments(String user, String image) async {
    final post =
        await firestore.collection('Posts').doc(user).collection(image).get();

    Map likecomment = {
      'Like': 0,
      'Comment': 0,
      'UsersLike': <String>[],
      'UsersComment': {}
    };

    for (var element in post.docs) {
      if (element.id == 'Likers') {
        for (var kisi in element.data().entries) {
          if (kisi.value == 1) {
            likecomment['UsersLike'] += [kisi.key];
            if (kisi.key == auth.currentUser!.email && kisi.value == 1) {
              likecomment['Like'] += 1;
            }
          }
        }
      }
      if (element.id == 'Comments') {
        for (var kisi in element.data().entries) {
          likecomment['Comment']++;
          /*likecomment['UsersComment'] = {
            kisi.key: kisi.value,
          };*/
          likecomment['UsersComment'][kisi.key] = kisi.value;
        }
      }
    }
    return likecomment;
  }

  Future follow(bool takip, List user, List follower) async {
    if (takip == true) {
      firestore
          .collection('Users')
          .doc(user[0])
          .update({'Followers': FieldValue.arrayRemove(follower)});
      firestore
          .collection('Users')
          .doc(follower[0])
          .update({'Following': FieldValue.arrayRemove(user)});
    } else {
      firestore.collection('Users').doc(user[0]).set({
        'Followers': [follower[0]]
      }, SetOptions(merge: true));
      firestore.collection('Users').doc(follower[0]).set({
        'Following': [user[0]]
      }, SetOptions(merge: true));
    }
  }

  Future<List<Map>> storyList(List<String> ref) async {
    List<Map> files = await [];

    await Future.forEach(ref, (value) async {
      firebase_storage.ListResult results =
          await storage.ref(value.toString()).listAll();
      final List<firebase_storage.Reference> allimages = results.items;

      await Future.forEach<firebase_storage.Reference>(allimages,
          (element) async {
        final String fileurl = await element.getDownloadURL();
        final firebase_storage.FullMetadata filemeta =
            await element.getMetadata();
        /*if((filemeta.customMetadata!['date'] as DateTime - DateTime.now() ) <= DateTime(0,0,1,0,0,0,0,0)){

            }*/
        var sonuc = DateTime.now()
            .difference(filemeta.customMetadata!['date'] as DateTime);
        if (sonuc == 1) {
          files.add({
            'url': fileurl,
            'path': element.fullPath,
            'name': element.name,
            'uploader': filemeta.customMetadata!['uploader']
          });
        }
      });
      files.forEach((value) {
        //print(value.toString());
      });
    });

    return files;
  }

  Future sohbetler() async {
    List<Map> files = [];
    final user = auth.currentUser!.email;

    final sohbetkisiler = await firestore.collection('Chats').get();

    for (var element in sohbetkisiler.docs) {
      if (element.id.contains(user.toString())) {
        final karsikisi = element.id.startsWith(user!)
            ? element.id.substring(user.length)
            : element.id.substring(0, element.id.length - user.length);

        files.add({
          'ID': element.id,
          'User': karsikisi,
          'Info': element.data(),
          'Image': await ProfilePicShow('Users/ProfilePics/${karsikisi}')
        });
      }
    }

    sohbetkisiler.docs.forEach((element) {
      //print(element.data().entries);
    });

    return files;
  }

  Future sohbetisimara(String isimgirisi) async {
    final usernames =
        await firestore.collection('Users').doc('Usernames').get();

    List<Map> infolar = [];

    for (var element in usernames.data()!.entries) {
      if (element.key.contains(isimgirisi)) {
        Map gecicimap = {element.key: element.value};
        infolar.add(gecicimap);
      }
    }

    return infolar;
  }

  Stream sohbetgoruntule(String chatuser) {
    //DatabaseReference ref = FirebaseDatabase.instance.ref('Chats/$chatuser');
    late final StreamController<Map> controller;

    var streamdoc = firestore.collection('Chats').snapshots();

    print('burdayım');
    streamdoc.listen((event) {
      event.docChanges.forEach((element) {
        if (element.doc.id == chatuser) {
          print(element.doc.data().toString());
        }
      });
    });

    print('controller dışı');
    controller = StreamController(
      onListen: () {
        //controller.add('deneme');
        print('içerideyim');
        streamdoc.listen((event) {
          event.docChanges.forEach((element) {
            if (element.doc.id == chatuser) {
              print(element.doc.data().toString());
              controller.add(element.doc.data()!);
            }
          });
        });
      },
    );

    return controller.stream;
  }

  Future sohbetekle(String chatuser, String mesaj) async {
    final sohbetler = await firestore.collection('Chats').doc(chatuser).get();

    int yeniohbetsayisi = sohbetler.data()!.length + 1;

    firestore.collection('Chats').doc(chatuser).set({
      '$yeniohbetsayisi': {
        'Sender': auth.currentUser!.email,
        'Sohbet': mesaj,
        'Time': DateTime.now()
      }
    }, SetOptions(merge: true));
  }

  void sohbetyoksaekle(String kisi, BuildContext context) async {
    final List<Map> bilgi = await sohbetler();
    bool varmi = false;
    String sohbet = '';
    print(kisi);
    bilgi.forEach((element) {
      String kisisohbet = element['ID'];
      if (kisisohbet.contains(kisi) &&
          kisisohbet.contains(auth.currentUser!.email.toString())) {
        varmi = true;
        sohbet = kisisohbet;
      }
      print('************************');
      print(element.keys);
      print(element['ID']);
    });
    if (varmi == false) {
      Navigator.pushNamed(context, '/sohbetgoruntule',
          arguments: '${auth.currentUser!.email.toString() + kisi}');
    } else {
      Navigator.pushNamed(context, '/sohbetgoruntule', arguments: sohbet);
    }
    print(varmi);
  }

  Future hikayetakibi(String kisi, Map images) async {
    final hikaye = await firestore.collection('Story').doc(kisi).get();

    if (hikaye.data()!.isNotEmpty) {
      hikaye.metadata.toString();
    }
  }

  Future hikayeekle(File filepath, String kisi) async {
    File file = File(filepath.path);
    String name = getRndString(32);

    try {
      var metam = {'uploader': '$kisi', 'date': '${DateTime.now()}'};
      await storage.ref('Story/$kisi/$name').putFile(
          file, firebase_storage.SettableMetadata(customMetadata: metam));
    } catch (e) {
      print(e);
    }
  }

  Future hikayeler(BuildContext context, int index, String storybilgiler) {
    print('hikayedeyim');
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black26,
            child: index == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            dynamic image = await showImage(context);
                            if (image != null) {
                              File imageim = File(fileimage!.path);
                              await hikayeekle(
                                  imageim, auth.currentUser!.email.toString());
                            }
                          },
                          child: Text('Kişi'),
                          style: ElevatedButton.styleFrom(
                              fixedSize:
                                  Size(MediaQuery.of(context).size.width, 60),
                              primary: Colors.black.withOpacity(0)),
                        ),
                        storybilgiler.isEmpty
                            ? Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image_outlined,
                                      size: 100,
                                    ),
                                    Text('Hikayeniz bulunmuyor'),
                                    ElevatedButton(
                                        onPressed: () async {
                                          FileImage? image;
                                          var fileimage =
                                              await Data().showImage(context);
                                          if (fileimage != null) {
                                            try {
                                              image = FileImage(
                                                  File(fileimage['file'].path));
                                              await Data().uploadImage(
                                                  File(fileimage['file'].path),
                                                  'Story');
                                            } catch (e) {
                                              print(e);
                                            }
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: Text('Ekle'))
                                  ],
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  child: Image.network(storybilgiler,
                                      fit: BoxFit.fill),
                                ),
                              ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pushNamed(context, '/profil',
                                arguments: user);
                          },
                          child: Text('Kişi'),
                          style: ElevatedButton.styleFrom(
                              fixedSize:
                                  Size(MediaQuery.of(context).size.width, 60),
                              primary: Colors.black.withOpacity(0)),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_outlined,
                                size: 100,
                              ),
                              Text('Hikayeniz bulunmuyor'),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Çık'))
                            ],
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

  static const _abc =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRndString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _abc.codeUnitAt(_rnd.nextInt(_abc.length))));
}
