import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';
import '../../constants/appname.dart';

class OtherTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final String package;
  static const Icon icon = Icon(Icons.question_mark, size: 32);

  const OtherTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.package
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
                app: AppName.NOTFOUND,
                package: package
              ),
            ),
          );
        },
      );
  }
}