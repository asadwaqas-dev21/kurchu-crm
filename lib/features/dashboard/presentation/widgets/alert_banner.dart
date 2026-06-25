import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

class AlertBanner extends StatelessWidget {
  final String title;
  final String message;
  final String severity;

  const AlertBanner({
    super.key,
    required this.title,
    required this.message,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    Color bannerColor = Colors.blue;
    IconData bannerIcon = Iconsax.info_circle;

    if (severity == 'WARNING') {
      bannerColor = Colors.orange;
      bannerIcon = Iconsax.warning_2;
    } else if (severity == 'ERROR' || severity == 'CRITICAL') {
      bannerColor = Colors.red;
      bannerIcon = Iconsax.close_circle;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bannerColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(bannerIcon, color: bannerColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: bannerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
