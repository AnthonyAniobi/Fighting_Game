import 'package:flame/events.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppCreditsScreen extends StatelessWidget {
  const AppCreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Credits')),
      body: Column(
        children: [
          Text(
            'List of people who contributed to the app development, design',
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      'https://res.cloudinary.com/aniobi/image/upload/c_thumb,w_200,g_face/v1771947713/Fighting%20Game/credits/coding_section_logo_nyfcgc.png',
                    ),
                  ),
                  title: Text('Anthony (Coding Section)'),
                  subtitle: Text('Developer, Designer'),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text:
                  "if you notice any bugs in the app please raise an issue on github and it would be resolved.",
              style: TextStyle(fontSize: 14, color: Colors.white),
              children: [
                TextSpan(
                  text: ' Github: github.com/AnthonyAniobi/Fighting_Game ',
                  recognizer: TapGestureRecognizer()..onTap = openGithub,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }

  void openGithub() async {
    if (await canLaunchUrl(
      Uri.parse('https://github.com/AnthonyAniobi/Fighting_Game'),
    )) {
      await launchUrl(
        Uri.parse('https://github.com/AnthonyAniobi/Fighting_Game'),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
