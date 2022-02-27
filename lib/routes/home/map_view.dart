import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:solveitapp/commons/minimal_widgets.dart';
import 'package:solveitapp/data/theme.dart';
import 'package:solveitapp/databases/graph_database.dart';
import 'package:solveitapp/res/res.dart';
import 'package:solveitapp/routes/problem/problems_list_route.dart';
import 'package:vector_math/vector_math_64.dart' show Quad;
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DescriptorBottomSheet extends StatelessWidget {
  final GraphTheme? themeNode;

  const DescriptorBottomSheet({
    Key? key,
    this.themeNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        color: theme.colorScheme.primary,
      ),
      padding: DimensConst.mediumOverallPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            themeNode?.title ?? AppLocalizations.of(context).selectTheme,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          if (themeNode != null)
            Padding(
              padding: DimensConst.mediumTopPadding,
              child: MinimalDoubleButton(
                firstBtnText: AppLocalizations.of(context).problems,
                secondBtnText: AppLocalizations.of(context).addBranch,
                onTapFirst: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProblemsListRoute(graphTheme: themeNode!),
                    ),
                  );
                },
                onTapSecond: () {
                  // TODO: complete
                },
              ),
            ),
        ],
      ),
    );
  }
}

class GraphNode extends StatelessWidget {
  final String text;
  final GestureTapCallback? onTap;

  const GraphNode({
    Key? key,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final borderRadius = BorderRadius.circular(24.0);
    return Material(
      color: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: DimensConst.largeOverallPadding,
          child: Text(
            text,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Graph? _graph;
  BuchheimWalkerConfiguration? _builder;

  GraphDatabase? _graphDbInstance;
  CustomNode? _selectedNode;

  double _mapHeight = 350.0;

  @override
  void initState() {
    super.initState();
    _graphDbInstance = GraphDatabase.instance;
    _retrieveRoot();

    _builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = 80
      ..levelSeparation = 100
      ..subtreeSeparation = 120
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // No need of setState() because the framework always calls build after
    // a dependency changes
    _mapHeight = MediaQuery.of(context).size.height * 2 / 3;
  }

  Future<void> _retrieveRoot() async {
    final graph = await _graphDbInstance!.getRoots();
    setState(() {
      _graph = graph;
    });
  }

  Future<void> _loadNecessaryNodes(CustomNode node) async {
    // Retrieve the children of this node only if they have not been loaded yet
    if (node.theme != null && !_graph!.hasSuccessor(node)) {
      final childrenGr = await _graphDbInstance!.getChildren(node.theme!.id);
      GraphDatabase.mergeGraphs(_graph!, childrenGr, node);
    }
  }

  Widget _buildNode(Node n) {
    CustomNode node = n as CustomNode;
    final id = node.id.toString();
    return VisibilityDetector(
      key: Key(id),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.8) {
          _loadNecessaryNodes(node);
        }
      },
      child: GraphNode(
        text: node.theme?.title ?? 'root',
        onTap: () {
          _selectedNode = node;
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_graph == null) {
      content = Center(
        child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
      );
    } else {
      content = InteractiveViewer.builder(
            panEnabled: true,
            alignPanAxis: false,
            scaleEnabled: true,
            minScale: 2.5,
            maxScale: 2.5,
            builder: (BuildContext context, Quad viewport) {
              return GraphView(
                graph: _graph!,
                algorithm: BuchheimWalkerAlgorithm(
                  _builder!,
                  TreeEdgeRenderer(_builder!),
                ),
                builder: _buildNode,
              );
            });
    }

    final bottomSheet = DescriptorBottomSheet(
      themeNode: _selectedNode?.theme,
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: content),
        Padding(
          padding: DimensConst.largeTopPadding,
          child: bottomSheet,
        ),
      ],
    );
  }
}
