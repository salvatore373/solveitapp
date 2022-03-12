import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:solveitapp/commons/author_widget.dart';
import 'package:solveitapp/commons/image_app_bar.dart';
import 'package:solveitapp/commons/minimal_widgets.dart';
import 'package:solveitapp/data/problem.dart';
import 'package:solveitapp/data/theme.dart';
import 'package:solveitapp/res/res.dart';
import 'package:solveitapp/routes/solution_route.dart';

class ProblemRoute extends StatefulWidget {
  final String problemId;

  const ProblemRoute({
    Key? key,
    required this.problemId,
  }) : super(key: key);

  @override
  _ProblemRouteState createState() => _ProblemRouteState();
}

class _ProblemRouteState extends State<ProblemRoute> {
  late Problem _problem;

  static const int maxSolutionsNum = 3;

  int? numSolutions;

  @override
  void initState() {
    super.initState();
    retrieveProblem();

    numSolutions = min(maxSolutionsNum, _problem.solutionsId!.length);
  }

  void retrieveProblem() {
    // Retrieve the problem from the server
    final problem = Problem.retrieveProblem(widget.problemId);

    setState(() {
      _problem = problem;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final openedBy = AuthorWidget(
      topText: AppLocalizations.of(context).openedBy,
      authorId: _problem.authorId,
    );

    final description = TitledSection(
      title: AppLocalizations.of(context).description,
      child: Text(
        _problem.description,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.textTheme.caption?.color,
        ),
      ),
    );

    final discussionCard = MinimalCard(
      mainText: AppLocalizations.of(context).joinDiscussion,
      iconPath: "assets/icons/slack-icon.png",
      onTap: () {}, // TODO: send to slack page
    );

    final categories = TitledSection(
      title: AppLocalizations.of(context).categories,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: DimensConst.minimumRightPadding.right,
        runSpacing: 0.0,
        children: List.generate(
          _problem.categoriesId.length,
          (index) => FutureBuilder<MapTheme>(
            future: _problem.categories[index],
            builder: (_, snap) {
              return snap.hasData
                  ? ActionChip(
                      label: Text(snap.data!.title),
                      onPressed: () {
                        // TODO: send to the category
                      },
                    )
                  : Container();
            },
          ),
        ),
      ),
    );

    final expandSolCard = MinimalCard(
      mainText: AppLocalizations.of(context).lookForSolutions,
      subtitle: AppLocalizations.of(context).lookForSolutionsMsg,
      centeredText: true,
      onTap: () {}, // TODO: send to "expand solution" route
    );

    Widget solutionsList;
    if (_problem.solutionsId?.isNotEmpty != true) {
      solutionsList = Center(
        child: Text(
          AppLocalizations.of(context).noSolutionsYet,
          style: theme.textTheme.titleMedium?.copyWith(
              // color: theme.textTheme.caption?.color,
              ),
        ),
      );
    } else {
      solutionsList = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          numSolutions!,
          (index) {
            final solution = (_problem.solutions?[index])!;
            return Padding(
              padding: DimensConst.minimumBottomPadding,
              child: MinimalListTile(
                title: solution.title,
                leadingIcon: Icons.arrow_forward_ios_rounded,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => SolutionRoute(solutionId: solution.id),
                  ),
                ),
              ),
            );
          },
        )..addAll([
            if (_problem.solutionsId!.length > numSolutions!)
              TextButton(
                onPressed: () {}, // TODO: show all the solutions
                child: Text(AppLocalizations.of(context).seeAll),
              ),
            ElevatedButton(
              onPressed: () {}, // TODO: send to solution creator route
              child: Text(AppLocalizations.of(context).proposeSolution),
            ),
          ]),
      );
    }
    final solutions = TitledSection(
      title: AppLocalizations.of(context).solutions,
      child: solutionsList,
    );

    return ImageAppBar(
      title: _problem.title,
      imagesUrl: _problem.imagesLink,
      appBarActions: [
        IconButton(
          onPressed: () {}, // TODO: send to problem editor route
          icon: const Icon(Icons.edit),
          tooltip: AppLocalizations.of(context).editProblemPage,
        ),
      ],
      child: ListView(
        padding: DimensConst.routeContentPadding,
        children: [
          openedBy,
          Padding(
            padding: DimensConst.mediumTopPadding,
            child: description,
          ),
          Padding(
            padding: DimensConst.largeTopPadding,
            child: discussionCard,
          ),
          Padding(
            padding: DimensConst.largeTopPadding,
            child: categories,
          ),
          Padding(
            padding: DimensConst.largeTopPadding,
            child: expandSolCard,
          ),
          Padding(
            padding: DimensConst.largeTopPadding,
            child: solutions,
          ),
        ],
      ),
    );
  }
}
