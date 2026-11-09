import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class RegistrationData {
  static String? email;
  static String? password;
  static String? fullName;
}
