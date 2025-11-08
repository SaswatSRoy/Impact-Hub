import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/action_button.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: const Color(0xFF004D40),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionButton(
                  title: 'Find Events',
                  icon: Icons.calendar_month,
                  onTap: () => Navigator.pushNamed(context, '/events'),
                ),
                ActionButton(
                  title: 'Join Community',
                  icon: Icons.group,
                  onTap: () => Navigator.pushNamed(context, '/communities'),
                ),
                ActionButton(
                  title: 'View Impact',
                  icon: Icons.trending_up,
                  onTap: () => Navigator.pushNamed(context, '/impact'),
                ),
                ActionButton(
                  title: 'Learn',
                  icon: Icons.menu_book,
                  onTap: () => Navigator.pushNamed(context, '/resources'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
