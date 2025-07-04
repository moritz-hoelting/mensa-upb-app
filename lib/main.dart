import 'package:flutter/material.dart';
import 'package:mensa_upb/date_selection_bottom_bar.dart';
import 'package:mensa_upb/drawer.dart';
import 'package:mensa_upb/home_page_body.dart';
import 'package:mensa_upb/l10n/app_localizations.dart';
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
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 27, 43, 147),
          primary: Color.fromARGB(255, 37, 70, 183),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // A widget which will be started on application startup
      home: ChangeNotifierProvider(
        create: (context) => UserSelectionModel(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.appTitle,
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
