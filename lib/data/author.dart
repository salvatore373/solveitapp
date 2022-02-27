class Author {
  String id;
  String name;
  String? imageLink;

  Author({
    required this.id,
    required this.name,
    this.imageLink,
  });

  static Author retrieveAuthor(String authorId) {
    // TODO: retrieve this author from the server

    // DEBUG return a fake author
    return Author(
      id: "00000",
      name: "Salvatore Michele Rago",
    );
  }
}
