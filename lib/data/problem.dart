import 'dart:core';

import 'package:solveitapp/data/author.dart';
import 'package:solveitapp/data/lazy_list.dart';
import 'package:solveitapp/data/solution.dart';
import 'package:solveitapp/data/theme.dart';

class Problem {
  final String id;
  String title;
  String description;
  String authorId;
  List<String> categoriesId;
  List<String>? imagesLink;
  List<String>? solutionsId;

  late Author author = Author.retrieveAuthor(authorId);

  // Lazy initialization of the categories and solutions
  late LazyList<Future<MapTheme>> categories;
  late LazyList<Solution>? solutions;

  Problem({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.categoriesId,
    this.imagesLink,
    this.solutionsId,
  }) {
    categories = LazyList(
      listIds: categoriesId,
      retrieverFunction: MapTheme.retrieveTheme,
    );

    if (solutionsId != null) {
      solutions = LazyList(
        listIds: solutionsId!,
        retrieverFunction: Solution.retrieveSolution,
      );
    }
  }

  static Problem retrieveProblem(String id) {
    // TODO: retrieve the Problem from the server
    return Problem(
      id: "00000",
      title: "Problem Name",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec gravida porta ullamcorper. Maecenas in ante sed magna tristique auctor at maximus orci. Aenean neque nibh, congue eget facilisis sed, interdum id mi.",
      authorId: "00000",
      categoriesId: ["00000", "00000", "00000", "00000"],
      solutionsId: ["00000", "00000", "00000", "00000"],
    );
  }
}
