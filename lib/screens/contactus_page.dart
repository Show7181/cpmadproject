import 'package:flutter/material.dart';
import 'map_page.dart';

import 'package:url_launcher/url_launcher.dart';

final Uri _emailUri = Uri(
  scheme: 'mailto',
  path: 'contactNYP@nyp.edu.sg', 
 queryParameters: {'subject': 'Subject', 'body': 'Hello, this is the body of the email.'},
);
final Uri _phoneUri = Uri.parse('tel:68886888');
class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
  
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title with a more attractive font style
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 30), 

           
              const Text(
                'We would love to hear from you! Click the button below to find our location.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
                 const Text(
                'Telephone:',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
               const TextButton(
              onPressed: _launchPhoneCall,
              child: Text('6888 6888',style: TextStyle(fontSize: 20),),
            ),
              
              const SizedBox(height: 40), 
  const Text(
                'Email:',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
               const TextButton(
                onPressed:
               _launchEmail,
              
              child:
              Text('contactNYP@nyp.edu.sg',style: TextStyle(fontSize: 20),)),
              ElevatedButton(
                onPressed: () {
                  // Navigate to MapPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button background color
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Go to Map'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



Future<void> _launchEmail() async {
  if (!await canLaunchUrl(_emailUri)) {
    throw Exception('Could not launch email');
  } else {
    await launchUrl(_emailUri);
  }
}

Future<void> _launchPhoneCall() async {
  if (!await canLaunchUrl(_phoneUri)) {
    throw Exception('Could not launch phone call');
  } else {
    await launchUrl(_phoneUri);
  }
}

