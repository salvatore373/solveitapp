import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:solveitapp/commons/minimal_widgets.dart';
import 'package:solveitapp/data/theme.dart';
import 'package:solveitapp/res/res.dart';
import 'package:solveitapp/routes/problem/problem_route.dart';

class ProblemsListRoute extends StatefulWidget {
  final GraphTheme graphTheme;

  const ProblemsListRoute({
    Key? key,
    required this.graphTheme,
  }) : super(key: key);

  @override
  State<ProblemsListRoute> createState() => _ProblemsListRouteState();
}

class _ProblemsListRouteState extends State<ProblemsListRoute> {
  MapTheme? _mapTheme;

  @override
  void initState() {
    super.initState();
    _retrieveTheme();
  }

  Future<void> _retrieveTheme() async {
    final t = await MapTheme.retrieveTheme(widget.graphTheme.databaseId);
    setState(() {
      _mapTheme = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Widget content;

    if (_mapTheme == null) {
      content = Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    } else {
      if (_mapTheme?.problemsIds?.isNotEmpty == true) {
        content = Container(
          padding: DimensConst.mediumOverallPadding,
          child: ListView.builder(
            itemCount: _mapTheme!.problemsIds!.length,
            itemBuilder: (context, index) {
              final p = _mapTheme!.problems![index];
              return MinimalListTile(
                title: p.title,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProblemRoute(problemId: p.id),
                    ),
                  );
                },
              );
            },
          ),
        );
      } else {
        content = Center(
          child: Text(AppLocalizations.of(context).noProblemsMsg),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).problemsOf +
            ' ${_mapTheme?.title ?? ''}'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: send to problem creator route
            },
            icon: const Icon(Icons.add),
            tooltip: AppLocalizations.of(context).createNewProblem,
          ),
        ],
      ),
      body: content,
    );
  }
}
