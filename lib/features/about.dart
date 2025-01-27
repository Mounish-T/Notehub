import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 117, 182, 214),
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notehub',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Notehub is a powerful note-taking application designed to help you capture and organize your thoughts, ideas, and inspirations. It provides a seamless experience for creating, editing, and managing your notes effectively.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Key Features:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              _buildFeatureItem(context, Icons.notes, 'Effortless Note Creation'),
              _buildFeatureItem(context, Icons.cloud_upload, 'Secure Cloud Storage with Firebase and Cloudinary'),
              _buildFeatureItem(context, Icons.design_services, 'User-Friendly Interface'),
              _buildFeatureItem(context, Icons.security, 'Robust Email/Password Authentication'),
              _buildFeatureItem(context, Icons.delete, 'Create, Edit, and Delete Notes'),
              _buildFeatureItem(context, Icons.offline_bolt, 'Partial Offline Access'),
              const SizedBox(height: 16.0),
              Text(
                'Built With:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  FlutterLogo(size: 24.0),
                  const SizedBox(width: 8.0),
                  Text('Flutter', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/firebase.png', // Path to your Firebase icon
                    height: 24.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text('Firebase', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/cloudinary.jpg', // Path to your Cloudinary icon
                    height: 24.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text('Cloudinary', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Version: ${snapshot.data!.version} + ${snapshot.data!.buildNumber}',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
    );
  }
}