class BoxPosition {
  final double x;
  final double y;
  final double width;
  final double height;

  BoxPosition(this.x, this.y, this.width, this.height);
}

class FixedBorders {
  final double left;
  final double right;
  final double up;
  final double down;

  FixedBorders({
    required this.left,
    required this.right,
    required this.up,
    required this.down,
  });
}
