import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impact_hub/features/dashboard/controllers/dashboard_provider.dart';
import 'package:impact_hub/features/dashboard/controllers/dashboard_controller.dart';
import 'package:impact_hub/features/shared/shared_models.dart';

class CommunitiesScreen extends ConsumerWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commAsync = ref.watch(dashboardCommunitiesProvider(20));
    final dashboardState = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'Communities',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF004D40),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF004D40)),
      ),
      body: SafeArea(
        child: commAsync.when(
          data: (communities) {
            if (communities.isEmpty) {
              return Center(
                child: Text(
                  'No communities available yet.',
                  style: GoogleFonts.lato(color: Colors.grey[600]),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(dashboardCommunitiesProvider);
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: communities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final c = communities[index];
                  final joined =
                      dashboardState.joinedCommunities.contains(c.id);

                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.group, color: Color(0xFF00796B)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  c.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF004D40),
                                  ),
                                ),
                              ),
                              if (c.verified)
                                const Icon(Icons.verified,
                                    color: Colors.teal, size: 18),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            c.description.isNotEmpty
                                ? c.description
                                : 'No description provided.',
                            style: GoogleFonts.lato(
                                color: Colors.grey[700], fontSize: 13.5),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.people_outline,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${c.members} members',
                                style: GoogleFonts.lato(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                              const Spacer(),
                              ElevatedButton.icon(
                                onPressed: joined
                                    ? null
                                    : () async {
                                        try {
                                          await controller.joinCommunity(c.id);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Joined ${c.name} 🎉'),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                e.toString().replaceAll(
                                                    'Exception: ', ''),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: joined
                                      ? Colors.grey
                                      : const Color(0xFF00796B),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: Icon(
                                  joined ? Icons.check : Icons.add,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  joined ? 'Joined' : 'Join',
                                  style:
                                      const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              'Failed to load communities\n${e.toString()}',
              style: GoogleFonts.lato(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
