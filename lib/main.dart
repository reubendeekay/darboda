import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:darboda/constants.dart';
import 'package:darboda/firebase_options.dart';
import 'package:darboda/helpers/push_notifications.dart';
import 'package:darboda/loading_screen.dart';
import 'package:darboda/providers/auth_provider.dart';
import 'package:darboda/providers/chat_provider.dart';
import 'package:darboda/providers/location_provider.dart';
import 'package:darboda/providers/request_provider.dart';
import 'package:darboda/screens/chat/chat_room.dart';
import 'package:darboda/theme.dart';
import 'package:darboda/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: kPrimaryColor,
            enableLights: true,
            ledColor: Colors.white),
        NotificationChannel(
            channelKey: 'chat',
            channelName: 'Chat notifications',
            enableLights: true,
            channelDescription: 'Notification channel for basic tests',
            defaultColor: kPrimaryColor,
            channelShowBadge: true,
            playSound: true,
            ledColor: Colors.white)
      ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    registerNotification();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    //On click action over notification
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: (actionReceived) async {
      if (actionReceived.id! == 2) {
        final payload = actionReceived.payload!['data'] as Map<String, dynamic>;

        Navigator.of(context).pushNamed(ChatRoom.routeName, arguments: {
          'user': payload['user'],
          'chatRoomId': payload['id'],
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: FirebasePhoneAuthProvider(
        child: ScreenUtilInit(
          designSize: const Size(392, 781),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              title: 'DarBoda',
              debugShowCheckedModeBanner: false,
              theme: theme(),
              home: child,
              routes: {
                ChatRoom.routeName: (context) => ChatRoom(),
              },
            );
          },
          child: InitialLoadingScreen(),
          // child: StreamBuilder(
          //     stream: FirebaseAuth.instance.authStateChanges(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return const InitialLoadingScreen();
          //       }
          //       return const WelcomeScreen();
          //     }),
        ),
      ),
    );
  }
}
