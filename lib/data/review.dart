class Review {
  final String userId;
  String title; // TODO: limit text to 180 chars
  String text;
  int stars;

  Review({
    required this.userId,
    required this.title,
    required this.text,
    required this.stars,
  });

  static Review retrieveReview(String id) {
    // TODO: retrieve review from the server

    return Review(
      userId: "userId",
      title: "Review Title",
      text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec gravida porta ullamcorper. Maecenas in ante sed magna tristique auctor at maximus orci. Aenean neque nibh, congue.",
      stars: 3,
    );
  }
}
