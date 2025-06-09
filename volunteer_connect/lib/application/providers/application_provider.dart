import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_connect/domain/models/application_model.dart';
import 'package:volunteer_connect/infrastructure/data_sources/api_client.dart';

final applicationProvider = FutureProvider<List<ApplicationModel>>((ref) async {
  final response = await ApiClient.get('/myApplication');
  final List<dynamic> data = response.data['events'];
  return data.map((e) => ApplicationModel.fromJson(e)).toList();
});
