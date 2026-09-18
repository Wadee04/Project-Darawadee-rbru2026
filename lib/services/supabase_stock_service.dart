import 'package:supabase_flutter/supabase_flutter.dart';

// ============================================================
// SupabaseStockService — เพิ่ม / อ่าน / อัปเดต สต็อก
// ============================================================
class SupabaseStockService {
  SupabaseStockService._();
  static final SupabaseStockService instance = SupabaseStockService._();

  final _db = Supabase.instance.client;

  // ---- อ่านรายการสต็อกของคลินิก ----------------------------------
  Future<List<Map<String, dynamic>>> getStock({String? clinicId}) async {
    var query = _db.from('stock').select();
    if (clinicId != null) {
      query = query.eq('clinic_id', clinicId);
    }
    final res = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res as List);
  }

  // ---- เพิ่มรายการสต็อกใหม่ ---------------------------------------
  Future<Map<String, dynamic>> addProduct({
    required String name,
    required String sku,
    required int qty,
    required String unit,
    String? note,
    String? clinicId,
  }) async {
    final res = await _db
        .from('stock')
        .insert({
          'name': name,
          'sku': sku,
          'quantity': qty,
          'unit': unit,
          'note': note,
          'clinic_id': clinicId,
        })
        .select()
        .single();
    return Map<String, dynamic>.from(res as Map);
  }

  // ---- อัปเดตจำนวนสต็อก -------------------------------------------
  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    await _db.from('stock').update({'quantity': quantity}).eq('id', productId);
  }
}
