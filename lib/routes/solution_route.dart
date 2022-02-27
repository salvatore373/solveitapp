import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:graphview/GraphView.dart';

import 'package:solveitapp/commons/author_widget.dart';
import 'package:solveitapp/commons/image_app_bar.dart';
import 'package:solveitapp/commons/minimal_widgets.dart';
import 'package:solveitapp/data/solution.dart';
import 'package:solveitapp/res/res.dart';
import 'package:solveitapp/routes/problem/problem_route.dart';

class DevelopmentFlow extends StatelessWidget {
  final List<dynamic> steps;

  late Graph _flow;
  late Map<int, String> _idTextMap;
  late BuchheimWalkerConfiguration _builder;

  int __id = -1;
  int get _id => ++__id;

  DevelopmentFlow({
    Key? key,
    required this.steps,
  })  : assert(steps.isNotEmpty),
        super(key: key) {
    _idTextMap = <int, String>{};

    _builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = 20
      ..levelSeparation = 40
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    _flow = _createGraph(steps);
  }

  Graph _createGraph(List<dynamic> initialList) {
    Graph g = Graph()..isTree = true;

    final n = Node.Id(_id);
    _idTextMap[__id] = initialList[0];
    g.addNode(n);

    Node parentNode = n;
    for (int i = 1; i < initialList.length; i++) {
      final el = initialList[i];

      if (el is String) {
        final n = Node.Id(_id);
        _idTextMap[__id] = el;
        g.addNode(n);
        g.addEdge(parentNode, n);

        parentNode = n;
      } // TODO: add List<support>
    }

    return g;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return GraphView(
      graph: _flow,
      algorithm: BuchheimWalkerAlgorithm(
        _builder,
        TreeEdgeRenderer(_builder),
      ),
      builder: (Node n) {
        final completed = (n.key?.value as int) %2 == 0; // DEBUG

        final contentColor = completed
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface;

        return Container(
          decoration: BoxDecoration(
            color: completed
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(width: 2.0, color: theme.colorScheme.tertiary),
          ),
          padding: DimensConst.minimumOverallPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                completed ? Icons.check_circle_outline : Icons.circle_outlined,
                size: 18.0,
                color: contentColor,
              ),
              Padding(
                padding: DimensConst.minimumLeftPadding,
                child: Text(
                  _idTextMap[n.key!.value as int]!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: contentColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SolutionRoute extends StatefulWidget {
  final String solutionId;

  const SolutionRoute({
    Key? key,
    required this.solutionId,
  }) : super(key: key);

  @override
  _SolutionRouteState createState() => _SolutionRouteState();
}

class _SolutionRouteState extends State<SolutionRoute> {
  static const int maxReviewsNum = 3;

  late Solution _solution;

  int? reviewsListLength;

  @override
  void initState() {
    super.initState();
    retrieveSolution();

    reviewsListLength =
        min(maxReviewsNum, _solution.reviewsId?.length ?? 0) + 1;
  }

  void retrieveSolution() {
    // Retrieve the solution from the server
    final solution = Solution.retrieveSolution(widget.solutionId);

    setState(() {
      _solution = solution;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final openedBy = AuthorWidget(
      topText: AppLocalizations.of(context).proposedBy,
      authorId: _solution.authorId,
    );

    final actionsRow = MinimalDoubleButton(
      firstBtnText: AppLocalizations.of(context).fundIt,
      firstBtnIconPath: "assets/icons/kickstarter-icon.png",
      onTapFirst: () {}, // TODO: complete
      secondBtnText: AppLocalizations.of(context).joinDiscussion,
      secondBtnIconPath: "assets/icons/slack-icon.png",
      onTapSecond: () {}, // TODO: complete
    );

    final description = TitledSection(
      title: AppLocalizations.of(context).description,
      child: Text(
        _solution.description,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.textTheme.caption?.color,
        ),
      ),
    );

    final expandSolCard = MinimalCard(
      mainText: AppLocalizations.of(context).extendSolution,
      subtitle: AppLocalizations.of(context).extendSolutionMsg,
      centeredText: true,
      onTap: () {}, // TODO: complete
    );

    final problemsList = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        1 + (_solution.extendedProblemsId?.length ?? 0),
        (index) {
          String title;
          String probId;
          bool isFirst = false;
          if (index == 0) {
            final origProb = _solution.originalProblem;
            title = origProb.title;
            probId = origProb.id;
            isFirst = true;
          } else {
            final problem = (_solution.extendedProblems?[index - 1])!;
            title = problem.title;
            probId = problem.id;
          }

          return Padding(
            padding: DimensConst.minimumBottomPadding,
            child: MinimalListTile(
              title: title,
              leadingIcon: Icons.arrow_forward_ios_rounded,
              colorWithPrimary: isFirst,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => ProblemRoute(problemId: probId),
                ),
              ),
            ),
          );
        },
      ),
    );
    final problems = TitledSection(
      title: AppLocalizations.of(context).appliedTo,
      child: problemsList,
    );

    final developmentFlow = _solution.developmentFlowSteps?.isNotEmpty == true
        ? TitledSection(
            title: AppLocalizations.of(context).developmentFlow,
            child: Center(
              child: DevelopmentFlow(steps: _solution.developmentFlowSteps!),
            ),
          )
        : Container();

    final reviewsList = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        reviewsListLength!,
        (index) => Padding(
          padding: DimensConst.minimumTopPadding,
          child: index == reviewsListLength! - 1
              ? TextButton(
                  onPressed: () {}, // TODO: send to reviews route
                  child: Text(AppLocalizations.of(context).seeAll),
                )
              : MinimalReviewCard(review: _solution.reviews![index]),
        ),
      )..add(
          ElevatedButton(
            onPressed: () {}, // TODO: send to create_review route
            child: Text(AppLocalizations.of(context).addReview),
          ),
        ),
    );
    final reviews = TitledSection(
      title: AppLocalizations.of(context).reviews,
      child: reviewsList,
    );

    return ImageAppBar(
      title: _solution.title,
      child: ListView(
        padding: DimensConst.routeContentPadding,
        children: [
          openedBy,
          Padding(
            padding: DimensConst.mediumTopPadding,
            child: actionsRow,
          ),
          Padding(
            padding: DimensConst.largeTopPadding,
            child: description,
          ),
          Padding(
            padding: DimensConst.largeTopPadding,
            child: expandSolCard,
          ),
          Padding(
            padding: DimensConst.largeTopPadding,
            child: problems,
          ),
          Padding(
            padding: DimensConst.largeTopPadding,
            child: developmentFlow,
          ),
          Padding(
            padding: DimensConst.largeTopPadding,
            child: reviews,
          ),
        ],
      ),
    );
  }
}
