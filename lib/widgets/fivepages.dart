import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_like_app/widgets/besli_sayfa/anasayfa.dart';
import 'package:photo_like_app/widgets/besli_sayfa/begeniyorum.dart';
import 'package:photo_like_app/widgets/besli_sayfa/profilim.dart';
import 'package:photo_like_app/widgets/besli_sayfa/resimekle.dart';
import 'package:photo_like_app/widgets/besli_sayfa/resimler.dart';

class Fives extends StatefulWidget {
  Fives({Key? key}) : super(key: key);

  @override
  State<Fives> createState() => _FivesState();
}

class _FivesState extends State<Fives> {
  int _index = 0;
  static const TextStyle _optionstyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetoptions = <Widget>[
    AnaSayfa(),
    Resimler(),
    Resimekle(),
    BegeniYorum(),
    Profilim(),
  ];

  XFile? file;

  void _onItemTapped(int _selectedIndex) {
    setState(() {
      _index = _selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Like'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              if (_index == 4) {
                Navigator.pushReplacementNamed(context, '/signs');
              }
              Navigator.pushNamed(context, '/sohbetler');
            },
            icon: _index == 4 ? Icon(Icons.logout) : Icon(Icons.chat),
            label: Text(''),
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 34, 34, 34)),
          )
        ],
      ),
      body: Center(
        child: _widgetoptions.elementAt(_index),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              label: 'Ana Sayfa',
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.image_outlined,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              label: 'Resimler',
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              label: 'Resim Ekle',
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.comment_outlined,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              label: 'Bildirimler',
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              label: 'Profilim',
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
          ],
          currentIndex: _index,
          selectedItemColor: Color.fromARGB(255, 0, 0, 0),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
