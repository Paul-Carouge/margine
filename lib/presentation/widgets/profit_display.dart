import 'package:flutter/material.dart';

/// Reusable widget that shows a profit amount and its ROI percentage.
///
/// The profit is displayed in a large monospace font, green for positive
/// numbers and red for negative. The ROI is shown as a smaller badge next
/// to the profit amount, styled with the tennis-green tonal container.
class ProfitDisplay extends StatelessWidget {
  const ProfitDisplay({
    super.key,
    required this.profit,
    this.roi,
    this.compact = false,
  });

  /// The net profit amount (can be positive or negative).
  final double profit;

  /// Optional ROI percentage (e.g. `42.3` for 42.3%).
  final double? roi;

  /// When `true` shows a single-line row layout (used in cards).
  /// Defaults to `false` which uses a stacked column layout.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = profit >= 0;
    final profitColor = isPositive
        ? (theme.brightness == Brightness.light
            ? const Color(0xFF2E7D32)
            : const Color(0xFF66BB6A))
        : (theme.brightness == Brightness.light
            ? const Color(0xFFC62828)
            : const Color(0xFFEF5350));

    final prefix = isPositive ? '+' : '';
    final profitText = '$prefix\u20ac${profit.toStringAsFixed(2)}';

    final profitWidget = Text(
      profitText,
      style: TextStyle(
        fontSize: compact ? 16 : 22,
        fontWeight: FontWeight.w700,
        fontFamily: 'monospace',
        color: profitColor,
      ),
    );

    final roiWidget = roi != null
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light
                  ? const Color(0xFFEEF9D0)
                  : const Color(0xFF2A3A00),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${roi! >= 0 ? '+' : ''}${roi!.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: compact ? 11 : 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF557000)
                    : const Color(0xFFC5F02E),
              ),
            ),
          )
        : const SizedBox.shrink();

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          profitWidget,
          if (roi != null) ...[
            const SizedBox(width: 8),
            roiWidget,
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profitWidget,
        if (roi != null) ...[
          const SizedBox(height: 6),
          roiWidget,
        ],
      ],
    );
  }
}
