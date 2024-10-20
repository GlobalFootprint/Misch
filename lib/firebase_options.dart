// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCl3d2ShdYIt5Tfen0gxvBjNPmUH1qVz18',
    appId: '1:62783440390:web:61eb2b2c93e5902e75a587',
    messagingSenderId: '62783440390',
    projectId: 'misch-c6ebc',
    authDomain: 'misch-c6ebc.firebaseapp.com',
    storageBucket: 'misch-c6ebc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3iPXdLSaAwr95A2QPs9wzfbkvjJxzT-E',
    appId: '1:62783440390:android:d613bd61ff04461475a587',
    messagingSenderId: '62783440390',
    projectId: 'misch-c6ebc',
    storageBucket: 'misch-c6ebc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiRB5FQW1oa93Sxwz1UgiYMUS8f6KglN0',
    appId: '1:62783440390:ios:318c39fa5417766875a587',
    messagingSenderId: '62783440390',
    projectId: 'misch-c6ebc',
    storageBucket: 'misch-c6ebc.appspot.com',
    iosBundleId: 'com.misch.misch',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDiRB5FQW1oa93Sxwz1UgiYMUS8f6KglN0',
    appId: '1:62783440390:ios:318c39fa5417766875a587',
    messagingSenderId: '62783440390',
    projectId: 'misch-c6ebc',
    storageBucket: 'misch-c6ebc.appspot.com',
    iosBundleId: 'com.misch.misch',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCl3d2ShdYIt5Tfen0gxvBjNPmUH1qVz18',
    appId: '1:62783440390:web:e0d8fb014219e7e675a587',
    messagingSenderId: '62783440390',
    projectId: 'misch-c6ebc',
    authDomain: 'misch-c6ebc.firebaseapp.com',
    storageBucket: 'misch-c6ebc.appspot.com',
  );
}
