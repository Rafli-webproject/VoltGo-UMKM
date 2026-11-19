import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Class AppColors menampung semua kode warna (Hex) aplikasi
class AppColors {
  static const Color primary = Color(0xFF2563EB); // Biru Utama (Tombol, AppBar)
  static const Color secondary = Color(0xFF0F172A); // Navy Gelap (Teks Utama)
  static const Color background = Color(0xFFF1F5F9); // Abu-abu Terang (Latar)
  static const Color surface = Color(0xFFFFFFFF); // Putih (Kartu/Input)
  static const Color error = Color(0xFFEF4444); // Merah (Pesan Error)
  static const Color success = Color(0xFF10B981); // Hijau (Pesan Sukses)
}

class AppTheme {
  // Mendefinisikan tema terang (Light Theme)
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background, // Warna latar aplikasi
      textTheme: GoogleFonts.interTextTheme(), // Menggunakan font Inter dari Google
      // Mengatur gaya default untuk tombol ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Sudut membulat
          ),
          padding: const EdgeInsets.symmetric(vertical: 16), // Tinggi tombol
        ),
      ),
    );
  }
}