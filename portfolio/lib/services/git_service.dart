import 'package:url_launcher/url_launcher.dart';

class GitHubService {
  static const String _profileUrl =
      'https://github.com/sakshi-bonage';

  static Future<void> launchProfile() async {
    final Uri url = Uri.parse(_profileUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open GitHub';
    }
  }
}