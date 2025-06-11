
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/auth_provider.dart';
import '../../../infrastructure/core/dio_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final VoidCallback? onPostCreated;

  const CreatePostScreen({super.key, this.onPostCreated});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final locationController = TextEditingController();
  final spotsLeftController = TextEditingController();
  final descriptionController = TextEditingController();
  final requirementController = TextEditingController();
  final additionalInfoController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final telegramController = TextEditingController();

  File? selectedImage;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final token = ref.read(authProvider).token;
 

    final data = {
      "title": titleController.text,
      "subtitle": subtitleController.text,
      "category": categoryController.text,
      "date": dateController.text,
      "time": timeController.text,
      "location": locationController.text,
      "spotsLeft": int.tryParse(spotsLeftController.text) ?? 0,
      "image": "assets/image.png", // placeholder
      "description": descriptionController.text,
      "requirements": {
        "Free from Disease": requirementController.text.toLowerCase() == 'true',
      },
      "additionalInfo": {
        "Cross": "Hospital",
        "Note": additionalInfoController.text,
      },
      "contactPhone": phoneController.text,
      "contactEmail": emailController.text,
      "contactTelegram": telegramController.text,
    };

    final dio = ref.read(dioProvider);
    try {
      final response = await dio.post(
        "/api/events/create",
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully.')),
        );
        widget.onPostCreated?.call();
      } else {
        throw Exception("Unexpected response: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $e')),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    categoryController.dispose();
    dateController.dispose();
    timeController.dispose();
    locationController.dispose();
    spotsLeftController.dispose();
    descriptionController.dispose();
    requirementController.dispose();
    additionalInfoController.dispose();
    phoneController.dispose();
    emailController.dispose();
    telegramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(controller: titleController, decoration: _inputDecoration('Title')),
                const SizedBox(height: 12),
                TextFormField(controller: subtitleController, decoration: _inputDecoration('Subtitle')),
                const SizedBox(height: 12),
                TextFormField(controller: categoryController, decoration: _inputDecoration('Category')),
                const SizedBox(height: 12),
                TextFormField(controller: dateController, decoration: _inputDecoration('Date')),
                const SizedBox(height: 12),
                TextFormField(controller: timeController, decoration: _inputDecoration('Time')),
                const SizedBox(height: 12),
                TextFormField(controller: locationController, decoration: _inputDecoration('Location')),
                const SizedBox(height: 12),
                TextFormField(
                  controller: spotsLeftController,
                  decoration: _inputDecoration('Spots Left'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  decoration: _inputDecoration('Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: requirementController,
                  decoration: _inputDecoration('Requirement'),
                ),
                const SizedBox(height: 12),
                TextFormField(controller: additionalInfoController, decoration: _inputDecoration('Additional Info')),
                const SizedBox(height: 12),
                TextFormField(controller: phoneController, decoration: _inputDecoration('Phone')),
                const SizedBox(height: 12),
                TextFormField(controller: emailController, decoration: _inputDecoration('Email')),
                const SizedBox(height: 12),
                TextFormField(controller: telegramController, decoration: _inputDecoration('Telegram')),
                const SizedBox(height: 20),

                // Image Upload Button
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, color: Colors.blue),
                  label: const Text('Select Image'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: Colors.blue),
                  ),
                ),
                if (selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.file(selectedImage!, height: 100),
                  ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Create Post', style: TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 12),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
