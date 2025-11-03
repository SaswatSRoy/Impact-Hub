import 'package:flutter/material.dart';
import 'package:impact_hub/features/shared/shared_models.dart';

class EventPreviewCard extends StatelessWidget {
  final EventModel event;

  const EventPreviewCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/events/${event.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: event.image != null
                  ? Image.network(event.image!, fit: BoxFit.cover)
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.event, size: 48)),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(fmtDateShort(event.startDate)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
