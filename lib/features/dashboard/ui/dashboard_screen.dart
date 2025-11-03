import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controllers/auth_notifier.dart';
import '../controllers/dashboard_provider.dart';
import 'package:impact_hub/widgets/profile_card_widget.dart';
import 'package:impact_hub/widgets/action_button.dart';
import 'package:impact_hub/widgets/impact_title.dart';
import 'package:impact_hub/widgets/event_preview.dart';
import 'package:impact_hub/features/shared/shared_models.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool showEdit = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final appUser = authState.auth;
    final userId = appUser?.userId ?? 'user_1'; // mock fallback

    final eventsAsync = ref.watch(dashboardEventsProvider(4));
    final metricsAsync = ref.watch(dashboardMetricsProvider(userId));

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await authNotifier.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ===== Left: Profile + Quick Actions =====
                ProfileCardWidget(
                  name: appUser?.email?.split('@').first ?? 'Guest User',
                  email: appUser?.email ?? 'guest@example.com',
                  onEdit: () => setState(() => showEdit = true),
                ),
                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Quick Actions',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ActionButton(
                              title: 'Find Events',
                              icon: Icons.calendar_month,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/events'),
                            ),
                            ActionButton(
                              title: 'Join Community',
                              icon: Icons.group,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/communities'),
                            ),
                            ActionButton(
                              title: 'View Impact',
                              icon: Icons.trending_up,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/impact'),
                            ),
                            ActionButton(
                              title: 'Learn',
                              icon: Icons.menu_book,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/resources'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ===== Impact Summary =====
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: metricsAsync.when(
                      data: (m) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Your Impact',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              ImpactTile(
                                  icon: '🌱',
                                  label: 'Events',
                                  value: '${m.eventsAttended}'),
                              ImpactTile(
                                  icon: '👥',
                                  label: 'Communities',
                                  value: '${m.communitiesJoined}'),
                              ImpactTile(
                                  icon: '⭐',
                                  label: 'Points',
                                  value: '${m.totalPoints}'),
                              ImpactTile(
                                  icon: '⏱️',
                                  label: 'Hours',
                                  value: '${m.hoursVolunteered}'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/impact'),
                              child: const Text('View Detailed Dashboard'),
                            ),
                          ),
                        ],
                      ),
                      loading: () => const Center(
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator())),
                      error: (e, st) =>
                          const Text('Failed to load impact metrics'),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // ===== Upcoming Events =====
                eventsAsync.when(
                  data: (list) {
                    if (list.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Upcoming Events',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 180,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) => SizedBox(
                              width: 300,
                              child: EventPreviewCard(event: list[index]),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(
                      child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator())),
                  error: (e, st) =>
                      const Text('Failed to load upcoming events'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => showEdit = true),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
