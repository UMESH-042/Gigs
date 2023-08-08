import 'package:flutter/material.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect to the Network"),
      ),
      body: Container(
        child: Center(
          child: Text("Umesh"),
        ),
      ),
    );
  }
}
