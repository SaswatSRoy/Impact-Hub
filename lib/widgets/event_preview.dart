import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/shared/shared_models.dart';

class EventPreviewCard extends StatelessWidget {
  final EventModel event;

  const EventPreviewCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 240, // ✅ fixed height to prevent vertical overflow
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/event-detail', arguments: event);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 IMAGE
                SizedBox(
                  height: 90,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: event.image != null && event.image!.isNotEmpty
                        ? Image.network(
                            event.image!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.teal.withOpacity(0.15),
                            child: const Center(
                              child: Icon(Icons.event, size: 42, color: Colors.teal),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 8),

                // 🔹 TITLE
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: const Color(0xFF004D40),
                  ),
                ),

                const SizedBox(height: 2),

                // 🔹 DATE
                Text(
                  "📅 ${event.startDate.toLocal().toString().substring(0, 10)}",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
                ),

                const SizedBox(height: 4),

                // 🔹 DESCRIPTION (limited)
                Expanded(
                  child: Text(
                    event.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.grey[600]),
                  ),
                ),

                const SizedBox(height: 4),

                // 🔹 PARTICIPANTS + CATEGORY
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people, size: 16, color: Colors.teal),
                        const SizedBox(width: 4),
                        Text(
                          '${event.participants} joined',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.category,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
