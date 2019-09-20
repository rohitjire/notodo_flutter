import 'package:flutter/material.dart';
import 'package:notodo/ui/notodoscreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("No To Do"),
        backgroundColor: Colors.black54,
        centerTitle: true,
      ),
      body: new NoToDoScreen(),
    );
  }
}
