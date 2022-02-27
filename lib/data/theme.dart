import 'package:solveitapp/data/lazy_list.dart';
import 'package:solveitapp/data/problem.dart';
import 'package:solveitapp/databases/graph_database.dart';
import 'package:solveitapp/databases/tables_database.dart';

class MapTheme {
  final String id;
  String title;
  String? description;
  List<String>? problemsIds;

  late LazyList<Problem>? problems;

  // TODO: This fields can be removed if they are not returned by the server
  // that stores the graph, when the category is retrieved
  // final String parentId;
  // List<String>? childrenId;

  MapTheme({
    required this.id,
    required this.title,
    this.description,
    this.problemsIds,
    // required this.parentId,
    // this.childrenId,
  }) {
    if (problemsIds != null) {
      problems = LazyList(
        listIds: problemsIds!,
        retrieverFunction: Problem.retrieveProblem,
      );
    }
  }

  static Future<MapTheme> retrieveTheme(String id) async {
    // TODO: retrieve the theme from the server
    final node = (await TablesDatabase.instance.themesJson)[id];
    return MapTheme(
      id: id,
      title: node["title"],
      description: node["description"],
      problemsIds: node["problemsIds"] == null ? null : List<String>.from(node["problemsIds"]),
    );
  }
}

class GraphTheme {
  /// The ID of this theme/node in the graph db
  final String id;

  /// The title of this theme
  final String title;

  /// The ID of this theme in the databased that stores all the Themes' data
  final String databaseId;

  GraphTheme({
    required this.id,
    required this.title,
    required this.databaseId,
  });

  static Future<GraphTheme> retrieveGraphTheme(String id) async {
    // TODO: retrieve the theme node from the server
    final node = (await GraphDatabase.instance.graphJson)[id];
    return GraphTheme(
      id: id,
      title: node["title"],
      databaseId: node["databaseId"],
    );
  }
}
