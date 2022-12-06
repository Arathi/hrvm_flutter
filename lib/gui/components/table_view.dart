import 'package:flutter/material.dart';

class TableView extends StatelessWidget {
  List<Widget> items;
  int crossAxisCount;
  Color? backgroundColor;
  Color? frontgroundColorOdd;
  Color? frontgroundColorEven;

  TableView(this.items, this.crossAxisCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
