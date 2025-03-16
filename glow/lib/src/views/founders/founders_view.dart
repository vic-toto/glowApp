import 'package:flutter/material.dart';
import 'package:template/src/design_system/responsive_wrapper.dart';
import 'package:go_router/go_router.dart';
import 'package:template/src/models/founder.dart';
import 'package:template/src/services/founder_service.dart';
import 'package:template/src/views/founders/founder_detail_view.dart';
import 'package:url_launcher/url_launcher.dart';

class FoundersView extends StatefulWidget {
  const FoundersView({super.key});

  @override
  State<FoundersView> createState() => _FoundersViewState();
}

class _FoundersViewState extends State<FoundersView> {
  final FounderService _founderService = FounderService();
  List<Founder> _founders = [];
  List<Founder> _filteredFounders = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFounders();
    _searchController.addListener(_filterFounders);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadFounders() {
    setState(() {
      _founders = _founderService.getFounders();
      _filteredFounders = _founders;
    });
  }

  void _filterFounders() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredFounders = _founders;
      });
    } else {
      setState(() {
        _filteredFounders = _founders
            .where((founder) =>
                founder.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                founder.company.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                founder.businessType.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _addOrEditFounder(BuildContext context, {Founder? founder}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FounderDetailView(founder: founder),
      ),
    );

    if (result != null) {
      setState(() {
        if (founder == null) {
          _founderService.addFounder(result);
        } else {
          _founderService.updateFounder(result);
        }
        _loadFounders();
      });
    }
  }

  void _deleteFounder(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Founder'),
        content: const Text('Are you sure you want to delete this founder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _founderService.deleteFounder(id);
              _loadFounders();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Founders Network'),
      ),
      body: ResponsiveWrapper(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search founders',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterFounders();
                          },
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: _filteredFounders.isEmpty
                  ? const Center(
                      child: Text('No founders found'),
                    )
                  : ListView.builder(
                      itemCount: _filteredFounders.length,
                      itemBuilder: (context, index) {
                        final founder = _filteredFounders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: founder.photoUrl.isNotEmpty
                                  ? NetworkImage(founder.photoUrl) as ImageProvider
                                  : const AssetImage('assets/default_avatar.png'),
                              child: founder.photoUrl.isEmpty ? Text(founder.name[0]) : null,
                            ),
                            title: Text(founder.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(founder.company),
                                Text('Business: ${founder.businessType}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.email),
                                  onPressed: () => _sendEmail(founder.email),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.phone),
                                  onPressed: () => _makePhoneCall(founder.phone),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _addOrEditFounder(context, founder: founder),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteFounder(founder.id),
                                ),
                              ],
                            ),
                            isThreeLine: true,
                            onTap: () => _addOrEditFounder(context, founder: founder),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditFounder(context),
        child: const Icon(Icons.add),
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
        selectedIndex: 4, // Founders is selected
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
}