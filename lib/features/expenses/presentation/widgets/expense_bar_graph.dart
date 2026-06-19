import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/themes/app_theme.dart';
import 'package:expense_tracker/core/utils/date_formatter.dart';
import 'package:expense_tracker/features/expenses/presentation/models/individual_bar_model.dart';

class ExpenseBarGraph extends StatelessWidget {
  final List<double> monthlySummary;
  final int startMonth;

  const ExpenseBarGraph({
    super.key,
    required this.monthlySummary,
    required this.startMonth,
  });

  @override
  Widget build(BuildContext context) {
    final List<IndividualBarModel> barData = List.generate(
      monthlySummary.length,
      (index) => IndividualBarModel(x: index, y: monthlySummary[index]),
    );

    final double maxBarValue = monthlySummary.isEmpty
        ? 0.0
        : monthlySummary.reduce((curr, next) => curr > next ? curr : next);

    double maxY = 100.0;
    double interval = 25.0;

    if (maxBarValue > 0) {
      double rawMax = maxBarValue * 1.25;
      if (rawMax <= 10) {
        maxY = 10;
        interval = 2.5;
      } else if (rawMax <= 50) {
        maxY = 50;
        interval = 10;
      } else if (rawMax <= 100) {
        maxY = 100;
        interval = 25;
      } else if (rawMax <= 500) {
        maxY = 500;
        interval = 100;
      } else if (rawMax <= 1000) {
        maxY = 1000;
        interval = 250;
      } else if (rawMax <= 5000) {
        maxY = 5000;
        interval = 1000;
      } else if (rawMax <= 10000) {
        maxY = 10000;
        interval = 2500;
      } else {
        maxY = (rawMax / 1000).ceil() * 1000.0;
        interval = maxY / 4;
      }
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridLineColor = isDark
        ? AppColors.textDarkSecondary.withValues(alpha: 0.05)
        : AppColors.textLightSecondary.withValues(alpha: 0.08);

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: gridLineColor,
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 8,
              getTitlesWidget: (value, meta) => const SizedBox.shrink(),
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 8,
              getTitlesWidget: (value, meta) => const SizedBox.shrink(),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              interval: interval,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                );
                String text;
                if (value >= 1000) {
                  text = '₹${(value / 1000).toStringAsFixed(1)}k';
                } else {
                  text = '₹${value.toInt()}';
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(text, style: style),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                );
                int index = value.toInt();
                if (index >= 0 && index < monthlySummary.length) {
                  int monthNumber = (startMonth + index - 1) % 12 + 1;
                  return SideTitleWidget(
                    meta: meta,
                    space: 8,
                    child: Text(DateFormatter.getMonthShortName(monthNumber), style: style),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.grey[900]!.withValues(alpha: 0.9),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              int monthNumber = (startMonth + group.x - 1) % 12 + 1;
              return BarTooltipItem(
                '${DateFormatter.getMonthShortName(monthNumber)}\n₹${rod.toY.toStringAsFixed(2)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        barGroups: barData.map((bar) {
          return BarChartGroupData(
            x: bar.x,
            barRods: [
              BarChartRodData(
                toY: bar.y,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 10,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
