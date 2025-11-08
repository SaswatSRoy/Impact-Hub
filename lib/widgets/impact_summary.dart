import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impact_hub/features/shared/shared_models.dart';
import 'package:impact_hub/widgets/impact_title.dart';

class ImpactSummary extends StatelessWidget {
  final AsyncValue<MetricsModel> metricsAsync;


  const ImpactSummary({super.key, required this.metricsAsync});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: metricsAsync.when(
          data: (m) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Impact',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: const Color(0xFF004D40),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ImpactTile(icon: '🌱', label: 'Events', value: '${m.eventsAttended}'),
                  ImpactTile(icon: '👥', label: 'Communities', value: '${m.communitiesJoined}'),
                  ImpactTile(icon: '⭐', label: 'Points', value: '${m.totalPoints}'),
                  ImpactTile(icon: '⏱️', label: 'Hours', value: '${m.hoursVolunteered}'),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/impact'),
                  child: const Text('View Detailed Dashboard'),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const Text('Failed to load metrics'),
        ),
      ),
    );
  }
}
