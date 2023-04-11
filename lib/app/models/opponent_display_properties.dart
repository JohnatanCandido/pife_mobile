class OpponentProperties {

  OpponentProperties({required this.x, required this.y, required this.angle, this.horizontal=false, required this.dir, required this.angleBias, this.cardOrientation=1});

  double x;
  double y;
  double dir;
  double angle;
  double angleBias;
  double cardOrientation;
  final bool horizontal;

  double getDouble(String value) {
    if (value == 'x') {
      return x;
    }
    if (value == 'y') {
      return y;
    }
    if (value == 'angle') {
      return angle;
    }
    if (value == 'dir') {
      return dir;
    }
    if (value == 'angleBias') {
      return angleBias;
    }
    if (value == 'orientation') {
      return cardOrientation;
    }
    return 0;
  }
}