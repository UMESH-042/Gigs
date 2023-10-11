// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppreciationScreen extends StatefulWidget {
  final String userEmail;
  const AppreciationScreen({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<AppreciationScreen> createState() => _AppreciationScreenState();
}

class _AppreciationScreenState extends State<AppreciationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.userEmail),
      ),
    );
  }
}
