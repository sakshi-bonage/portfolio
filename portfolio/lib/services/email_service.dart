import 'package:url_launcher/url_launcher.dart';

class EmailService {
  static Future<void> sendEmail({
    required String name,
    required String message,
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'sakshibonage22@gmail.com',
      queryParameters: {
        'subject': 'Portfolio Inquiry from $name',
        'body': message,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email client';
    }
  }
}