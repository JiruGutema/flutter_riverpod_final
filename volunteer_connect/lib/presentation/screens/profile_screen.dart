import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_provider.dart';
import 'organization_profie_screen.dart';
import 'volunteer_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated || auth.user == null) {
      return const Scaffold(body: Center(child: Text('Please log in')));
    }
    final user = auth.user!;
    return user.role == 'Organization'
        ? OrganizationProfileScreen(userId: user.id)
        : VolunteerProfileScreen(userId: user.id);
  }
}
