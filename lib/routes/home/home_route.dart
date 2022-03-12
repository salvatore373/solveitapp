import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:solveitapp/res/res.dart';
import 'package:solveitapp/routes/home/map_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    final searchBar = FloatingSearchBar(
      hint: AppLocalizations.of(context).searchBarHint,
      builder: (BuildContext context, Animation<double> transition) {
        return const Text("Feature to be implemented"); // TODO:
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).problemsMap),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 48.0 + 12.0),
            child: MapView(),
          ),
          searchBar,
        ],
      ),
    );
  }
}
