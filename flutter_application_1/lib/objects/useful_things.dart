class doublePoint {
  doublePoint({required this.x, required this.y});

  double x;
  double y;

  @override
  String toString() {
    return "($x, $y)";
  }
}