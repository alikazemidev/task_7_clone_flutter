void main() async {
  final Stream<int> stream = numberCreator();
  // stream.listen((event) {
  //   print(event);
  // });
  await for (final event in stream) {
    print(event); 
  }
}

Stream<int> numberCreator() async* {
  int value = 1;
  while (true) {
    yield value++;
    await Future.delayed(Duration(seconds: 1));
  }
}
