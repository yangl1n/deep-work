import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';
import '../../constants/appname.dart';

class WechatTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final String who;
  static const Icon icon = Icon(Icons.wechat, size: 32);

  const WechatTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.who
  });

  @override
  Widget build(BuildContext context) {
      return ListTile(
        leading: icon,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(trailing),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailScreen(
                app: AppName.WECHAT,
                person: who
              ),
            ),
          );
        },
      );
  }
}