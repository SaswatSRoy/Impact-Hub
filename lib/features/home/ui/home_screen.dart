import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/controllers/auth_notifier.dart';
import '../../dashboard/controllers/dashboard_provider.dart';
import 'package:impact_hub/widgets/event_preview.dart';
import 'package:impact_hub/widgets/action_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final isAuthenticated = authState.auth?.token.isNotEmpty ?? false;

    final eventsAsync = ref.watch(dashboardEventsProvider(6));
    final commAsync = ref.watch(dashboardCommunitiesProvider(6));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ImpactHub Home',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF004D40),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          if (isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                await authNotifier.logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== Intro ====
              Text(
                'Make a Real Impact 🌍',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: const Color(0xFF004D40),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join thousands of volunteers making positive change through events and communities.',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),

              // ==== Quick Actions ====
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
              const SizedBox(height: 28),

              // ==== Featured Events ====
              Text(
                'Featured Events',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xFF004D40),
                ),
              ),
              const SizedBox(height: 8),
              eventsAsync.when(
                data: (list) => list.isNotEmpty
                    ? SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemCount: list.length,
                          itemBuilder: (_, i) => SizedBox(
                            width: 300,
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/event-details',
                                arguments: list[i],
                              ),
                              child: EventPreviewCard(event: list[i]),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        'No events available yet.',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, st) => Text(
                  'Failed to load events',
                  style: GoogleFonts.poppins(color: Colors.redAccent),
                ),
              ),

              const SizedBox(height: 28),

              // ==== Active Communities ====
              Text(
                'Active Communities',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xFF004D40),
                ),
              ),
              const SizedBox(height: 8),
              commAsync.when(
                data: (list) => list.isNotEmpty
                    ? Column(
                        children: list
                            .map(
                              (c) => Card(
                                color: Colors.grey.shade50,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.people_alt),
                                  title: Text(
                                    c.name,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    c.description,
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : Text(
                        'No communities yet.',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, st) => Text(
                  'Failed to load communities',
                  style: GoogleFonts.poppins(color: Colors.redAccent),
                ),
              ),

              const SizedBox(height: 40),

              // ==== Go to Dashboard ====
              Center(
                child: ActionButton(
                  icon: Icons.dashboard,
                  title: 'Go to Dashboard',
                  onTap: () => Navigator.pushNamed(context, '/dashboard'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
