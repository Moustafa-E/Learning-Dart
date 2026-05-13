import 'package:dart_application_1/default.dart' as default_lib;
import 'package:dart_application_1/const_final_nullable.dart' as const_final_nullable;
import 'package:dart_application_1/function_types.dart' as function_types;
import 'package:dart_application_1/lists_and_sets.dart' as lists_and_sets;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main(List<String> arguments) async {
  //////////////////////////////////////////////////
  print('Hello world: ${default_lib.calculate()}!');

  //////////////////////////////////////////////////////
  print("\n/// Constants, Finals (???) & Nullables///");
  const_final_nullable.demo();

  /////////////////////////////////////
  print("\n/// functions & types ///");
  function_types.sayGreeting();

  ////////////////////////////////
  print("\n/// Lists & Sets ///"); 
  var objectList = [50, 70, 70, "string"]; // AKA List<Object> objectList. Can add types that match these later.
  lists_and_sets.addAndRemove(list: objectList);

  var objectSet = {50, 70, "string"};  // Sets don't allow duplicate values. Anything "added" won't be stored.
  lists_and_sets.addAndRemove(set: objectSet);

  List<String> stringList = ["one", "two"]; // Won't allow other types in.
  lists_and_sets.addAndRemove(list: stringList);

  ///////////////////////////////////
  print("\n/// Loops and flows ///");
  ///////////////////////////////////
  var N = stringList.length;
  for (int i = 0; i < (N * 2); i++) {
    print(stringList[i % N]);
  }
  for (var e in objectSet.where((item) => item.runtimeType == int)) { 
    // iterator must match the elements here even if you filter first. Set treated as dynamic.
    print(e);
  }
  ////////////////////////
  print("\n/// Maps ///");
  ////////////////////////
  // Maps (dictionaries) also use {}. Use Key Value pairs inside to mean "map".
  var emptyMap = {}; // this will default to the map unless defined otherwise.
  Set<Object> emptySet = {};

  Map<int, String> numberMap = {
    // can specify the type of the key, value separately. Inferred otherwise. 
    1: "one",
    2: "two"
  };

  var second = numberMap[2]; // prints "two".
  // ^ Should be nullable incase we access non-existant key to assign a new entry:
  
  numberMap[3] = "three"; // >> {1: one, 2: two, 3: three}
  numberMap.containsKey(3); // >> true
  
  numberMap.remove(2);
  numberMap.containsKey(2); // false

  ///////////////////////////
  print("\n/// Classes ///");
  ///////////////////////////
  // Define these outside of methods (including main)
  var heavyCube = Cube("tungsten", 10); 
  // print(heavyCube); // >> Instance of 'Cube'. toString() is invoked under the hood. Override it if you want it changed.
  [heavyCube.material, heavyCube.length];  // >> [tungsten, 10.0]
  heavyCube.describeCube(); // >> Material is tungsten & length is 10.0
  heavyCube.doSomething(); // >> hi :)

  var rubiksCube = CubicObject("puzzle", "plastic", 6.0);
  rubiksCube; // >> returns output of rubiksCube.doSomething() because the 'toString()' is overriden.
  rubiksCube.describeCube(); // >> Material is plastic & length is 6.0
  rubiksCube.doSomething(); // >> hi I'm a cubic object of type 'puzzle' made of plastic :)
  
  ////////////////////////////
  print("\n/// Generics ///");
  ////////////////////////////
  var die = CubicObject("toy", "plastic", 1.5);
  var cubes = GenericCollection<CubicObject>(
    "A collection of CubicObjects", 
    [rubiksCube, die]
  );
  cubes.randomItem(); // >> 50/50 will be a "toy" or a "puzzle" since this method returns the "type" field of the collection item. 

  /////////////////////////////////////////////////
  // Async, Await & Futures, Anonymous Functions //
  /////////////////////////////////////////////////
  
  Future<PostRequest> fakeFetchPost() {
    // type "Future" represents the result of an asynchronous action. It's a generic class so remember to pass in the type expected by the async action.
    // I'll use this to simulate a delay you'd get when performing a network request
    const delay = Duration(seconds: 2);
    return Future.delayed(delay, () => PostRequest('fake post', 1));
    // Note: in dart anonymous functions are either written as ( 'parameters' ) => 'thing to return' or ( 'parameters' ) { 'function body with return' }. 
    // () => {} would return an empty map. Stay away from it. It's saying:
    // () {
    //   return {}
    // }
    // Confusing because () => {} is how you write anonymous functions in javascript.
  }

  // // the '.then' takes in a callback function that will fire when the future is fulfilled. This is the same as "promise" in JS.
  // fakeFetchPost().then((value) => print([".then result:", value.title, value.userId])); // >> [fake post, 1] returned after 2 seconds. 
  // // This runs in the background and immediately moves on to the next line. 
  // print("line after .then"); // >> Appears before the result

  final post = await fakeFetchPost(); // await can only be used in a function that is marked 'async' so I've marked main.
  // // without 'awaiting', 'post' will be assigned to Future<PostRequest>. We want it to be assigned to the PostRequest that is returned from the Future (or promise).
  // // so, we wait before assigning.
  // // This one isn't happening in the background. Whole program will wait here.
  print(["await result:", post.title, post.userId]);
  print("Line after await"); // >> appears after the result.
  // /// IMPORTANT: If you want await to actually be asynchronous, just define it in its own async function. Try to avoid using .then but it's there if you need
  
  ///////////////////////////////////////
  // Fetching Data & External Packages //
  ///////////////////////////////////////
  
  // if developing locally, you'll need to install external packages before importing them. 
  // Visit pub.dev to learn how to install, import and use them. We'll use the http package to call an endpoint from jsonplaceholder for this next part
  Map<String, String> fullPath = {
    "domain": 'jsonplaceholder.typicode.com', 
    "path": '/posts/1'
  }; // Uri.https takes in the domain name and path separately. 

  Future<PostRequest> fetchPost() async {
    var url = Uri.https(fullPath["domain"]!, fullPath["path"]!);
    // the '!' tells dart we're sure they exist in the map. 
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json'
      } // this second argument isn't needed in the browser but is locally. Something about the default headers being sent back being different for VM (local) and browser (dartpad)
    );
    
    // the response is a json right now. We can't operate on it easily unless it's a map, so we'll use a core library to convert it:
    Map<String, dynamic> data = convert.jsonDecode(response.body);
    return PostRequest(data["title"], data["userId"]);
    // ^ we can do this because the json object returned happens to contain both of these fields, which we've defined in the class below. 
  }
  
  PostRequest response = await fetchPost();
  print(["title: ${response.title}", "userId: ${response.userId}"]);
}


/// Classes ///
// a way to define a blueprint for an object instantiated during run/compile time. 
class Cube {

  String material;
  double length;

  Cube(this.material, this.length);
  // The constructor. A method that auto-runs when the class is invoked for instantiation.
  // Assigns parameters passed in during instantiation to the fields of the class. 

  String describeCube() {
    return "Material is $material & length is $length";
  }
  String doSomething() {
    return "hi :)";
  }
}

class CubicObject extends Cube {
  String type;
  CubicObject(this.type, super.material, super.length); // need to invoke the parent constructor's parameters in this one. 
  // Long hand of this is (String material, double length): super(material, length).

  @override // use this annotation to change the behaviour of a function in the parent class. 
  String doSomething() {
    return "hi I'm a cubic object of type '$type' made of $material :)";
  }

  @override
  String toString() {
    return type;
  }

}

/// Generics ///
// Classes that work with lots of different types. You could make these by not defining the type, but then you wouldn't get great code hints. 
class GenericCollection<T> {
  // <T> is a type passed into the class at instantiation.
  String name;
  List<T> data;

  GenericCollection(this.name, this.data);
  T randomItem() {
    data.shuffle();
    return data[0];
  }
}

class PostRequest {
  String title;
  int userId;

  PostRequest(this.title, this.userId);
}

