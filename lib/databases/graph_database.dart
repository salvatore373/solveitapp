import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:graphview/GraphView.dart';
import 'package:solveitapp/data/theme.dart';
import 'package:solveitapp/routes/home/map_view.dart';

class CustomNode extends Node {
  late int id;
  final GraphTheme? theme;
  CustomNode.Id(this.theme) : super.Id(theme?.id.hashCode ?? 0) {
    id = theme?.id.hashCode ?? 0;
  }
}

class GraphDatabase {
  Map? _graphJsonMap;
  Future<Map> get graphJson async {
    if(_graphJsonMap != null) return _graphJsonMap!;

    final grStr = await rootBundle.loadString("assets/example-data/graph.json");
    _graphJsonMap = (jsonDecode(grStr) as Map)["nodes"];
    return _graphJsonMap!;
  }

  GraphDatabase._();
  static late GraphDatabase instance = GraphDatabase._();

  /*void _attachNodeToList(
      Graph g, List<CustomNode> oldNodes, CustomNode toAttach) {
    for (int i = 0; i < oldNodes.length; i++) {
      final e = oldNodes[i];
      g.addEdge(e, toAttach);
    }
  }*/

  static List<Node> mergeGraphs(
      Graph toKeep, Graph toMerge, CustomNode mergeWith) {
    toKeep.addNodes(toMerge.nodes);
    toKeep.addEdges(toMerge.edges);

    final rootNodes = toMerge.nodes
        .where((Node node) => toMerge.predecessorsOf(node).isEmpty)
        .toList();
    for (int i = 0; i < rootNodes.length; i++) {
      // _attachNodeToList(toKeep, mergeWith, rootNode); version with List<Node> mergeWith
      toKeep.addEdge(mergeWith, rootNodes[i]); // version with Node mergeWith
    }

    return toMerge.nodes
        .where((Node node) => !toMerge.hasSuccessor(node))
        .toList();
  }

  /*List<Node> _createConcurrentLevel(
      Graph g, List<Node> parentNodes, List<String> toAdd) {
    List<Node> added = [];
    for (int i = 0; i < toAdd.length; i++) {
      final n = Node.Id(_id);
      _idTextMap[__id] = toAdd[i];
      g.addNode(n);
      added.add(n);

      _attachNodeToList(g, parentNodes, n);
    }

    return added;
  }*/

  /// Retrieves the nodes without predecessor in the database
  Future<Graph> getRoots() async {
    // TODO: complete with Neo4j data and code
    final g = Graph();
    final root = CustomNode.Id(null);
    g.addNode(root);

    final graph = await graphJson;
    for (String key in graph.keys) {
      if (graph[key]["parentId"] == '') {
        final jsonNode = graph[key];
        final grTh = GraphTheme(
          id: key,
          title: jsonNode["title"],
          databaseId: jsonNode["databaseId"],
        );
        final n = CustomNode.Id(grTh);

        g.addNode(n);
        g.addEdge(root, n);
      }
    }

    return g;
  }

  /// Retrieves all the nodes 1 level below the node associated with [nodeId]
  Future<Graph> getChildren(String nodeId) async {
    // TODO: complete with Neo4j data and code
    final g = Graph();

    final graph = await graphJson;
    for (String key in graph.keys) {
      if (graph[key]["parentId"] == nodeId) {
        final jsonNode = graph[key];
        final grTh = GraphTheme(
          id: key,
          title: jsonNode["title"],
          databaseId: jsonNode["databaseId"],
        );
        final n = CustomNode.Id(grTh);

        g.addNode(n);
      }
    }

    return g;
  }

  /// Retrieves all the nodes 2 levels below the node associated with [nodeId]
  /*Graph getNephews(String nodeId) {
    // TODO: complete with Neo4j data and code

    // DEBUG
    final g = Graph();

    final n1 = CustomNode.Id(_id);
    final n2 = CustomNode.Id(_id);
    final n3 = CustomNode.Id(_id);
    final n4 = CustomNode.Id(_id);
    final n5 = CustomNode.Id(_id);
    final n6 = CustomNode.Id(_id);

    g.addNodes([n1, n2, n3, n4, n5, n6]);
    g.addEdge(n1, n2);
    g.addEdge(n1, n3);
    g.addEdge(n4, n5);
    g.addEdge(n4, n6);

    return g;
  }*/

/*
  /// Returns all the nodes that are maximum [numLevels] below the node
  /// at [nodeId].
  Graph? getLevels(CustomNode node, int numLevels) {
    if (numLevels == 0) {
      return null;
    } else {
      final g = Graph();

      final nodeId = node.key!.value as int;
      final theme = _idNodesMap[nodeId];

      final children = getChildren(theme!);
      for (int i = 0; i < children.length; i++) {
        final child = children[i];
        final n = CustomNode.Id(_id);
        g.addNode(n);
        _idNodesMap[__id] = child;

        final subgraph = getLevels(node, numLevels-1);
        if (subgraph != null) {
          mergeGraphs(g, subgraph, n);
        }
      }

      return g;
    }
  }

  /// Returns all the children nodes of the node associated with the
  /// given [nodeId].
  static List<Theme> getChildren(Theme theme) {
    final List<Theme> res = [];

    if (theme.childrenId != null) {
      for (int i = 0; i < theme.childrenId!.length; i++) {
        res.add(Theme.retrieveTheme(theme.childrenId![i]));
      }
    }

    return res;
  }*/
}
