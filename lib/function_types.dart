library;
  ////////////////////
  // Function Types //
  ////////////////////  
  // You can type the return value in the definition + the parameters. 
  // Leaving these untyped will work too
  String greet({String? name, required int age}) {
    // nullable arguments are optional.
    // Surrounding paramters with {} will make them named.
    return "hi $name, you are $age years old";
  }

  void sayGreeting(){
    String greeting = greet(age: 24, name: "Omar"); // Dart will expect a string. If greet wasn't typed in the def, it would expect a dynamic type instead.
    print(greeting);
  }

