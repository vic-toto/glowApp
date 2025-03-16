import 'package:template/src/models/investor.dart';

class InvestorService {
  static final InvestorService _instance = InvestorService._internal();

  factory InvestorService() {
    return _instance;
  }

  InvestorService._internal();

  final List<Investor> _investors = [
    Investor(
      name: 'Emily Johnson',
      email: 'emily.johnson@venturecp.com',
      phone: '(555) 123-4567',
      company: 'Venture Capital Partners',
      specialties: 'SaaS, FinTech',
      portfolio: 'PayStack, FlutterWave, Chime',
      notes: 'Looking for early-stage startups with female founders',
      photoUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
    ),
    Investor(
      name: 'Michael Chen',
      email: 'michael.chen@techfund.com',
      phone: '(555) 987-6543',
      company: 'Tech Growth Fund',
      specialties: 'AI, Healthcare Tech',
      portfolio: 'NeuralMed, AIAssist, HealthTrack',
      notes: 'Interested in AI applications in healthcare and wellness',
      photoUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
    ),
    Investor(
      name: 'Sarah Williams',
      email: 'sarah@femalefounders.vc',
      phone: '(555) 456-7890',
      company: 'Female Founders Fund',
      specialties: 'E-commerce, EdTech',
      portfolio: 'LearningTree, ShopEase, EduConnect',
      notes: 'Exclusively invests in businesses with female leadership',
      photoUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
    ),
  ];

  List<Investor> getInvestors() {
    return _investors;
  }

  void addInvestor(Investor investor) {
    _investors.add(investor);
  }

  void updateInvestor(Investor updatedInvestor) {
    final index = _investors.indexWhere((investor) => investor.id == updatedInvestor.id);
    if (index != -1) {
      _investors[index] = updatedInvestor;
    }
  }

  void deleteInvestor(String id) {
    _investors.removeWhere((investor) => investor.id == id);
  }

  Investor? getInvestorById(String id) {
    try {
      return _investors.firstWhere((investor) => investor.id == id);
    } catch (e) {
      return null;
    }
  }
}