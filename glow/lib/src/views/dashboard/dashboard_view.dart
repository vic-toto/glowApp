import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:template/src/design_system/app_logo.dart';
import 'package:template/src/design_system/responsive_wrapper.dart';
import 'package:gap/gap.dart';
import 'package:template/src/services/event_service.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _eventService = EventService();
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final upcomingEvents = _eventService.getAllEvents()
      ..sort((a, b) => a.date.compareTo(b.date));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('GLOW Female Founders Hub'),
        centerTitle: false,
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                        child: InkWell(
                          onTap: () => context.go('/edit-profile'),
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!',
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              'What would you like to do today?',
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => context.go('/edit-profile'),
                              child: Text('Edit Profile'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Feature cards grid
              Text(
                'Quick Access',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    title: 'Resources',
                    icon: Icons.menu_book,
                    color: Colors.purple,
                    onTap: () => context.go('/resources'),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Calendar',
                    icon: Icons.calendar_month,
                    color: Colors.blue,
                    onTap: () => context.go('/calendar'),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Investors',
                    icon: Icons.attach_money,
                    color: Colors.green,
                    onTap: () => context.go('/investors'),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Founders',
                    icon: Icons.people,
                    color: Colors.orange,
                    onTap: () => context.go('/founders'),
                  ),
                ],
              ),
              
              const Gap(24),
              
              // Upcoming events section
              Text(
                'Upcoming Events',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              
              upcomingEvents.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('No upcoming events'),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: upcomingEvents.length > 3 ? 3 : upcomingEvents.length,
                      itemBuilder: (context, index) {
                        final event = upcomingEvents[index];
                        final formattedDate = DateFormat.yMMMMd().format(event.date);
                        return _buildEventCard(
                          context,
                          title: event.title,
                          date: formattedDate,
                          time: '${event.startTime.format(context)} - ${event.endTime.format(context)}',
                          location: event.description,
                          color: event.color,
                        );
                      },
                    ),
              
              Center(
                child: TextButton.icon(
                  onPressed: () => context.go('/calendar'),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('View All Events'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.go('/resources');
              break;
            case 2:
              context.go('/calendar');
              break;
            case 3:
              context.go('/investors');
              break;
            case 4:
              context.go('/founders');
              break;
            case 5:
              context.go('/contact');
              break;
          }
        },
        selectedIndex: 0, // Dashboard is selected
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Resources',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.attach_money),
            selectedIcon: Icon(Icons.attach_money),
            label: 'Investors',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Founders',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_support_outlined),
            selectedIcon: Icon(Icons.contact_support),
            label: 'Contact',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const Gap(12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context, {
    required String title,
    required String date,
    required String time,
    required String location,
    Color color = Colors.blue,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go('/calendar'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 70,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Gap(4),
                    Text(date),
                    Text(
                      '$time • $location',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}