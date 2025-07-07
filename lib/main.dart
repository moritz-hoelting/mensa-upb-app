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
    final seedColor = Color.fromARGB(255, 27, 43, 147);

    return ChangeNotifierProvider(
      create: (context) => UserSelectionModel(),
      child: MaterialApp(
        // Application name
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,
        // Application theme data, you can set the colors for the application as
        // you want
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            primary: Color.fromARGB(255, 37, 70, 183),
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // A widget which will be started on application startup
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    final userSelection =
        Provider.of<UserSelectionModel>(context, listen: false);

    _tabController = TabController(
      length: 8,
      vsync: this,
      initialIndex: _dateToIndex(userSelection.selectedDay),
    );

    userSelection.addListener(() {
      final tabIndex = _dateToIndex(userSelection.selectedDay);
      if (_tabController.index != tabIndex &&
          tabIndex >= 0 &&
          tabIndex < _tabController.length) {
        _tabController.animateTo(tabIndex);
      }
    });

    _tabController.addListener(() {
      final userSelection =
          Provider.of<UserSelectionModel>(context, listen: false);
      if (_dateToIndex(userSelection.selectedDay) != _tabController.index) {
        userSelection.selectedDay = DateUtils.dateOnly(DateTime.now())
            .add(Duration(days: _tabController.index));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
      bottomNavigationBar: DateSelectionBottomBar(
        tabController: _tabController,
      ),
      body: HomePageBody(tabController: _tabController),
    );
  }

  int _dateToIndex(DateTime date) {
    return date.difference(DateUtils.dateOnly(DateTime.now())).inDays;
  }
}
