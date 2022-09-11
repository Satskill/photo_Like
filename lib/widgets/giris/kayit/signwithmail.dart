import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';

class SignsMail extends StatefulWidget {
  SignsMail({Key? key}) : super(key: key);
  static var form = 0;

  @override
  State<SignsMail> createState() => _SignsMailState();
}

class _SignsMailState extends State<SignsMail> {
  TextEditingController _mailcont = new TextEditingController();
  TextEditingController _passcont = new TextEditingController();

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
            girisyadakayit(SignsMail.form),
          ],
        ),
      ),
    );
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
              textim(_mailcont, 'E-Posta'),
              textim(_passcont, 'Şifre'),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Data().SignsWithMail(
                          _mailcont.text, _passcont.text, context);
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
              textim(_mailcont, 'E-Posta'),
              textim(_passcont, 'Şifre'),
              textim(_isimcont, 'İsim'),
              textim(_soyisimcont, 'Soyisim'),
              textim(_username, 'Username'),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Data().SignsWithMail(
                          _mailcont.text, _passcont.text, context,
                          isim: _isimcont.text,
                          soyisim: _soyisimcont.text,
                          username: _username.text);
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

  Widget textim(TextEditingController controller, String? label) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              labelText: label,
              suffixIcon: label == 'Şifre'
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(0, 255, 255, 255),
                            elevation: 0),
                        child: Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    )
                  : null),
        ),
      ),
    );
  }
}
