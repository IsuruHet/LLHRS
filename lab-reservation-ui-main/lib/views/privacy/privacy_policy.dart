import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Last Updated: 2024/09/01',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Welcome to the Lab and Lecture Hall Reservation System app. We are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and protect your information.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle(context, '1. Information We Collect'),
            _buildSectionBody(context, '''
- Personal Information: Name, email, and contact details when you create an account.
- Usage Data: Device type, IP address, and activity within the app.
- Firebase Data: We use Firebase for authentication and data storage.
'''),
            _buildSectionTitle(context, '2. How We Use Your Information'),
            _buildSectionBody(context, '''
- Provide Services: Manage reservations and improve app functionality.
- Communications: Send updates and notifications.
- Security: Monitor and protect your account.
'''),
            _buildSectionTitle(context, '3. Information Sharing'),
            _buildSectionBody(context, '''
- Consent: We share your data only with your permission.
- Service Providers: We may share data with Firebase for app functionality.
- Legal Requirements: We may disclose data if required by law.
'''),
            _buildSectionTitle(context, '4. Data Security'),
            _buildSectionBody(context, '''
We take steps to protect your information, but no method is 100% secure.
'''),
            _buildSectionTitle(context, '5. Your Rights'),
            _buildSectionBody(context, '''
- Access: Request access to your information.
- Correction: Request corrections.
- Deletion: Request deletion of your information.
'''),
            _buildSectionTitle(context, '6. Changes to This Policy'),
            _buildSectionBody(context, '''
We may update this policy and will notify you of significant changes.
'''),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildSectionBody(BuildContext context, String body) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        body,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
