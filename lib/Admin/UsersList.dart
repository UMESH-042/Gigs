// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
 final String currentUserEmail;
  const UserListPage({
    Key? key,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
