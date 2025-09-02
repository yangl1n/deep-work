import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';
Future<void> openWeChatApp() async {
  const weChatScheme = 'weixin://'; // WeChat app scheme
  final uri = Uri.parse(weChatScheme);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print('WeChat is not installed or cannot be opened.');
  }
}
String formatTime(dynamic timestamp) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp as int);
      return DateFormat("h:mm a").format(date); // e.g. "8:00 PM"
    } catch (e) {
      return "";
    }
  }
