class User {
  final String id;
  final String firstName;
  final String lastName;

  final List<String>? problemsIds;
  final List<String>? solutionsIds;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.problemsIds,
    this.solutionsIds,
  });

  static User retrieveUser(String id) {
    // TODO: retrieve user from the server
    return User(
      id: "00000",
      firstName: "Salvatore",
      lastName: "Rago",
      problemsIds: ["0000"],
      solutionsIds: ["0000"],
    );
  }
}
