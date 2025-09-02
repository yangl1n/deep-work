import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/interupts.dart';
import '../models/countdown.dart';
import '../widgets/wechat/list_tile.dart';
import '../widgets/other/list_tile.dart';
import '../widgets/uninterrupted_area.dart';
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final count_down = context.watch<CountdownModel>();
    if (count_down.isRunning) {
      return UninterruptedArea();
    }
    final interupts = context.watch<InteruptsModel>();
    final wechat_items = interupts.wechat_notifications;
    final other_items = interupts.other_notifications;
    final total_counts = wechat_items.length + other_items.length; //+ more
    return total_counts == 0
          ? const Center(child: Text("No notifications yet"))
          : ListView.builder(
              itemCount: total_counts,
              itemBuilder: (context, index) {
                if (index < wechat_items.length) {
                    final item = wechat_items[index];
                    return WechatTile(
                      title: "${item["who"]} (${item["count"]})",
                      subtitle: item["latest_text"] as String,
                      trailing: item["latest_when"] as String,
                      who: item["who"],
                    );
                }
                else if (index < wechat_items.length + other_items.length) {
                    final item = other_items[index - wechat_items.length];
                    return OtherTile(
                      title: "${item["package"]} (${item["count"]})",
                      subtitle: item["title"] as String,
                      trailing: item["latest_when"] as String,
                      package: item["package"],
                    );
                }
              },
            );
  }
}
