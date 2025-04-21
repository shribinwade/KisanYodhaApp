import 'package:blackox/HomeScreen/home_screen.dart';
import 'package:blackox/Model/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:blackox/Authentication%20Screen/login_screen.dart';
import 'package:blackox/Authentication%20Screen/signup_screen.dart';
import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/Constants/orientation_utility.dart';
import 'package:blackox/Authentication%20Screen/authentication_screen.dart';
import 'package:blackox/SelectionScreen/let_started_screen.dart';
import 'package:blackox/SelectionScreen/selection_screen.dart';
import 'package:blackox/i18n/app_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Splash Screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait mode
  await OrientationUtility.lockToPortrait();

  // Load the appropriate .env file based on the mode
  // String envFile = kReleaseMode ? '.env.production' : '.env.development';

  const envFile = String.fromEnvironment('ENV', defaultValue: '.env');
  print('Loading environment file: $envFile');

  try {
    // First try to load the file
    await dotenv.load(fileName: envFile);
    print('Environment variables loaded successfully');

    // Verify the variables are loaded
    final apiUrl = dotenv.env['API_BASE_URL'];
    final mentorUrl = dotenv.env['MENTOR_BASE_URL'];
    final appName = dotenv.env['APP_NAME'];

    print('Verifying environment variables:');
    print('API_BASE_URL: $apiUrl');
    print('MENTOR_BASE_URL: $mentorUrl');
    print('APP_NAME: $appName');

    if (apiUrl == null || mentorUrl == null || appName == null) {
      print('Warning: Some environment variables are missing!');
      print('Current environment variables:');
      dotenv.env.forEach((key, value) {
        print('$key: $value');
      });
    }
  } catch (e, stackTrace) {
    print("Error loading .env file: $e");
    print("Stack trace: $stackTrace");
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Locale _locale = const Locale('en');

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    // Add the back button interceptor on app start
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: (context, child) {
        ScreenUtility.init(context);
        return child!;
      },
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('gu', ''),
        Locale('hi', ''),
        Locale('kn', ''),
        Locale('mr', ''),
      ],
      initialRoute: '/', // Ensure this matches your initial route
      title: 'Black OX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Consider whether you really need to use useMaterial3, as it's still experimental
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/letStartedScreen': (context) => const LetStartedScreen(),
        '/homeScreen': (context) => const HomeScreen(),
        '/selectionScreen': (context) =>
            SelectionScreen(onLocaleChange: _setLocale),
        '/authenticationScreen': (context) => const AuthenticationScreen(),
        '/signUpScreen': (context) => const SignUpScreen(),
        '/loginScreen': (context) => const LoginScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle dynamic route generation if needed
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Route not found!'),
            ),
          ),
        );
      },
    );
  }

  // Custom interceptor function for back button
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // Handle back button interception logic
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == '/businessDetailsShops') {
      // Navigate to '/homeScreen' when pressing back from '/businessDetailsShops'
      navigatorKey.currentState?.pushReplacementNamed('/home');
      return true; // Return true to stop the default back button action
    }
    return false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
}
