import 'package:flutter/material.dart';

class HeadingTile extends StatelessWidget {
  final String heading;
  const HeadingTile(this.heading);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        heading,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
