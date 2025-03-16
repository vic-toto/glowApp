import 'package:flutter/material.dart';
import 'package:template/src/design_system/responsive_wrapper.dart';
import 'package:go_router/go_router.dart';
import 'package:template/src/models/investor.dart';
import 'package:template/src/services/investor_service.dart';
import 'package:template/src/views/investors/investor_detail_view.dart';
import 'package:url_launcher/url_launcher.dart';

class InvestorsView extends StatefulWidget {
  const InvestorsView({super.key});

  @override
  State<InvestorsView> createState() => _InvestorsViewState();
}

class _InvestorsViewState extends State<InvestorsView> {
  final InvestorService _investorService = InvestorService();
  List<Investor> _investors = [];
  List<Investor> _filteredInvestors = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInvestors();
    _searchController.addListener(_filterInvestors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadInvestors() {
    setState(() {
      _investors = _investorService.getInvestors();
      _filteredInvestors = _investors;
    });
  }

  void _filterInvestors() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredInvestors = _investors;
      });
    } else {
      setState(() {
        _filteredInvestors = _investors
            .where((investor) =>
                investor.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                investor.company.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                investor.specialties.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _addOrEditInvestor(BuildContext context, {Investor? investor}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestorDetailView(investor: investor),
      ),
    );

    if (result != null) {
      setState(() {
        if (investor == null) {
          _investorService.addInvestor(result);
        } else {
          _investorService.updateInvestor(result);
        }
        _loadInvestors();
      });
    }
  }

  void _deleteInvestor(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Investor'),
        content: const Text('Are you sure you want to delete this investor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _investorService.deleteInvestor(id);
              _loadInvestors();
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
        title: const Text('Investors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEditInvestor(context),
          ),
        ],
      ),
      body: ResponsiveWrapper(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search investors',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterInvestors();
                          },
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: _filteredInvestors.isEmpty
                  ? const Center(
                      child: Text('No investors found'),
                    )
                  : ListView.builder(
                      itemCount: _filteredInvestors.length,
                      itemBuilder: (context, index) {
                        final investor = _filteredInvestors[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: investor.photoUrl.isNotEmpty
                                  ? NetworkImage(investor.photoUrl) as ImageProvider
                                  : const AssetImage('assets/default_avatar.png'),
                              child: investor.photoUrl.isEmpty ? Text(investor.name[0]) : null,
                            ),
                            title: Text(investor.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(investor.company),
                                Text('Specialties: ${investor.specialties}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.email),
                                  onPressed: () => _sendEmail(investor.email),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.phone),
                                  onPressed: () => _makePhoneCall(investor.phone),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _addOrEditInvestor(context, investor: investor),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteInvestor(investor.id),
                                ),
                              ],
                            ),
                            isThreeLine: true,
                            onTap: () => _addOrEditInvestor(context, investor: investor),
                          ),
                        );
                      },
                    ),
            ),
          ],
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
        selectedIndex: 3, // Investors is selected
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