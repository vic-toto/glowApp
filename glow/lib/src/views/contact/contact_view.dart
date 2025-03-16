import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:template/src/design_system/responsive_wrapper.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get in Touch',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                "We're here to help with any questions or feedback about Female Founders Hub.",
                style: theme.textTheme.bodyLarge,
              ),
              const Gap(32),
              
              _buildContactCard(
                context,
                icon: Icons.email_outlined,
                title: 'Email Us',
                subtitle: 'support@femalefoundersnhub.com',
                onTap: () => _launchEmail('support@femalefoundersnhub.com'),
              ),
              
              _buildContactCard(
                context,
                icon: Icons.phone_outlined,
                title: 'Call Us',
                subtitle: '(123) 456-7890',
                onTap: () => _launchPhone('1234567890'),
              ),
              
              _buildContactCard(
                context,
                icon: Icons.location_on_outlined,
                title: 'Visit Us',
                subtitle: '123 Founder Street, Innovation District, San Francisco, CA 94103',
                onTap: () => _launchMaps('123 Founder Street, San Francisco, CA 94103'),
              ),
              
              const Gap(32),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send Us a Message',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(16),
                      
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gap(16),
                      
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Your Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gap(16),
                      
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gap(16),
                      
                      TextField(
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gap(24),
                      
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Message sent! We\'ll get back to you soon.'),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('SEND MESSAGE'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Gap(24),
              
              Center(
                child: Text(
                  'We typically respond within 24-48 hours',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
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
        selectedIndex: 5, // Contact is selected
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
  
  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _launchEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri);
    }
  }
  
  Future<void> _launchPhone(String phone) async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri);
    }
  }
  
  Future<void> _launchMaps(String address) async {
    final Uri uri = Uri.parse(
      'https://maps.google.com/?q=${Uri.encodeFull(address)}',
    );
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri, mode: launcher.LaunchMode.externalApplication);
    }
  }
}