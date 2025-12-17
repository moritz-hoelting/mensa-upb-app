import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mensa_upb/canteen.dart';
import 'package:mensa_upb/chart_legend_item.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:provider/provider.dart';

class PriceHistoryDisplay extends StatelessWidget {
  static final colors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
  ];

  const PriceHistoryDisplay({super.key, required this.data});

  final Map<String, Map<DateTime, Map<String, String>>> data;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final dateFormatter = DateFormat.Md(locale);
    final fullDateFormatter = DateFormat.yMd(locale);
    final currencyFormatter =
        NumberFormat.currency(locale: locale, symbol: '€', decimalDigits: 2);
    final fullCurrencyFormatter =
        NumberFormat.currency(locale: locale, symbol: '€', decimalDigits: 0);

    final selectedPriceLevel = Provider.of<UserSelectionModel>(context).priceLevel;

    final allDates = <DateTime>{};
    data.forEach((_, entries) {
      allDates.addAll(entries.keys);
    });

    final dates = allDates.toList()..sort();

    final startDate = dates.first;

    double xFromDate(DateTime date) {
      return date.difference(startDate).inDays.toDouble();
    }

    final maxX = xFromDate(dates.last);
    final maxY = max(
        1,
        data.values.expand((canteenData) {
          return canteenData.values.map((dayData) {
            final value = dayData[selectedPriceLevel.plural];
            if (value == null) return 0.0;
            return double.parse(value);
          });
        }).fold<double>(0.0, (previousValue, element) {
          return element > previousValue ? element : previousValue;
        }));

    final Map<DateTime, double> xMap = {
      for (int i = 0; i < dates.length; i++) dates[i]: xFromDate(dates[i])
    };

    final xReverseMap = {
      for (final entry in xMap.entries) entry.value: entry.key
    };

    final Set<double> usedXindices = xMap.values.toSet();

    List<LineChartBarData> buildCanteenLines() {
      int colorIndex = 0;

      return data.values.map((canteenData) {
        final spots = <FlSpot>[];

        for (final date in dates) {
          final dayData = canteenData[date];
          if (dayData == null) continue;

          final value = dayData[selectedPriceLevel.plural];
          if (value == null) continue;

          spots.add(FlSpot(xMap[date]!, double.parse(value)));
        }

        return LineChartBarData(
          spots: spots,
          isCurved: true,
          color: colors[colorIndex++ % colors.length],
          barWidth: 2,
          dotData: FlDotData(show: true),
        );
      }).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text('Price History', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              minX: -0.025 * max(1, maxX),
              maxX: 1.025 * max(1, maxX),
              minY: 0,
              maxY: maxY * 1.1,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (usedXindices.contains(value)) {
                        return Text(dateFormatter.format(xReverseMap[index]!),
                            style: TextStyle(fontSize: 10));
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value > maxY) return Text('');
                      return Text(fullCurrencyFormatter.format(value));
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    final date = xReverseMap[touchedSpots[0].x]!;
                    return touchedSpots.mapIndexed((index, touchedSpot) {
                      var canteenIdentifier =
                          data.keys.elementAt(touchedSpot.barIndex);
                      var prefix = Canteen.fromIdentifier(canteenIdentifier)
                              ?.displayName ??
                          canteenIdentifier;
                      var text =
                          '$prefix: ${currencyFormatter.format(touchedSpot.y)}';
                      if (index == 0) {
                        text = '${fullDateFormatter.format(date)}\n$text';
                      }
                      return LineTooltipItem(
                        text,
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: buildCanteenLines(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: data.keys.mapIndexed((index, canteenIdent) {
            final canteenName =
                Canteen.fromIdentifier(canteenIdent)?.displayName ??
                    canteenIdent;
            return ChartLegendItem(
              color: colors[index % colors.length],
              label: canteenName,
            );
          }).toList(),
        ),
      ],
    );
  }
}
