import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TwitterProfileInfo extends StatelessWidget {
  const TwitterProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(color: Colors.grey[700], fontSize: 14);
    final countStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.mapPin, size: 16, color: Colors.grey[700]),
                SizedBox(width: 4),
                Text('Kampala, Uganda', style: labelStyle),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.calendarDays,
                    size: 16, color: Colors.grey[700]),
                SizedBox(width: 4),
                Text('Joined June 2021', style: labelStyle),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text('420 ', style: countStyle),
            Text('Following', style: labelStyle),
            SizedBox(width: 20),
            Text('8,900 ', style: countStyle),
            Text('Followers', style: labelStyle),
          ],
        ),
      ],
    );
  }
}
