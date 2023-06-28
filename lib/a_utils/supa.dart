import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class Supa {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://skbpdylhugpcpimmabid.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNrYnBkeWxodWdwY3BpbW1hYmlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODI1NzA1MzgsImV4cCI6MTk5ODE0NjUzOH0.ogrKWFJCI59avIBonFM8mGssHBZ-cAlrlByoJ9KVDXg',
    );
  }
}
