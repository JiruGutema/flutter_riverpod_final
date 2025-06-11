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
    final user = await ref.read(authProvider.notifier).tryAutoLogin();

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }


    final role = user.role.toLowerCase();
    print('User role (lowercase): $role');

    if (role == 'organization') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrganizationHomePage()),
      );
    } else if (role == 'volunteer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VolunteerHomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
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
