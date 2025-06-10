import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/providers/profile_provider.dart';
import '../../domain/models/profile_model.dart';

class EditOrganizationProfileScreen extends ConsumerStatefulWidget {
  final Profile profile;
  const EditOrganizationProfileScreen({required this.profile, Key? key})
      : super(key: key);

  @override
  ConsumerState<EditOrganizationProfileScreen> createState() =>
      _EditOrgProfileState();
}

class _EditOrgProfileState
    extends ConsumerState<EditOrganizationProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _name, _email, _city, _phone;
  late List<String> _domains;
  final _newDomain = TextEditingController();

  @override
  void initState() {
    super.initState();
    final u = widget.profile;
    _name = TextEditingController(text: u.name);
    _email = TextEditingController(text: u.email);
    _city = TextEditingController(text: u.city);
    _phone = TextEditingController(text: u.phone);
    // use skills field for domains
    _domains = List.from(u.skills);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = ref.read(authProvider);
    final updated = Profile(
      id: widget.profile.id,
      name: _name.text,
      email: _email.text,
      role: widget.profile.role,
      city: _city.text,
      phone: _phone.text,
      bio: widget.profile.bio,
      attendedEvents: widget.profile.attendedEvents,
      hoursVolunteered: widget.profile.hoursVolunteered,
      skills: _domains,
      interests: widget.profile.interests,
    );

    await ref
        .read(profileRepositoryProvider)
        .updateProfile(auth.user!.id, updated);
    // 2) invalidate (or refresh) the cached profileProvider so it re-fetches
    ref.invalidate(profileProvider(auth.user!.id));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Organization')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Organization Name, Email, City, Phone
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _city,
              decoration: const InputDecoration(labelText: 'City'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),

            const SizedBox(height: 24),
            // Domains
            const Text('Domains', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: _domains
                  .map((d) => InputChip(
                label: Text(d),
                onDeleted: () => setState(() => _domains.remove(d)),
              ))
                  .toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newDomain,
                    decoration: const InputDecoration(hintText: 'Add domain'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final v = _newDomain.text.trim();
                    if (v.isNotEmpty) {
                      setState(() {
                        _domains.add(v);
                        _newDomain.clear();
                      });
                    }
                  },
                )
              ],
            ),

            const SizedBox(height: 32),
            ElevatedButton(onPressed: _save, child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
