import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controllers/auth_notifier.dart';
import '../../dashboard/controllers/dashboard_provider.dart';
import 'package:impact_hub/widgets/event_preview.dart';
import 'package:impact_hub/widgets/action_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isAuthenticated = authState.auth != null;
    final eventsAsync = ref.watch(dashboardEventsProvider(6));
    final commAsync = ref.watch(dashboardCommunitiesProvider(6));

    return Scaffold(
      appBar: AppBar(title: const Text('ImpactHub Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Hero Section =====
            Text(
              'Make a Real Impact 🌍',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Join thousands of volunteers making positive change through events and communities.',
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionButton(
                  icon: Icons.calendar_month,
                  title: isAuthenticated ? 'Explore Events' : 'Get Started',
                  onTap: () => Navigator.pushNamed(
                    context,
                    isAuthenticated ? '/events' : '/register',
                  ),
                ),
                ActionButton(
                  icon: Icons.group,
                  title: 'Join Communities',
                  onTap: () => Navigator.pushNamed(context, '/communities'),
                ),
                ActionButton(
                  icon: Icons.trending_up,
                  title: 'View Impact',
                  onTap: () => Navigator.pushNamed(context, '/impact'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ===== Featured Events =====
            const Text('Featured Events',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            eventsAsync.when(
              data: (list) => list.isNotEmpty
                  ? SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemCount: list.length,
                        itemBuilder: (_, i) =>
                            SizedBox(width: 300, child: EventPreviewCard(event: list[i])),
                      ),
                    )
                  : const Text('No events available yet.'),
              loading: () => const Center(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator())),
              error: (e, st) => const Text('Failed to load events'),
            ),
            const SizedBox(height: 24),

            // ===== Active Communities =====
            const Text('Active Communities',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            commAsync.when(
              data: (list) => list.isNotEmpty
                  ? Column(
                      children: list
                          .map((c) => Card(
                                child: ListTile(
                                  leading: const Icon(Icons.people_alt),
                                  title: Text(c.name),
                                  subtitle: Text(c.description ?? ''),
                                ),
                              ))
                          .toList(),
                    )
                  : const Text('No communities yet.'),
              loading: () => const Center(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator())),
              error: (e, st) => const Text('Failed to load communities'),
            ),
          ],
        ),
      ),
    );
  }
}
