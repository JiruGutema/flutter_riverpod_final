import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/providers/profile_provider.dart';
import '../../domain/models/profile_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final Profile profile;
  const EditProfileScreen({required this.profile, Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _name, _email, _city, _phone, _bio;
  late TextEditingController _eventsCtrl, _hoursCtrl;
  late List<String> _skills, _interests;
  final _newSkill = TextEditingController();
  final _newInterest = TextEditingController();

  @override
  void initState() {
    super.initState();
    final u = widget.profile;
    _name = TextEditingController(text: u.name);
    _email = TextEditingController(text: u.email);
    _city = TextEditingController(text: u.city);
    _phone = TextEditingController(text: u.phone);
    _bio = TextEditingController(text: u.bio);
    _eventsCtrl =
        TextEditingController(text: u.attendedEvents.toString());
    _hoursCtrl =
        TextEditingController(text: u.hoursVolunteered.toString());
    _skills = List.from(u.skills);
    _interests = List.from(u.interests);
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
      bio: _bio.text,
      attendedEvents: int.tryParse(_eventsCtrl.text) ?? 0,
      hoursVolunteered: int.tryParse(_hoursCtrl.text) ?? 0,
      skills: _skills,
      interests: _interests,
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
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name, Email, City, Phone
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
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

            const SizedBox(height: 16),
            // Bio
            TextFormField(
              controller: _bio,
              decoration: const InputDecoration(labelText: 'Bio'),
              maxLines: 3,
            ),

            const SizedBox(height: 16),
            // Stats: Events & Hours


            const SizedBox(height: 24),
            // Skills
            const Text('Skills', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: _skills
                  .map((s) => InputChip(
                label: Text(s),
                onDeleted: () => setState(() => _skills.remove(s)),
              ))
                  .toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newSkill,
                    decoration: const InputDecoration(hintText: 'Add skill'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final v = _newSkill.text.trim();
                    if (v.isNotEmpty) {
                      setState(() {
                        _skills.add(v);
                        _newSkill.clear();
                      });
                    }
                  },
                )
              ],
            ),

            const SizedBox(height: 24),
            // Interests
            const Text('Interests',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: _interests
                  .map((i) => InputChip(
                label: Text(i),
                onDeleted: () => setState(() => _interests.remove(i)),
              ))
                  .toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newInterest,
                    decoration:
                    const InputDecoration(hintText: 'Add interest'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final v = _newInterest.text.trim();
                    if (v.isNotEmpty) {
                      setState(() {
                        _interests.add(v);
                        _newInterest.clear();
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
