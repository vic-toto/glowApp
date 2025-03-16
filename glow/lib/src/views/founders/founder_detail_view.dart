import 'package:flutter/material.dart';
import 'package:template/src/models/founder.dart';

class FounderDetailView extends StatefulWidget {
  final Founder? founder;

  const FounderDetailView({super.key, this.founder});

  @override
  State<FounderDetailView> createState() => _FounderDetailViewState();
}

class _FounderDetailViewState extends State<FounderDetailView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _companyController;
  late TextEditingController _businessTypeController;
  late TextEditingController _websiteController;
  late TextEditingController _notesController;
  late TextEditingController _photoUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.founder?.name ?? '');
    _emailController = TextEditingController(text: widget.founder?.email ?? '');
    _phoneController = TextEditingController(text: widget.founder?.phone ?? '');
    _companyController = TextEditingController(text: widget.founder?.company ?? '');
    _businessTypeController = TextEditingController(text: widget.founder?.businessType ?? '');
    _websiteController = TextEditingController(text: widget.founder?.website ?? '');
    _notesController = TextEditingController(text: widget.founder?.notes ?? '');
    _photoUrlController = TextEditingController(text: widget.founder?.photoUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _businessTypeController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _saveFounder() {
    if (_formKey.currentState!.validate()) {
      final founder = Founder(
        id: widget.founder?.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        company: _companyController.text,
        businessType: _businessTypeController.text,
        website: _websiteController.text,
        notes: _notesController.text,
        photoUrl: _photoUrlController.text,
      );

      Navigator.pop(context, founder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.founder == null ? 'Add Founder' : 'Edit Founder'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
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
                return null;
              },
              keyboardType: TextInputType.emailAddress,
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
              keyboardType: TextInputType.phone,
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
              controller: _businessTypeController,
              decoration: const InputDecoration(
                labelText: 'Business Type',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a business type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a website';
                }
                return null;
              },
              keyboardType: TextInputType.url,
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
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _saveFounder,
              child: Text(widget.founder == null ? 'Add Founder' : 'Update Founder'),
            ),
          ],
        ),
      ),
    );
  }
}