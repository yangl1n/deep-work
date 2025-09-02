import 'package:flutter/material.dart';
import 'services/interuption.dart';
import 'screens/home_screen.dart';
import 'screens/info_screen.dart';
import 'screens/about_screen.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'models/countdown.dart';
import 'models/interupts.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification listener
  Interuption.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountdownModel()),
        ChangeNotifierProvider(create: (_) => InteruptsModel()),
      ],
      child: const MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notification Listener Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    InfoScreen(),
    AboutScreen(),
  ];

  final _title = "Deep Work";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleNotificationPermission(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _title),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    Interuption.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("System Notifications")),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return ExpansionTile(
                      title: Text(n['app'] ?? "unknown"),
                      subtitle: Text(n['text'] ?? "unknown"),
                      trailing: Text(n['when'] ?? "unknown"),
                      children: n.entries.map((entry) {
                        return ListTile(
                          dense: true,
                          title: Text(entry.key),
                          subtitle: Text(entry.value?.toString() ?? "unknown"),
                        );
                      }).toList(),
                    );
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings),
        onPressed: () {
          Interuption.openSettings();
        },
      ),
    );
  }
}


Future<void> handleNotificationPermission(BuildContext context) async {
  bool granted = await Interuption.checkPermission();

  if (!granted) {
    // Show explanation dialog
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'This app needs access to your notifications in order to work properly. '
          'Please grant the permission in system settings.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop();
              Interuption.openSettings();
            },
          ),
        ],
      ),
    );
  }
}