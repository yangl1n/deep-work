import 'package:flutter/material.dart';
import '../../utils.dart';
import '../../models/interupts.dart';
import 'package:provider/provider.dart';
import '../../services/other_storage.dart';
class ChatDetailScreen extends StatelessWidget {
  final String app;
  final String package;
  const ChatDetailScreen({
    super.key,
    required this.app,
    required this.package
  });

  @override
  Widget build(BuildContext context) {
    final interupts = context.watch<InteruptsModel>();

    final details = interupts.other_notifications.firstWhere(
          (e) => e["package"] == package,
          orElse: () => {"details": []},
        )["details"] ?? [];
    return Scaffold(
      appBar: AppBar(title: Text("$package on $app"),
              actions: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    tooltip: "Delete",
                    onPressed: () async {
                      await OtherStorageService.deleteNotifications(package);
            
                    }
                    
                  )]
    ),
      body: ListView.builder(
        //padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        itemCount: details.length,
        itemBuilder: (context, index) {
          final msg = details[index];
          final text = msg["text"] ?? "unknown";
          final when = formatTime(msg["when"]);
          final meta = msg["meta"] ?? {};

          return GestureDetector(
            onTap: () {
              if (meta.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Meta Data"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: meta.entries
                          .map<Widget>((e) => Text("${e.key}: ${e.value}"))
                          .toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Text content
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18, right: 60),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  // Time at bottom-right
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      when,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
