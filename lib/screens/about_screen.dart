
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Recipe Explorer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Profile Photo
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.orange,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile.jpg',
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: 130,
                      height: 130,
                      child: Center(
                        child: Text(
                          'Image not found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'MAHMUD MD KAWSAR',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Student ID: 2024891027',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Recipe Explorer',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Discover delicious recipes from around the world. '
              'Explore different food categories, search for meals, '
              'view ingredients and cooking instructions, and save '
              'your favorite recipes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            const Divider(),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'App Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            featureItem(
              Icons.restaurant_menu,
              'Browse food categories',
            ),

            featureItem(
              Icons.search,
              'Search for recipes',
            ),

            featureItem(
              Icons.menu_book,
              'View ingredients and instructions',
            ),

            featureItem(
              Icons.favorite,
              'Save favorite recipes',
            ),

            featureItem(
              Icons.shuffle,
              'Discover a random meal',
            ),

            const SizedBox(height: 20),

            const Divider(),

            const Text(
              'Developed as a Flutter Final Project',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Recipe data provided by TheMealDB API',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              '© 2026 Recipe Explorer',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget featureItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.orange,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
