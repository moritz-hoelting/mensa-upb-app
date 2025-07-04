import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class OrientationList extends StatelessWidget {
  final List<Widget> children;
  final double rowGap;
  final double columnGap;

  const OrientationList({
    super.key,
    required this.children,
    this.rowGap = 0.0,
    this.columnGap = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: OrientationBuilder(
        builder: (context, _) {
          final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
          final columns = isLandscape ? 2 : 1;
          return LayoutGrid(
            rowGap: rowGap,
            columnGap: columnGap,
            columnSizes: List.generate(columns, (_) => 1.fr),
            rowSizes: List.generate(
              (children.length / columns).ceil(),
              (_) => auto,
            ),
            children: children,
          );
        },
      ),
    );
  }
}
