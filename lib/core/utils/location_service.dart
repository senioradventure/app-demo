import 'package:supabase_flutter/supabase_flutter.dart';

class LocationService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<String>> fetchLocationNames() async {
    final response = await _client
        .from('locations')
        .select('name')
        .order('name', ascending: true);

    return (response as List).map((e) => e['name'] as String).toList();
  }
}
