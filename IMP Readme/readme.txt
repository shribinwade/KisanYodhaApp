📓 ADB Notes
🔁 adb reverse tcp:3000 tcp:3000
Purpose:
Allows an Android device (emulator or physical device) to access a service (e.g., development server) running on the host machine (PC).

Use case:
Used in mobile app development when the dev server is running on the computer at localhost:3000.

Effect:
Maps device's localhost:3000 → host's localhost:3000.



Command: adb reverse tcp:3000 tcp:3000

📶 Wireless Debugging with ADB
Step-by-step setup:

Connect device via USB (only once, to set it up).

Find device IP address (on the same Wi-Fi as PC):


adb shell ip route
Look for something like: 192.168.x.x

Enable TCP/IP mode on the device:

adb tcpip 5555
(This restarts ADB in TCP mode on port 5555)

Connect wirelessly:

adb connect <device_ip>:5555
Example:


adb connect 192.168.1.5:5555
(Optional): Disconnect USB — device should now be connected wirelessly.

Verify connection:

adb devices
You should see the IP listed.
#########################################################################################################################################
## Run flutter in diff environment Like production development and test

Create the following files in your project root:

.env                  // default
.env.development      // development-specific
.env.production       // production-specific

# .env.development
API_URL=https://dev.example.com/api
DEBUG=true

# .env.production
API_URL=https://prod.example.com/api
DEBUG=false



customize main.dart to load a specific environment:

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  const envFile = String.fromEnvironment('ENV', defaultValue: '.env');
  await dotenv.load(fileName: envFile);

  runApp(MyApp());
}


# Access the Env Variables Anywhere

final apiUrl = dotenv.env['API_URL'];
final isDebug = dotenv.env['DEBUG'] == 'true';


Use --dart-define to specify which file to load.

Development:
flutter run --dart-define=ENV=.env.development

Production:
flutter run --dart-define=ENV=.env.production

builds:
flutter build apk --dart-define=ENV=.env.production

