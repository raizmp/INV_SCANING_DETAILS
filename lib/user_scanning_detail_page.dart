
import 'package:flutter/material.dart';

class UserScanningDetailPage extends StatelessWidget {
  final Map<String, dynamic> scan;

  const UserScanningDetailPage({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    final sectionsList = scan['sections'] as List<dynamic>? ?? [];

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
            sectionsList.isEmpty
                ? const Center(child: Text('No sections available'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: sectionsList.length,
                      itemBuilder: (context, index) {
                        final section = sectionsList[index] as Map<String, dynamic>;
                        final sectionName = section['section'] as String? ?? '';
                        final comment = section['comment'] as String? ?? '';
                        final image = section['image'] as String?;
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
                            trailing: image != null
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImagePage(
                                            imageUrl: 'https://www.talalgroupintl.com/stk_info_api/$image',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      'https://www.talalgroupintl.com/stk_info_api/$image',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : null,
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

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CircularProgressIndicator(
              color: Colors.white,
            );
          },
          errorBuilder: (context, error, stackTrace) => const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.grey, size: 48),
              SizedBox(height: 16),
              Text(
                'Failed to load image',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
