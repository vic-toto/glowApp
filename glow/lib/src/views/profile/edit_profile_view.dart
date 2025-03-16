import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/src/design_system/app_logo.dart';
import 'package:template/src/design_system/responsive_values.dart';
import 'package:template/src/design_system/responsive_wrapper.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    websiteController.dispose();
    linkedinController.dispose();
    instagramController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  String? _validateUrl(String? value) {
    if (value != null && value.isNotEmpty) {
      final urlRegExp = RegExp(
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
        caseSensitive: false,
      );
      if (!urlRegExp.hasMatch(value)) {
        return 'Please enter a valid URL';
      }
    }
    return null;
  }

  Future<void> _submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Simulate saving profile data
        await Future.delayed(const Duration(seconds: 2));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          context.go('/dashboard');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: ResponsiveWrapper(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: theme.colorScheme.surfaceContainer,
                          backgroundImage: profileImage != null 
                            ? FileImage(profileImage!) 
                            : null,
                          child: profileImage == null 
                            ? const Icon(Icons.person, size: 60) 
                            : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Gap(32),
                
                Text(
                  'Website',
                  style: theme.textTheme.titleMedium,
                ),
                const Gap(8),
                TextFormField(
                  controller: websiteController,
                  decoration: InputDecoration(
                    hintText: 'Enter your website URL',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.link),
                  ),
                  validator: _validateUrl,
                ),
                
                const Gap(24),
                
                Text(
                  'LinkedIn',
                  style: theme.textTheme.titleMedium,
                ),
                const Gap(8),
                TextFormField(
                  controller: linkedinController,
                  decoration: InputDecoration(
                    hintText: 'Enter your LinkedIn profile URL',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.business),
                  ),
                  validator: _validateUrl,
                ),
                
                const Gap(24),
                
                Text(
                  'Instagram',
                  style: theme.textTheme.titleMedium,
                ),
                const Gap(8),
                TextFormField(
                  controller: instagramController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Instagram profile URL',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.camera_alt),
                  ),
                  validator: _validateUrl,
                ),
                
                const Gap(24),
                
                Text(
                  'Bio',
                  style: theme.textTheme.titleMedium,
                ),
                const Gap(8),
                TextFormField(
                  controller: bioController,
                  decoration: InputDecoration(
                    hintText: 'Tell us about yourself',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  maxLength: 500,
                ),
                
                const Gap(32),
                
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    onPressed: isLoading ? null : _submit,
                    child: isLoading 
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.onPrimary,
                            strokeWidth: 2.0,
                          ),
                        )
                      : const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}