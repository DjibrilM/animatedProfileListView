import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.grey[300];
    final iconColor = Colors.grey[500];

    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://static.wikia.nocookie.net/studio-ghibli/images/8/8e/Chihiro_Ogino.jpg',
            ),
          ),
          const SizedBox(width: 12),
          // Post Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & handle
                Row(
                  children: [
                    Text(
                      'Djibril Mugisho',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('@djibril1st',
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 14)),
                    const SizedBox(width: 6),
                    Text('· 3h',
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),
                // Tweet text
                Text(
                  'Experimenting with dark UI, blur layers, and scroll magic in Flutter. It’s getting spicy 🔥',
                  style: TextStyle(color: textColor, fontSize: 15),
                ),
                const SizedBox(height: 12),
                // Image attachment
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://creator.nightcafe.studio/jobs/kI4ftYiSO2wz0vT2G994/kI4ftYiSO2wz0vT2G994--1--jemyn.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                // Action bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconText(LucideIcons.messageCircle, '9', iconColor!),
                    _iconText(LucideIcons.repeat, '3', iconColor),
                    _iconText(LucideIcons.heart, '120', iconColor),
                    _iconText(LucideIcons.chartArea, '2,043', iconColor),
                    Icon(LucideIcons.share2, size: 18, color: iconColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String count, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(count, style: TextStyle(color: color, fontSize: 13)),
      ],
    );
  }
}
