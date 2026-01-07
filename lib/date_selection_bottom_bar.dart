import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:provider/provider.dart';

class DateSelectionBottomBar extends StatefulWidget {
  final TabController tabController;
  final DateTime firstDate;

  const DateSelectionBottomBar(
      {super.key, required this.tabController, required this.firstDate});

  @override
  State<StatefulWidget> createState() {
    return _DateSelectionBottomBarState();
  }
}

class _DateSelectionBottomBarState extends State<DateSelectionBottomBar> {
  bool _selectDate(DateTime date, UserSelectionModel userSelection) {
    DateTime onlyDate = DateUtils.dateOnly(date);
    DateTime limitFuture =
        DateUtils.dateOnly(DateTime.now().add(const Duration(days: 14)));
    if (onlyDate.isBefore(limitFuture.add(const Duration(seconds: 1))) &&
        onlyDate
            .isAfter(widget.firstDate.subtract(const Duration(seconds: 1)))) {
      userSelection.selectedDay = onlyDate;
    } else {
      return false;
    }
    return true;
  }

  bool get _previousDayEnabled {
    final userSelection =
        Provider.of<UserSelectionModel>(context, listen: false);
    DateTime onlyDate = DateUtils.dateOnly(userSelection.selectedDay);
    return !onlyDate.isAtSameMomentAs(widget.firstDate);
  }

  bool get _nextDayEnabled {
    DateTime limitFuture =
        DateUtils.dateOnly(DateTime.now()).add(const Duration(days: 14));
    DateTime onlyDate = DateUtils.dateOnly(
        Provider.of<UserSelectionModel>(context, listen: false).selectedDay);
    return !onlyDate.isAtSameMomentAs(limitFuture);
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return BottomAppBar(
      height: 60.0,
      child: Consumer<UserSelectionModel>(
        builder: (context, userSelection, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              tooltip: localization.previousDayTooltip,
              icon: const Icon(Icons.chevron_left),
              onPressed: _previousDayEnabled
                  ? () {
                      DateTime previousDay = DateUtils.dateOnly(userSelection
                          .selectedDay
                          .subtract(const Duration(days: 1)));
                      _selectDate(previousDay, userSelection);
                    }
                  : null,
            ),
            TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0)),
                foregroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).colorScheme.onSurface),
              ),
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                    context: context,
                    firstDate: widget.firstDate,
                    lastDate: DateUtils.dateOnly(
                        DateTime.now().add(const Duration(days: 14))),
                    initialDate: userSelection.selectedDay);
                if (selectedDate != null) {
                  _selectDate(selectedDate, userSelection);
                }
              },
              onLongPress: () {
                userSelection.selectedDay = DateUtils.dateOnly(DateTime.now());
              },
              child: Text(
                  DateFormat('dd.MM.yyyy').format(userSelection.selectedDay)),
            ),
            IconButton(
              tooltip: localization.nextDayTooltip,
              icon: const Icon(Icons.chevron_right),
              onPressed: _nextDayEnabled
                  ? () {
                      DateTime nextDay = DateUtils.dateOnly(userSelection
                          .selectedDay
                          .add(const Duration(days: 1)));
                      _selectDate(nextDay, userSelection);
                    }
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
