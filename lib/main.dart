import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../pages/dashboard_page.dart';
import '../utils/shared_prefs.dart';
import '../pages/login_page.dart';
import 'utils/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  await baseDio();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    PreferencesUtil util = PreferencesUtil();

    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        title: 'Omega Dashboard',
        theme: theme,
        darkTheme: darkTheme,
        home: util.isKeyExists(PreferencesUtil.email)! &&
                util.getString(PreferencesUtil.email) != ""
            ? const DashboardPage()
            : const LoginPage(),
      ),
    );
  }
}
