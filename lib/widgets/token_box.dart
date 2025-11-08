import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TokenBox extends StatelessWidget {
  final String token;

  const TokenBox({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        token.isNotEmpty ? token : "No token found",
        style: GoogleFonts.lato(
          fontSize: 13,
          color: const Color(0xFF212121),
          height: 1.5,
        ),
      ),
    );
  }
}
