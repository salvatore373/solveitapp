import 'dart:async';

/// A list-like class that initializes its [T] elements only when they are
/// requested via the [] operator
class LazyList<T> {
  /// The IDs of the [T] objects at the corresponding index, that will be
  /// passed to [retrieverFunction].
  List<String> listIds;
  /// The lazy list containing the [T] objects when they have already
  /// been retrieved, or null when they have not been retrieved yet.
  late List<T?> _list;

  /// A function that takes in an ID and returns the [T] objects associated
  /// with that ID.
  T Function(String) retrieverFunction;

  LazyList({
    required this.listIds,
    required this.retrieverFunction,
  }) {
    _list = List.generate(listIds.length, (index) => null);
  }

  T operator [](int i) {
    _list[i] ??= retrieverFunction(listIds[i]);

    return _list[i]!;
  }
}
