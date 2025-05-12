import 'package:flutter/material.dart';

class UserScanningDetailPage extends StatelessWidget {
  final Map<String, dynamic> scan;

  const UserScanningDetailPage({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    final sections = scan['sections']?.split(',') ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('User: ${scan['user']}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scanning Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'User: ${scan['user']}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sections:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            sections.isEmpty
                ? const Center(child: Text('No sections available'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: sections.length,
                      itemBuilder: (context, index) {
                        final section = sections[index];
                        final match = RegExp(r'^([^()]+)(\(([^()]*)\))?$').firstMatch(section.trim());
                        final sectionName = match?.group(1)?.trim() ?? section.trim();
                        final comment = match?.group(3)?.trim() ?? '';
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.category,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(
                              comment.isNotEmpty
                                  ? '$sectionName ($comment)'
                                  : sectionName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}