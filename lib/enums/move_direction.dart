enum MoveDirection {
  left,
  right,
  idle;

  bool get isIdle => this == idle;
  bool get isRight => this == right;
  bool get isLeft => this == left;

  int get integerValue => switch (this) {
    left => -1,
    right => 1,
    idle => 0,
  };
}
