import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/giris/kayit/signwithmail.dart';

import '../../../database/database.dart';

class signwid extends StatefulWidget {
  final index;
  signwid({required this.index, Key? key}) : super(key: key);

  @override
  State<signwid> createState() => _signwidState();
}

class _signwidState extends State<signwid> {
  @override
  Widget build(BuildContext context) {
    return girisyadakayit(widget.index);
  }

  Widget girisyadakayit(index) {
    TextEditingController _mailcont = new TextEditingController();
    TextEditingController _passcont = new TextEditingController();
    TextEditingController _isimcont = new TextEditingController();
    TextEditingController _soyisimcont = new TextEditingController();
    TextEditingController _username = new TextEditingController();
    List<String> following = [];
    if (index == 0) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              textim(SignsMail.mailcont, 'E-Posta', false),
              textim(SignsMail.passcont, 'Şifre', SignsMail.obse),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Data().SignsWithMail(SignsMail.mailcont.text,
                          SignsMail.passcont.text, context);
                    },
                    child: Center(
                      child: Text('Giriş Yap'),
                    ),
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              textim(SignsMail.mailcont, 'E-Posta', false),
              textim(SignsMail.passcont, 'Şifre', SignsMail.obse),
              textim(SignsMail.isimcont, 'İsim', false),
              textim(SignsMail.soyisimcont, 'Soyisim', false),
              textim(SignsMail.username, 'Username', false),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Data().SignsWithMail(SignsMail.mailcont.text,
                          SignsMail.passcont.text, context,
                          isim: SignsMail.isimcont.text,
                          soyisim: SignsMail.soyisimcont.text,
                          username: SignsMail.username.text);
                    },
                    child: Center(
                      child: Text('Kayıt Ol'),
                    ),
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget textim(TextEditingController controller, String? label, bool obse) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: controller,
          obscureText: obse,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              labelText: label,
              suffixIcon: label == 'Şifre'
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        child: Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        ),
                        onTap: () {
                          SignsMail.obse = !obse;
                          setState(() {});
                        },
                      ),
                    )
                  : null),
        ),
      ),
    );
  }
}
