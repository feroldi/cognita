import 'package:flutter/material.dart';

class NewCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final frontAndBack = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Frente',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 24.0,
          ),
        ),
        DashDivider(),
        Text(
          'Trás',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 24.0,
          ),
        ),
      ],
    );

    final scaffold = Scaffold(
      appBar: AppBar(
        title: const Text('Nova carta'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          ),
        ],
      ),
      body: frontAndBack,
    );

    return scaffold;
  }
}

class DashDivider extends StatelessWidget {
  final double height;
  final Color color;

  const DashDivider({this.height = 1, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
