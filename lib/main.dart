import 'package:flutter/material.dart';

import 'gui/pages/title_page.dart';
import 'gui/pages/machine_page.dart';
import 'gui/pages/levels_page.dart';

class HrvmApp extends StatefulWidget {
  const HrvmApp({super.key});

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<HrvmApp> {
  late GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _navigatorKey = GlobalKey();
  }

  Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      "/title": (context) => TitlePage(),
      "/levels": (context) => LevelsPage(this),
      "/machine": (context) => MachinePage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      routes: getRoutes(),
      initialRoute: "/machine",
    );
  }
}

void main() {
  runApp(const HrvmApp());
}
