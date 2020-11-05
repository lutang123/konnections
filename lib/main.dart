import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konnections/screens/permission_screen.dart';
import 'package:konnections/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/constants/theme.dart';
import 'app/service/firestore_service/database.dart';
import 'app/service/sign_in/auth_widget.dart';
import 'app/service/sign_in/auth_widget_builder.dart';
import 'app/service/sign_in/firebase_auth_service.dart';
import 'app/service/theme_notifier.dart';

void main() async {
  // Ensure services are loaded before the widgets get loaded
  WidgetsFlutterBinding.ensureInitialized();
  // Initializing FlutterFire
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent,
  ));
  // for settings
  SharedPreferences.getInstance().then((prefs) async {
    bool isDarkTheme = prefs.getBool('darkMode') ?? false;

    ///then runApp
    runApp(MultiProvider(providers: [
      // for theme
      ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(isDarkTheme ? darkTheme : lightTheme)),
    ], child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    // MultiProvider for top-level services that can be created right away
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
      ],
      // AuthWidgetBuilder and AuthWidget to check user sign in status
      child: AuthWidgetBuilder(
          userProvidersBuilder: (_, user) => [
                //anything else related with user can be added here
                Provider<Database>(
                  create: (_) => FirestoreDatabase(uid: user.uid),
                ),
              ],
          builder: (context, userSnapshot) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Konnections',
                theme: themeNotifier.getTheme(),
                darkTheme: darkTheme,
                themeMode: ThemeMode.system,
                home: AuthWidget(
                  userSnapshot: userSnapshot,
                  nonSignedInBuilder: (_) => SignInScreen(),
                  signedInBuilder: (_) => PermissionScreen(),
                ));
          }),
    );
  }
}
