import 'package:senior_circle/core/utils/location_service/location_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<LocationModel>> fetchLocations() async {
    final response = await _client
        .from('locations')
        .select('id, name')
        .order('name', ascending: true);

    return (response as List)
        .map((e) => LocationModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
