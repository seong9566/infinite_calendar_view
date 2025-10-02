import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.columIndex,
  });

  final int columIndex;

  @override
  Widget build(BuildContext context) {
    var name = switch (columIndex) {
      0 => 'Suzy',
      1 => 'Jose',
      2 => 'Michelle',
      3 => 'John',
      4 => 'Blaise',
      5 => 'Jane',
      6 => 'Alfred',
      int() => '',
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RandomAvatar(name, height: 40, width: 40),
        Text(name, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
