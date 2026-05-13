import 'dart:math';
  
/////////////////////////////////
// const vs. final & nullable //
////////////////////////////////
  
void demo() {
  // 0 <= rng < 3
  var rng = Random().nextInt(3);
  var nameList = ["Omar", "Ahmad", "Moustafa"];
  
  final String name = nameList[rng]; // final unchangeable at run time. Use when you don't know what it is.
  
  const int age = 25; // const unchangeable at compile time. Use if you know what it is.
  // const const_error = nameList[rng]; throws "Methods can't be invoked in constant"
  
  int? points; // ? will allow the variable to be null until an integer is assigned to it.
  print("name: $name; age: $age; nullable points: $points");

  points = 0;
  print("nullable points after assigning a value: $points");
}