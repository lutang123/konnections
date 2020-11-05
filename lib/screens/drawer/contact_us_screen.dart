import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:konnections/app/widgets/contact_us.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, size: 30),
            color: Theme.of(context).buttonColor),
      ),
      body: Center(
        child: ContactUs(
          cardColor: Colors.white60,
          companyColor: Theme.of(context).cursorColor,
          taglineColor: Colors.black87,
          textColor: Colors.black87,
          companyName: 'KONNECTIONS',
          website:
              'https://play.google.com/store/apps/details?id=com.konnectionsconcepts.konnections&hl=en_CA',
          twitterHandle: 'iMomentumApp',
          facebookHandle: 'IMomentumApp-110094130895280/',
          instagram: 'imomentum_app/',
          githubUserName: 'lutang123',
          linkedinURL: 'https://www.linkedin.com/in/lutang123/',
        ),
      ),
    );
  }
}
