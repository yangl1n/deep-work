import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;
class RingtonePickerScreen extends StatefulWidget {
  const RingtonePickerScreen({super.key});

  @override
  State<RingtonePickerScreen> createState() => _RingtonePickerScreenState();
}

class _RingtonePickerScreenState extends State<RingtonePickerScreen> {
  static const MethodChannel _channel = MethodChannel('com.example.deepwork/rings');

  List<Map<String, String>> ringtones = [];
  String? selectedUri;
  String? playingUri;

  @override
  void initState() {
    super.initState();
    _loadRingtones();
  }

  Future<void> _loadRingtones() async {
    try {
      // 1. Load system ringtones
      final ringtonesStr = await _channel.invokeMethod<String>('getSystemRingtones');
      List<Map<String, String>> loaded = [];
      if (ringtonesStr != null) {
        final List<dynamic> list = jsonDecode(ringtonesStr);
        loaded = list.map<Map<String, String>>((e) {
          final map = e as Map<String, dynamic>;
          return {
            "title": map["title"]?.toString() ?? "Unknown",
            "uri": map["uri"]?.toString() ?? "",
          };
        }).toList();
      }

      // 2. Load saved ringtone
      final savedJsonStr = await _channel.invokeMethod<String>('getSavedRingtone');
      if (savedJsonStr != null) {
        final Map<String, dynamic> savedMap = jsonDecode(savedJsonStr);
        final savedUri = savedMap['uri']?.toString() ?? '';
        final savedTitle = savedMap['title']?.toString() ?? 'Custom Music';
        selectedUri = savedUri;

        // If not in system list, add it
        final exists = loaded.any((r) => r['uri'] == savedUri);
        if (!exists) {
          loaded.insert(0, {
            "title": savedTitle,
            "uri": savedUri,
          });
        }
      }

      setState(() {
        ringtones = loaded;
      });
    } catch (e) {
      debugPrint('Error loading ringtones: $e');
    }
  }



  Future<void> _playRingtone(String? uri) async {
    if (uri == null || uri.isEmpty) return;

    try {
      if (playingUri == uri) {
        // toggle stop
        await _channel.invokeMethod('stopMusic');
        setState(() => playingUri = null);
      } else {
        await _channel.invokeMethod('playMusic', {'uri': uri});
        setState(() => playingUri = uri);
      }
    } catch (e) {
      debugPrint('Error playing ringtone: $e');
    }
  }

  Future<void> _saveRingtone(String? uri, String? title) async {
    if (uri == null || uri.isEmpty) return;

    try {
      await _channel.invokeMethod('saveRingtone', {
        'uri': uri,
        'title': title ?? 'Custom Music',
      });
      final exists = ringtones.any((r) => r['uri'] == uri);
      if (!exists) {
        await _loadRingtones(); // refresh list
      }
      else {
        setState(() { selectedUri = uri; });
      }
    } catch (e) {
      debugPrint('Error saving ringtone: $e');
    }
  }



  Future<void> _pickCustomFile() async {
    _channel.invokeMethod('stopMusic'); // stop any preview
    Fluttertoast.showToast(
      msg: "Allowed only .mp3, .wav and .m4a",
      toastLength: Toast.LENGTH_SHORT,
    );

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a'], // restrict extensions
      );

      if (result != null && result.files.single.path != null) {
        final uri = result.files.single.path!;
        final name = p.basename(uri); // extract filename
        debugPrint('pick: $uri ($name)');

        await _playRingtone(uri);
        await _saveRingtone(uri, name); // pass name to save function

        // reload the list to show the newly saved file
        await _loadRingtones();
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }


  @override
  void dispose() {
    _channel.invokeMethod('stopMusic'); // stop any preview
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Ringtone")),
      body: ListView.builder(
        itemCount: ringtones.length + 1, // +1 for custom file picker
        itemBuilder: (context, index) {
          if (index == ringtones.length) {
            // Custom file picker
            return ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Choose from Files"),
              onTap: _pickCustomFile,
            );
          }

          final ringtone = ringtones[index];
          final isSelected = ringtone['uri'] == selectedUri;
          final isPlaying = ringtone['uri'] == playingUri;

          return ListTile(
            leading: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.blue : null,
            ),
            title: Text(ringtone['title'] ?? 'Unknown'),
            trailing: IconButton(
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              onPressed: () => _playRingtone(ringtone['uri']!),
            ),
            onTap: () => _saveRingtone(ringtone['uri']!, ringtone['title']!),
          );
        },
      ),
    );
  }
}
