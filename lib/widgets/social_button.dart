import 'package:flutter/material.dart';
import 'package:iug/helpers/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.url,
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final String url;
  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: TextButton(
        onPressed: () => url == "http://public@iugaza.edu.ps"
            ? sendEmail(url)
            : _launchURL(url),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(3),
          minimumSize: MaterialStateProperty.all(Size(200, 80)),
          overlayColor: MaterialStateProperty.all(Colors.grey[100]),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Color(0xFF000028)),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 10, horizontal: 50)),
          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 24)),
        ),
        child: Center(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style:
                        normalText(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  void _launchURL(url) async => await canLaunchUrl(Uri.parse(url))
      ? await launchUrl(Uri.parse(url))
      : throw 'Could not launch $url';
  void sendEmail(url) => _launchURL('mailto:$url');
}
