import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impact_hub/features/shared/shared_models.dart';
import '../../../widgets/event_preview.dart';

class UpcomingEvents extends StatelessWidget {
  final AsyncValue<List<EventModel>> eventsAsync;

  const UpcomingEvents({super.key, required this.eventsAsync});

  @override
  Widget build(BuildContext context) {
    return eventsAsync.when(
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Events',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: const Color(0xFF004D40),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => SizedBox(
                  width: 300,
                  child: EventPreviewCard(event: list[index]),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Text('Failed to load upcoming events'),
    );
  }
}
