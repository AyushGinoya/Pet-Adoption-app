import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Last updated: May 28, 2024',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Interpretation and Definitions',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Interpretation',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Definitions',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'For the purposes of this Privacy Policy:',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Account means a unique account created for You to access our Service or parts of our Service.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Application refers to Pet Nest, the software program provided by the Company.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to ayushginoya72@gmail.com, +91 9510192198.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Country refers to: Gujarat, India.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Personal Data is any information that relates to an identified or identifiable individual.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Service refers to the Application.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).',
                  style: TextStyle(
                    fontFamily: 'AppFont',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.',
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
