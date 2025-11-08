import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_notifier.dart';
import 'package:impact_hub/features/auth/auth_validators.dart';
import '../../../widgets/primary_button.dart';
import '../../../constants/api.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
  if (!_formKey.currentState!.validate()) return;

  final email = _emailCtrl.text.trim();
  final password = _passwordCtrl.text.trim();
  final notifier = ref.read(authNotifierProvider.notifier);

  await notifier.login(email: email, password: password);

  final state = ref.read(authNotifierProvider);

  if (state.auth != null && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login successful!')),
    );
    Navigator.of(context).pushReplacementNamed('/home');
  } else if (state.error != null && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.error!)),
    );
  }
}


  Future<void> _onGoogle() async {
    final url = Uri.parse('$API_URL/auth/google');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open Google sign-in')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20, 
              ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        Text('Sign in to continue to ImpactHub', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Error Alert
                    if (authState.error != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(color: const Color(0xFFfee2e2), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Color(0xFF991b1b)),
                            const SizedBox(width: 12),
                            Expanded(child: Text(authState.error!, style: const TextStyle(color: Color(0xFF991b1b), fontWeight: FontWeight.w500))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email
                          const Align(alignment: Alignment.centerLeft, child: Text('Email Address', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email, color: Color(0xFF00796B)),
                              hintText: 'you@example.com',
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 1.5)),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password
                          const Align(alignment: Alignment.centerLeft, child: Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: !_showPassword,
                            validator: validatePassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF00796B)),
                              hintText: '••••••••',
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _showPassword = !_showPassword),
                                icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(width: 1.5)),
                            ),
                          ),
                          const SizedBox(height: 20),

                          PrimaryButton(
                            label: authState.isLoading ? 'Signing in...' : 'Sign In',
                            fullWidth: true,
                            loading: authState.isLoading,
                            onPressed: _onSubmit,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(children: const [Expanded(child: Divider()), SizedBox(width: 12), Text('Or continue with', style: TextStyle(color: Colors.grey)), SizedBox(width: 12), Expanded(child: Divider())]),
                    const SizedBox(height: 16),

                    // Google OAuth button (external redirect)
                    OutlinedButton.icon(
                      onPressed: _onGoogle,
                      icon: const Icon(Icons.login),
                      label: const Text('Google'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),

                    const SizedBox(height: 20),
                    // Footer links
                    Column(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed('/register'),
                          child: const Text("Don't have an account? Sign up", style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed('/forgot-password'),
                          child: const Text('Forgot password?', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
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
