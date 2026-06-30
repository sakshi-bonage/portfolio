import 'package:url_launcher/url_launcher.dart';

class LinkedInService {
  // Replace with your true LinkedIn profile path url string string
  static const String _profileUrl = 'https://www.linkedin.com/in/sakshi-bonage-6102a8347/';

  /// Launches your LinkedIn profile in an external browser app
  static Future<void> launchProfile() async {
    final Uri url = Uri.parse(_profileUrl);
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not process LinkedIn link request';
    }
  }
}
