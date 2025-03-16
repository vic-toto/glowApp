import 'package:template/src/models/founder.dart';

class FounderService {
  // In memory storage for founders
  static final List<Founder> _founders = [
    Founder(
      name: 'Sarah Johnson',
      email: 'sarah@techstartup.com',
      phone: '555-123-4567',
      company: 'TechStartup Inc.',
      businessType: 'SaaS',
      website: 'www.techstartup.com',
      notes: 'Met at Women in Tech conference',
      photoUrl: '',
    ),
    Founder(
      name: 'Emily Chen',
      email: 'emily@greenventures.com',
      phone: '555-987-6543',
      company: 'Green Ventures',
      businessType: 'Sustainability',
      website: 'www.greenventures.com',
      notes: 'Looking for partnership opportunities',
      photoUrl: '',
    ),
    Founder(
      name: 'Maria Rodriguez',
      email: 'maria@healthinnovate.com',
      phone: '555-456-7890',
      company: 'Health Innovate',
      businessType: 'Healthcare Tech',
      website: 'www.healthinnovate.com',
      notes: 'Recently secured Series A funding',
      photoUrl: '',
    ),
  ];

  List<Founder> getFounders() {
    return List.from(_founders);
  }

  void addFounder(Founder founder) {
    _founders.add(founder);
  }

  void updateFounder(Founder updatedFounder) {
    final index = _founders.indexWhere((founder) => founder.id == updatedFounder.id);
    if (index != -1) {
      _founders[index] = updatedFounder;
    }
  }

  void deleteFounder(String id) {
    _founders.removeWhere((founder) => founder.id == id);
  }

  Founder? getFounderById(String id) {
    try {
      return _founders.firstWhere((founder) => founder.id == id);
    } catch (e) {
      return null;
    }
  }
}