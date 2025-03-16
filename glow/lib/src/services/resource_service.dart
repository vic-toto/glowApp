import 'package:template/src/models/resource.dart';

class ResourceService {
  // Singleton pattern
  static final ResourceService _instance = ResourceService._internal();
  factory ResourceService() => _instance;
  ResourceService._internal();

  final List<Resource> _resources = [
    Resource(
      id: '1',
      title: 'How to Secure Your First VC Investment',
      description: 'A comprehensive guide for female founders seeking venture capital.',
      url: 'https://example.com/vc-investment-guide',
      type: ResourceType.article,
      dateAdded: DateTime(2023, 1, 15),
      imageUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e',
    ),
    Resource(
      id: '2',
      title: 'Pitch Deck Masterclass',
      description: 'Learn how to create a compelling pitch deck that gets investors excited.',
      url: 'https://example.com/pitch-deck-video',
      type: ResourceType.video,
      dateAdded: DateTime(2023, 2, 10),
      imageUrl: 'https://images.unsplash.com/photo-1553484771-047a44eee27b',
    ),
    Resource(
      id: '3',
      title: 'Female Founder Funding Report 2023',
      description: 'Latest statistics and insights on funding for women-led startups.',
      url: 'https://example.com/funding-report.pdf',
      type: ResourceType.document,
      dateAdded: DateTime(2023, 3, 5),
    ),
    Resource(
      id: '4',
      title: 'Networking Strategies for Entrepreneurs',
      description: 'Effective approaches to build your professional network.',
      url: 'https://example.com/networking-strategies',
      type: ResourceType.website,
      dateAdded: DateTime(2023, 4, 18),
      imageUrl: 'https://images.unsplash.com/photo-1543269865-cbf427effbad',
    ),
    Resource(
      id: '5',
      title: 'Startup Financial Planning Templates',
      description: 'Essential financial planning documents for your startup.',
      url: 'https://example.com/financial-templates.xlsx',
      type: ResourceType.document,
      dateAdded: DateTime(2023, 5, 22),
    ),
    Resource(
      id: '6',
      title: 'The Female Entrepreneur Podcast',
      description: 'Weekly interviews with successful women entrepreneurs.',
      url: 'https://example.com/female-entrepreneur-podcast',
      type: ResourceType.podcast,
      dateAdded: DateTime(2023, 6, 10),
      imageUrl: 'https://images.unsplash.com/photo-1589903308904-1010c2294adc',
    ),
  ];

  List<Resource> getAllResources() {
    return _resources;
  }

  List<Resource> getResourcesByType(ResourceType type) {
    return _resources.where((resource) => resource.type == type).toList();
  }

  List<Resource> searchResources(String query) {
    final lowerCaseQuery = query.toLowerCase();
    return _resources.where((resource) {
      return resource.title.toLowerCase().contains(lowerCaseQuery) ||
          resource.description.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }
}