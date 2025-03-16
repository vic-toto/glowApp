import 'package:flutter/material.dart';
import 'package:template/src/design_system/responsive_wrapper.dart';
import 'package:go_router/go_router.dart';
import 'package:template/src/models/resource.dart';
import 'package:template/src/services/resource_service.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:gap/gap.dart';

class ResourcesView extends StatefulWidget {
  const ResourcesView({super.key});

  @override
  State<ResourcesView> createState() => _ResourcesViewState();
}

class _ResourcesViewState extends State<ResourcesView> {
  final ResourceService _resourceService = ResourceService();
  ResourceType? _selectedType;
  String _searchQuery = '';
  late List<Resource> _filteredResources;

  @override
  void initState() {
    super.initState();
    _filteredResources = _resourceService.getAllResources();
  }

  void _filterResources() {
    var resources = _resourceService.getAllResources();
    
    // Apply type filter
    if (_selectedType != null) {
      resources = resources.where((r) => r.type == _selectedType).toList();
    }
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      resources = resources.where((r) => 
        r.title.toLowerCase().contains(query) || 
        r.description.toLowerCase().contains(query)
      ).toList();
    }
    
    setState(() {
      _filteredResources = resources;
    });
  }

  Future<void> _openResourceUrl(String url) async {
    final uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: ResponsiveWrapper(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search resources...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _filterResources();
                  });
                },
              ),
            ),
            
            // Filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: _selectedType == null,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedType = null;
                              _filterResources();
                            });
                          }
                        },
                      ),
                    ),
                    ...ResourceType.values.map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(type.toString().split('.').last),
                          selected: _selectedType == type,
                          onSelected: (selected) {
                            setState(() {
                              _selectedType = selected ? type : null;
                              _filterResources();
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            
            // Resource list
            Expanded(
              child: _filteredResources.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          const Gap(16),
                          Text(
                            'No resources found',
                            style: theme.textTheme.titleLarge,
                          ),
                          if (_searchQuery.isNotEmpty || _selectedType != null)
                            TextButton.icon(
                              icon: const Icon(Icons.clear),
                              label: const Text('Clear filters'),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _selectedType = null;
                                  _filteredResources = _resourceService.getAllResources();
                                });
                              },
                            ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredResources.length,
                      itemBuilder: (context, index) {
                        final resource = _filteredResources[index];
                        return ResourceCard(
                          resource: resource,
                          onTap: () => _openResourceUrl(resource.url),
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
        selectedIndex: 1, // Resources is selected
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
  
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter by Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedType == null,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedType = null;
                            });
                            _filterResources();
                          }
                        },
                      ),
                      ...ResourceType.values.map((type) {
                        return ChoiceChip(
                          label: Text(type.toString().split('.').last),
                          selected: _selectedType == type,
                          onSelected: (selected) {
                            setState(() {
                              _selectedType = selected ? type : null;
                            });
                            _filterResources();
                          },
                        );
                      }),
                    ],
                  ),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                      const Gap(8),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _filterResources();
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ResourceCard extends StatelessWidget {
  final Resource resource;
  final VoidCallback onTap;

  const ResourceCard({
    super.key,
    required this.resource,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resource.imageUrl != null)
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(resource.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              resource.typeIcon,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              resource.typeLabel,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    resource.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    resource.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Added on ${resource.dateAdded.month}/${resource.dateAdded.day}/${resource.dateAdded.year}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}