enum Direction {
  left,
  right;

  int get intValue => switch (this) {
    Direction.left => -1,
    Direction.right => 1,
  };

  bool get isRight => this == Direction.right;
  bool get isLeft => this == Direction.left;

  String get id => switch (this) {
    Direction.left => 'left',
    Direction.right => 'right',
  };

  static Direction fromString(String direction) => switch (direction) {
    'left' => Direction.left,
    'right' => Direction.right,
    _ => throw ArgumentError('Invalid direction string: $direction'),
  };

  Direction get opposite => switch (this) {
    left => right,
    right => left,
  };
}
