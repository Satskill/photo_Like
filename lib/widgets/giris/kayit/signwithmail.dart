import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';
import 'package:photo_like_app/widgets/giris/kayit/signwidget.dart';

class SignsMail extends StatefulWidget {
  SignsMail({Key? key}) : super(key: key);
  static var form = 0;
  static TextEditingController mailcont = new TextEditingController();
  static TextEditingController passcont = new TextEditingController();
  static TextEditingController isimcont = new TextEditingController();
  static TextEditingController soyisimcont = new TextEditingController();
  static TextEditingController username = new TextEditingController();
  static bool obse = true;

  @override
  State<SignsMail> createState() => _SignsMailState();
}

class _SignsMailState extends State<SignsMail> {
  TextEditingController mailcont = new TextEditingController();
  TextEditingController passcont = new TextEditingController();
  TextEditingController isimcont = new TextEditingController();
  TextEditingController soyisimcont = new TextEditingController();
  TextEditingController username = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Photo Like Sign In/Up')),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(120, 0, 120, 0),
              child: AnimatedToggleSwitch<int>.dual(
                current: SignsMail.form,
                first: 0,
                second: 1,
                onChanged: (i) => setState(() => SignsMail.form = i),
                borderColor: SignsMail.form.isEven
                    ? Colors.grey
                    : Color.fromARGB(255, 94, 125, 172),
                colorBuilder: (i) =>
                    i.isEven ? Colors.grey : Color.fromARGB(255, 94, 125, 172),
                textBuilder: (i) => i.isEven
                    ? Center(
                        child: Text('Giriş Yap'),
                      )
                    : Center(
                        child: Text('Kayıt Ol'),
                      ),
              ),
            ),
            signwid(index: SignsMail.form),
          ],
        ),
      ),
    );
  }
}
