import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:template/src/design_system/app_logo.dart';
import 'package:template/src/design_system/responsive_values.dart';
import 'package:template/src/design_system/responsive_wrapper.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (formKey.currentState!.validate()) {
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
            SnackBar(content: Text('Login failed: ${e.toString()}')),
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
                'Welcome Back!',
                style: theme.textTheme.headlineMedium,
              ),
              const Gap(8),
              Text(
                'Login to GLOW Hub',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              
              // Email field
              FormField<String>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoTextField(
                      controller: emailController,
                      placeholder: 'Email',
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
                      keyboardType: TextInputType.emailAddress,
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
              ),
              const Gap(16),
              
              // Password field
              FormField<String>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoTextField(
                      controller: passwordController,
                      placeholder: 'Password',
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
                      obscureText: true,
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
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Forgot password functionality
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const Gap(16),
              
              // Login Button
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
                    : const Text('Login'),
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
              
              // Google Login
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
              
              // Create account link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/signup');
                    },
                    child: Text(
                      'Sign up',
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
                      'Welcome to GLOW Female Founders Hub',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(16),
                    Text(
                      'Connect, learn, grow and lead with other female entrepreneurs',
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
}