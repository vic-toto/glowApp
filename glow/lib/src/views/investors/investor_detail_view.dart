import 'package:flutter/material.dart';
import 'package:template/src/models/investor.dart';

class InvestorDetailView extends StatefulWidget {
  final Investor? investor;

  const InvestorDetailView({super.key, this.investor});

  @override
  State<InvestorDetailView> createState() => _InvestorDetailViewState();
}

class _InvestorDetailViewState extends State<InvestorDetailView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _companyController;
  late TextEditingController _specialtiesController;
  late TextEditingController _portfolioController;
  late TextEditingController _notesController;
  late TextEditingController _photoUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.investor?.name ?? '');
    _emailController = TextEditingController(text: widget.investor?.email ?? '');
    _phoneController = TextEditingController(text: widget.investor?.phone ?? '');
    _companyController = TextEditingController(text: widget.investor?.company ?? '');
    _specialtiesController = TextEditingController(text: widget.investor?.specialties ?? '');
    _portfolioController = TextEditingController(text: widget.investor?.portfolio ?? '');
    _notesController = TextEditingController(text: widget.investor?.notes ?? '');
    _photoUrlController = TextEditingController(text: widget.investor?.photoUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _specialtiesController.dispose();
    _portfolioController.dispose();
    _notesController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _saveInvestor() {
    if (_formKey.currentState!.validate()) {
      final investor = Investor(
        id: widget.investor?.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        company: _companyController.text,
        specialties: _specialtiesController.text,
        portfolio: _portfolioController.text,
        notes: _notesController.text,
        photoUrl: _photoUrlController.text,
      );
      Navigator.pop(context, investor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.investor == null ? 'Add Investor' : 'Edit Investor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveInvestor,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_photoUrlController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_photoUrlController.text),
                    ),
                  ),
                ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _specialtiesController,
                decoration: const InputDecoration(
                  labelText: 'Specialties',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter specialties';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _portfolioController,
                decoration: const InputDecoration(
                  labelText: 'Portfolio',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter portfolio details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _photoUrlController,
                decoration: const InputDecoration(
                  labelText: 'Photo URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveInvestor,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    widget.investor == null ? 'Add Investor' : 'Update Investor',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}