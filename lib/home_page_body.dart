import 'package:flutter/material.dart';
import 'package:mensa_upb/menu_list.dart';

class HomePageBody extends StatelessWidget {
  final TabController tabController;
  final int indexOffset;

  const HomePageBody(
      {super.key, required this.tabController, required this.indexOffset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TabBarView(
        controller: tabController,
        children: List.generate(
          tabController.length,
          (index) => MenuList(
              date: DateUtils.dateOnly(DateTime.now())
                  .add(Duration(days: index - indexOffset))),
        ),
      ),
    );
  }
}
