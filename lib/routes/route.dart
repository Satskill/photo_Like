import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_like_app/widgets/anasayfa_widgets/hikayeekrani.dart';
import 'package:photo_like_app/widgets/fivepages.dart';
import 'package:photo_like_app/widgets/listeleme/kisiler.dart';
import 'package:photo_like_app/widgets/profilgoruntule/profilgoruntule.dart';
import 'package:photo_like_app/widgets/listeleme/yorumlar.dart';
import 'package:photo_like_app/widgets/sohbet/sohbetgoruntule.dart';

import '../widgets/resimgoruntule.dart';
import '../widgets/sohbet/sohbetler.dart';

class Routes {
  static Route<dynamic>? _routes(Widget widget, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return MaterialPageRoute(
        builder: (context) => widget,
        settings: settings,
      );
    } else {
      return CupertinoPageRoute(
        builder: (context) => widget,
        settings: settings,
      );
    }
  }

  static Route<dynamic>? route(RouteSettings settings) {
    switch (settings.name) {
      case '/fives':
        return _routes(Fives(), settings);
      case '/yorumlar':
        Map image = settings.arguments as Map;
        return _routes(
            yorumlar(
              image: image,
            ),
            settings);
      case '/profil':
        String user = settings.arguments as String;
        return _routes(profil(user: user), settings);
      case '/kisiler':
        Map bilgiler = settings.arguments as Map;
        List<dynamic> olesine = [];
        Map olesinemap = {};
        return _routes(
            kisiler(
                kisilerresimler: bilgiler['bilgiler'] ?? olesine,
                tur: bilgiler['tur'],
                bilgiler: bilgiler),
            settings);
      case '/goruntuleme':
        final bilgiler = settings.arguments;
        print('route bilgisi');
        print(bilgiler.toString());
        return _routes(goruntuleme(resimbilgisi: bilgiler), settings);
      case '/sohbetler':
        return _routes(sohbetler(), settings);
      case '/sohbetgoruntule':
        final bilgi = settings.arguments;
        return _routes(sohbetgoruntule(sohbetuser: bilgi), settings);
      case '/hikayeekrani':
        final index = settings.arguments;
        return _routes(hikayeekrani(index: index), settings);
    }
  }
}
