import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:solveitapp/data/solution.dart';
import 'package:solveitapp/res/res.dart';
import 'package:solveitapp/routes/home/home_route.dart';
import 'package:solveitapp/routes/problem/problem_route.dart';
import 'package:solveitapp/routes/solution_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DesignConst.appTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeRoute(),
    );
  }
}
