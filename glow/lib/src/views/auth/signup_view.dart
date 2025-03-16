import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:template/src/design_system/app_logo.dart';
import 'package:template/src/design_system/responsive_values.dart';
import 'package:template/src/design_system/responsive_wrapper.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? selectedIndustry;
  bool agreeToTerms = false;

  final List<String> industries = [
    'Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Retail',
    'Manufacturing',
    'Entertainment',
    'Food & Beverage',
    'Other'
  ];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    companyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (formKey.currentState!.validate() && agreeToTerms) {
      setState(() {
        isLoading = true;
      });

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        
        if (mounted) {
          context.go('/dashboard');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and conditions')),
      );
    }
  }

  void _continueWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Simulate Google sign in
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: ${e.toString()}')),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final form = ResponsiveWrapper(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              const AppLogo(size: 60),
              const Gap(24),
              Text(
                'Create Account',
                style: theme.textTheme.headlineMedium,
              ),
              const Gap(8),
              Text(
                'Join our community of female founders',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              
              // Name field
              _buildFormField(
                controller: nameController,
                placeholder: 'Full Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const Gap(16),
              
              // Email field
              _buildFormField(
                controller: emailController,
                placeholder: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const Gap(16),
              
              // Password field
              _buildFormField(
                controller: passwordController,
                placeholder: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const Gap(16),
              
              // Confirm Password field
              _buildFormField(
                controller: confirmPasswordController,
                placeholder: 'Confirm Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const Gap(16),
              
              // Company name field
              _buildFormField(
                controller: companyController,
                placeholder: 'Company/Startup Name (Optional)',
              ),
              const Gap(16),
              
              // Industry dropdown
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedIndustry,
                  decoration: InputDecoration(
                    hintText: 'Select Industry',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                    hintStyle: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  items: industries.map((String industry) {
                    return DropdownMenuItem<String>(
                      value: industry,
                      child: Text(industry),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedIndustry = newValue;
                    });
                  },
                  validator: (value) {
                    return null; // Optional field
                  },
                  style: theme.textTheme.bodyMedium,
                  dropdownColor: theme.colorScheme.surface,
                ),
              ),
              const Gap(24),
              
              // Terms and conditions checkbox
              Row(
                children: [
                  Checkbox(
                    value: agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        agreeToTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'I agree to the Terms of Service and Privacy Policy',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const Gap(24),
              
              // Sign Up Button
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
                    : const Text('Sign Up'),
                ),
              ),
              const Gap(16),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const Gap(16),
              
              // Google Sign Up
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    foregroundColor: theme.colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                  onPressed: isLoading ? null : _continueWithGoogle,
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Continue with Google'),
                ),
              ),
              const Gap(24),
              
              // Already have an account link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: Text(
                      'Login',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    
    final desktop = Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1573164574572-cb89e39749b4?q=80&w=1000'),
                fit: BoxFit.cover,
                opacity: 0.4,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogo(size: 80),
                    const Gap(32),
                    Text(
                      'Female Founders Hub',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(16),
                    Text(
                      'Connect, learn, and grow with other female entrepreneurs',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: form,
        ),
      ],
    );
    
    return Scaffold(
      body: responsiveValue(
        context,
        mobile: () => form,
        tablet: () => form,
        laptop: () => desktop,
        desktop: () => desktop,
      ),
    );
  }
  
  Widget _buildFormField({
    required TextEditingController controller,
    required String placeholder,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    
    return FormField<String>(
      validator: validator,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: state.hasError 
                  ? Border.all(color: theme.colorScheme.error, width: 1)
                  : null,
            ),
            placeholderStyle: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            style: theme.textTheme.bodyMedium,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: (value) => state.didChange(value),
          ),
          if (state.hasError) ...[
            const Gap(8),
            Text(
              state.errorText!,
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}