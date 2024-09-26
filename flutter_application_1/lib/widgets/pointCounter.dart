import 'dart:async';

class PointCounter {
  int points = 0;
  Timer? time;

  void start() {
    time = Timer.periodic(Duration(seconds: 1), (timer) {
      points++;
    });
  }

  void stop() {
    time?.cancel();
  }

  void reset() {
    points = 0;
  }

  int getPoints() {
    return points;
  }
}
