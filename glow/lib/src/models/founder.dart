import 'package:uuid/uuid.dart';

class Founder {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String company;
  final String businessType;
  final String website;
  final String notes;
  final String photoUrl;

  Founder({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.businessType,
    required this.website,
    this.notes = '',
    this.photoUrl = '',
  }) : id = id ?? const Uuid().v4();

  Founder copyWith({
    String? name,
    String? email,
    String? phone,
    String? company,
    String? businessType,
    String? website,
    String? notes,
    String? photoUrl,
  }) {
    return Founder(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      businessType: businessType ?? this.businessType,
      website: website ?? this.website,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}