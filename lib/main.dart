import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/database/database.dart';
import 'package:photo_like_app/firebase_options.dart';
import 'package:photo_like_app/routes/route.dart';
import 'package:photo_like_app/widgets/fivepages.dart';
import 'package:photo_like_app/widgets/giris/kayit/signwithmail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    Data().auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignsMail(),
      onGenerateRoute: Routes.route,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          color: Color.fromARGB(255, 41, 52, 98),
        ),
      ),
    );
  }
}
