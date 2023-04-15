class OpponentProperties {

  OpponentProperties(this._x, this._y, this._angle, {this.horizontal=false, required this.dir, required this.angleBias, this.cardOrientation=1});

  final double _x;
  final double _y;
  final double _angle;
  final double dir;
  final double angleBias;
  final double cardOrientation;
  final bool horizontal;

  double getDouble(String value) {
    if (value == 'x') {
      return _x;
    }
    if (value == 'y') {
      return _y;
    }
    if (value == 'angle') {
      return _angle;
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