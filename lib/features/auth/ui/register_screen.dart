import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_notifier.dart';
import 'package:impact_hub/features/auth/auth_validators.dart';
import '../../../widgets/primary_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

Future<void> _onSubmit() async {
  if (!_formKey.currentState!.validate()) return;

  final notifier = ref.read(authNotifierProvider.notifier);

  final location = _locationCtrl.text.trim().isEmpty
      ? null
      : _locationCtrl.text.trim();

  await notifier.register(
    name: _nameCtrl.text.trim(),
    email: _emailCtrl.text.trim(),
    password: _passwordCtrl.text.trim(),
    location: location, // ✅ null-safe
  );

  final state = ref.read(authNotifierProvider);

  if (state.auth != null && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful!')),
    );
    Navigator.pushReplacementNamed(context, '/home');
  } else if (state.error != null && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.error!)),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Join ImpactHub today',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    if (authState.error != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFfee2e2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Color(0xFF991b1b)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                authState.error!,
                                style: const TextStyle(
                                  color: Color(0xFF991b1b),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Name
                          const Text(
                            'Full Name',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameCtrl,
                            validator: (v) =>
                                v == null || v.trim().isEmpty ? 'Name required' : null,
                            decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.person, color: Color(0xFF00796B)),
                              hintText: 'John Doe',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Email
                          const Text(
                            'Email Address',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                            decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.email, color: Color(0xFF00796B)),
                              hintText: 'you@example.com',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password
                          const Text(
                            'Password',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: !_showPassword,
                            validator: validatePassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color(0xFF00796B)),
                              suffixIcon: IconButton(
                                icon: Icon(_showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => setState(
                                    () => _showPassword = !_showPassword),
                              ),
                              hintText: '••••••••',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password
                          const Text(
                            'Confirm Password',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confirmCtrl,
                            obscureText: !_showConfirm,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Confirm your password';
                              }
                              if (v != _passwordCtrl.text.trim()) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: Color(0xFF00796B)),
                              suffixIcon: IconButton(
                                icon: Icon(_showConfirm
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => setState(
                                    () => _showConfirm = !_showConfirm),
                              ),
                              hintText: '••••••••',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Location
                          const Text(
                            'Location (Optional)',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _locationCtrl,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_on_outlined,
                                  color: Color(0xFF00796B)),
                              hintText: 'City, Country',
                            ),
                          ),
                          const SizedBox(height: 24),

                          PrimaryButton(
                            label: authState.isLoading
                                ? 'Creating account...'
                                : 'Sign Up',
                            fullWidth: true,
                            loading: authState.isLoading,
                            onPressed: _onSubmit,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        SizedBox(width: 12),
                        Text('Or sign up with',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(width: 12),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Google Sign-Up coming soon')));
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Google'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),

                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text(
                        'Already have an account? Sign in',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00796B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
