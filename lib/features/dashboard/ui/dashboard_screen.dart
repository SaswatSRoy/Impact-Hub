import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/controllers/auth_notifier.dart';
import '../controllers/dashboard_provider.dart';
import 'package:impact_hub/widgets/quick_actions.dart';
import 'package:impact_hub/widgets/profile_header.dart';
import 'package:impact_hub/widgets/impact_summary.dart';
import 'package:impact_hub/widgets/upcoming_events.dart';

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
    final appUser = authState.auth?.user;
    final userId = appUser?.id ?? '';

    // Providers
    final eventsAsync = ref.watch(dashboardEventsProvider(4));
    final metricsAsync = ref.watch(dashboardMetricsProvider(userId));

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF004D40),
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Color(0xFF00796B)),
            tooltip: 'Go to Home',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFD32F2F)),
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
        child: RefreshIndicator(
          onRefresh: () async {
            // Reload metrics and user info when refreshed
            await ref.read(authNotifierProvider.notifier).fetchCurrentUser();
            ref.invalidate(dashboardMetricsProvider(userId));
            ref.invalidate(dashboardEventsProvider(4));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ✅ Use real name from backend
                ProfileHeader(
                  name: appUser?.name ?? 'Guest User',
                  email: appUser?.email ?? 'guest@example.com',
                  onEdit: () => setState(() => showEdit = true),
                ),
                const SizedBox(height: 16),

                // Quick actions (navigate to events, communities, etc.)
                const QuickActions(),
                const SizedBox(height: 16),

                // ✅ Impact summary (points, joined events, etc.)
                ImpactSummary(metricsAsync: metricsAsync),
                const SizedBox(height: 18),

                // ✅ Upcoming events
                UpcomingEvents(eventsAsync: eventsAsync),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
