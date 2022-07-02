import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(home: HomePage()));
}
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
    title: const Text('HomePage'),
    ),
    body: Container(
      child: Column(children: [
        Text("Welecome"),
        ElevatedButton(onPressed: (){}, child: Text("Signout")),
      ]),
    ),
  );
  }
}

