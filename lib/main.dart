import 'package:flutter/material.dart';
import 'package:mensa_upb/date_selection_bottom_bar.dart';
import 'package:mensa_upb/drawer.dart';
import 'package:mensa_upb/home_page_body.dart';
import 'package:mensa_upb/user_selection.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MensaUpbApp());

class MensaUpbApp extends StatelessWidget {
  const MensaUpbApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Mensa UPB',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      // A widget which will be started on application startup
      home: ChangeNotifierProvider(
        create: (context) => UserSelectionModel(),
        child: const HomePage(title: 'Mensa UPB'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      drawer: const MensaSelectionDrawer(),
      bottomNavigationBar: const DateSelectionBottomBar(),
      body: const HomePageBody(),
    );
  }
}
