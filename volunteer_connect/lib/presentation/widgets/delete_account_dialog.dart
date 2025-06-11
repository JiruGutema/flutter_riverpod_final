// lib/presentation/widgets/delete_account_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/profile_provider.dart';
import '../../infrastructure/storage/secure_storage.dart';
import '../screens/login_screen.dart';

Future<void> showDeleteAccountDialog({
  required BuildContext context,
  required WidgetRef ref,
  required int userId,
}) {
  final dialogContext = context;

  return showDialog<void>(
    context: context,
    useRootNavigator: true,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Account'),
      content: const Text(
        'Are you sure you want to delete your account? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () async {
            Navigator.of(ctx).pop();
            bool deleted = false;
            try {
              await ref.read(profileRepositoryProvider).deleteProfile(userId);
              deleted = true;
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Delete error: $e')),
              );
            }
            await SecureStorage.clearAll();
            // navigate using root navigator
            Navigator.of(dialogContext, rootNavigator: true)
                .pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
            );
            if (deleted) {
              ScaffoldMessenger.of(dialogContext).showSnackBar(
                const SnackBar(content: Text('Account deleted successfully.')),
              );
            }
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
