import 'dart:math';

int calculate() {
  return 6 * 7;
  }

String name() {
  // 0 <= rng < 3
  var rng = Random().nextInt(3);
  var nameList = ["Omar", "Ahmad", "Moustafa"];
  return nameList[rng];
}
