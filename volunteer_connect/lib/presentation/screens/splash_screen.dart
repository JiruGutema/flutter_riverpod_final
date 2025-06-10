import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/presentation/screens/login_screen.dart';
import 'package:volunteer_connect/presentation/screens/organization_home.dart';
import 'package:volunteer_connect/presentation/screens/volunteer_home.dart';
import '../../../application/providers/auth_provider.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isLoggedIn = await ref.read(authProvider.notifier).tryAutoLogin();
    final user = ref.read(authProvider).user;

    if (!isLoggedIn || user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    // Navigate based on role
    if (user.role == 'Organization') { // check if the Organization role is in the same capitalization. it could be role=organization
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrganizationHomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VolunteerHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
