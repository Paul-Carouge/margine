import 'package:flutter/material.dart';

/// Reusable widget that shows a profit amount and its ROI percentage.
///
/// The profit is displayed in a large Inter (tabular) font, green for positive
/// numbers and red for negative. The ROI is shown as a smaller badge next
/// to the profit amount, styled with the gold accent color per v2 design.
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
            : const Color(0xFF4CAF50))
        : (theme.brightness == Brightness.light
            ? const Color(0xFFC62828)
            : const Color(0xFFEF5350));

    final goldColor = theme.brightness == Brightness.light
        ? const Color(0xFFB8860B)
        : const Color(0xFFF5A623);

    final prefix = isPositive ? '+' : '';
    final profitText = '$prefix\u20ac${profit.toStringAsFixed(2)}';

    final profitWidget = Text(
      profitText,
      style: TextStyle(
        fontSize: compact ? 16 : 22,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
        color: profitColor,
      ),
    );

    final roiWidget = roi != null
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light
                  ? const Color(0xFFB8860B).withValues(alpha: 0.12)
                  : const Color(0xFFF5A623).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${roi! >= 0 ? '+' : ''}${roi!.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: compact ? 11 : 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: goldColor,
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
