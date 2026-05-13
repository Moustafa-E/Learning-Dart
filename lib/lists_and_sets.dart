void addAndRemove({List? list, Set? set}) {
  // parameters optional (nullable). add() will conditionally activate.

  var object;

  /* function expects one argument. Operate on whichever it is without
    repeating code */
  if (list != null) {
    object = list;
  } else if (set != null) {
    object = set;
  }

  print("${object.runtimeType} Received. \n Before Change: $object");

  try {
    object.add("string");
    object.add(100);
    object.remove(70);
  } catch (error) {
    print(" $error");
  }
  
  print(" After change: $object\n");
}
