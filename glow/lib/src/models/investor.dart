import 'package:uuid/uuid.dart';

class Investor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String company;
  final String specialties;
  final String portfolio;
  final String notes;
  final String photoUrl;

  Investor({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.specialties,
    required this.portfolio,
    this.notes = '',
    this.photoUrl = '',
  }) : id = id ?? const Uuid().v4();

  Investor copyWith({
    String? name,
    String? email,
    String? phone,
    String? company,
    String? specialties,
    String? portfolio,
    String? notes,
    String? photoUrl,
  }) {
    return Investor(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      specialties: specialties ?? this.specialties,
      portfolio: portfolio ?? this.portfolio,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}