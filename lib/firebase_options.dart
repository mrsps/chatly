// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACIzngnDh_3wCmwn7B0p79q7uO4nKWwdc',
    appId: '1:276133920893:android:07c9ac520b7927c476b114',
    messagingSenderId: '276133920893',
    projectId: 'chatly-822f4',
    storageBucket: 'chatly-822f4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCP6C2mWCyMnlhHRECnrfGcq-8ougQutYI',
    appId: '1:276133920893:ios:125c9a708b3c033076b114',
    messagingSenderId: '276133920893',
    projectId: 'chatly-822f4',
    storageBucket: 'chatly-822f4.appspot.com',
    androidClientId: '276133920893-db9kpft3lblhcq4fdh8phds9j6u77pv8.apps.googleusercontent.com',
    iosClientId: '276133920893-sdn5eenpi93ti846hi9qu3ktnv1n0uj2.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatly',
  );
}
