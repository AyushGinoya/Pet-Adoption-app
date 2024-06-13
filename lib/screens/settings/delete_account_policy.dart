import 'package:flutter/material.dart';

class DeleteAccountPolicy extends StatelessWidget {
  const DeleteAccountPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account Policy'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFE6E6FA),
          ),
          Container(
            color:
                Colors.black.withOpacity(0.5), // Dark overlay for readability
          ),
          const SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Overview',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'We respect our users\' right to privacy and their ability to control their personal information. This policy outlines the procedures for deleting user accounts on our platform.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Steps for Account Deletion',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Accessing the Delete Account Feature:',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '   - Users can access the account deletion feature within the app settings under the "Profile" section.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '   - A clear and easily accessible "Delete Account" option will be available.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '2. Processing the Deletion:',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '   - Upon Delete account button clicked, the account and associated data will be permanently deleted from our servers.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '   - The deletion process will be completed within some seconds.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Data Retention Post Deletion',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  ' - Some data may be retained for a period due to legal or regulatory requirements. This includes:',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '   - Transactional records',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '   - Compliance with law enforcement requests',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  ' - Retained data will be securely stored and anonymized where possible.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Reinstating Deleted Accounts',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  ' - Once an account is deleted, it cannot be reinstated. Users wishing to use our services again will need to create a new account.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Contact Information',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  ' - Users with questions or issues regarding account deletion can contact ayushginoya72@hmail.com.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Policy Changes',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  ' - We reserve the right to update this policy as necessary. Users will be informed of any significant changes through the app and/or via email.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Compliance',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  ' - Our account deletion process complies with applicable data protection regulations and Google Play Store policies.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  ' - For more detailed guidelines, you can refer to https://docs.google.com/document/d/12v5Eni9ntgc-U4DJpv4qNs2P1VsRADDEvIDzHKk9U8w/edit.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
