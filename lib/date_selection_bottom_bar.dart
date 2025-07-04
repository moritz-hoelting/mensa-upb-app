import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:provider/provider.dart';

class DateSelectionBottomBar extends StatefulWidget {
  const DateSelectionBottomBar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DateSelectionBottomBarState();
  }
}

class _DateSelectionBottomBarState extends State<DateSelectionBottomBar> {
  bool previousDayEnabled = false;
  bool nextDayEnabled = true;

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
              onPressed: previousDayEnabled
                  ? () {
                      DateTime previousDay = DateUtils.dateOnly(userSelection
                          .selectedDay
                          .subtract(const Duration(days: 1)));
                      nextDayEnabled = true;
                      if (previousDay.isBefore(
                          DateUtils.dateOnly(DateTime.now())
                              .add(const Duration(seconds: 1)))) {
                        previousDayEnabled = false;
                      }

                      userSelection.selectedDay = previousDay;
                    }
                  : null,
            ),
            InkWell(
              onLongPress: () {
                previousDayEnabled = false;
                nextDayEnabled = true;
                userSelection.selectedDay = DateUtils.dateOnly(DateTime.now());
              },
              child: Padding(
                  padding: const EdgeInsetsGeometry.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                  child: Text(DateFormat('dd.MM.yyyy')
                      .format(userSelection.selectedDay))),
            ),
            IconButton(
              tooltip: AppLocalizations.of(context)!.nextDayTooltip,
              icon: const Icon(Icons.chevron_right),
              onPressed: nextDayEnabled
                  ? () {
                      DateTime nextDay = DateUtils.dateOnly(userSelection
                          .selectedDay
                          .add(const Duration(days: 1)));
                      previousDayEnabled = true;
                      if (nextDay.isAfter(
                          DateUtils.dateOnly(DateTime.now())
                              .add(const Duration(days: 7, seconds: -1)))) {
                        nextDayEnabled = false;
                      }
                      userSelection.selectedDay = nextDay;
                    }
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
