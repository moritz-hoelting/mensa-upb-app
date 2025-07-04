import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:provider/provider.dart';

class DateSelectionBottomBar extends StatelessWidget {
  const DateSelectionBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60.0,
      child: Consumer<UserSelectionModel>(
        builder: (context, userSelection, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              tooltip: AppLocalizations.of(context)!.previousDayTooltip,
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                DateTime previousDay = DateUtils.dateOnly(userSelection
                    .selectedDay
                    .subtract(const Duration(days: 1)));
                if (previousDay.isBefore(DateUtils.dateOnly(DateTime.now()))) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context)!.previousDayErrorMessage)));
                } else {
                  userSelection.selectedDay = previousDay;
                }
              },
            ),
            InkWell(
              onTap: () => userSelection.selectedDay =
                  DateUtils.dateOnly(DateTime.now()),
              child: Padding(
                  padding: const EdgeInsetsGeometry.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                  child: Text(DateFormat('dd.MM.yyyy')
                      .format(userSelection.selectedDay))),
            ),
            IconButton(
              tooltip: AppLocalizations.of(context)!.nextDayTooltip,
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                DateTime limit = DateUtils.dateOnly(DateTime.now())
                    .add(const Duration(days: 7));
                DateTime nextDay = DateUtils.dateOnly(
                    userSelection.selectedDay.add(const Duration(days: 1)));
                if (nextDay.isAfter(limit)) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context)!.nextDayErrorMessage)));
                } else {
                  userSelection.selectedDay = nextDay;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
