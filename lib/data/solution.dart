import 'package:solveitapp/data/lazy_list.dart';
import 'package:solveitapp/data/problem.dart';
import 'package:solveitapp/data/review.dart';

class Solution {
  final String id;
  final String authorId;

  String title;
  String description;

  final String originalProblemId;
  List<String>? extendedProblemsId;

  // The type of the elements can be only String (if the item represents a
  // step), or List<String> (if the item represents multiple concurrent steps.
  List<dynamic>? developmentFlowSteps;

  String? kickstarterLink;
  String? discussionLink;

  List<String>? reviewsId;

  late Problem originalProblem = Problem.retrieveProblem(originalProblemId);
  late LazyList<Problem>? extendedProblems;

  late LazyList<Review>? reviews;

  Solution({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.originalProblemId,
    this.developmentFlowSteps,
    this.extendedProblemsId,
    this.kickstarterLink,
    this.discussionLink,
    this.reviewsId,
  }) {
    if (extendedProblemsId?.isNotEmpty == true) {
      extendedProblems = LazyList(
        listIds: extendedProblemsId!,
        retrieverFunction: Problem.retrieveProblem,
      );
    }

    if (reviewsId?.isNotEmpty == true) {
      reviews = LazyList(
        listIds: reviewsId!,
        retrieverFunction: Review.retrieveReview,
      );
    }
  }

  static Solution retrieveSolution(String id) {
    // TODO: retrieve the Solution from the server
    return Solution(
      id: "00000",
      title: "Solution Name",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec gravida porta ullamcorper. Maecenas in ante sed magna tristique auctor at maximus orci. Aenean neque nibh, congue eget facilisis sed, interdum id mi.",
      originalProblemId: "00000",
      authorId: "0000",
      extendedProblemsId: ["000", "000", "000"],
      reviewsId: ["000", "000", "000", "000", "000", "000", "000"],
      developmentFlowSteps: [
        "step1",
        ["step2", "step3"],
        "step4",
      ],
    );
  }
}
