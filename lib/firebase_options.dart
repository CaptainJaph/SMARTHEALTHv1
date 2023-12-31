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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCoitj1rZwgpwQxF1Vw4yfvq-_TW1bh-5Y',
    appId: '1:272764470989:web:dded64f9e31272ea0a4b84',
    messagingSenderId: '272764470989',
    projectId: 'nkx-projects',
    authDomain: 'nkx-projects.firebaseapp.com',
    storageBucket: 'nkx-projects.appspot.com',
    measurementId: 'G-21RV46WD2N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA28vU8KlMMKy9xmDQdq6111A_VcjI5nCs',
    appId: '1:272764470989:android:661d857596351bc20a4b84',
    messagingSenderId: '272764470989',
    projectId: 'nkx-projects',
    storageBucket: 'nkx-projects.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxTQKHaTcFFzZG8t2T-mD-5dCUM0NcPfQ',
    appId: '1:272764470989:ios:9166753f8071614c0a4b84',
    messagingSenderId: '272764470989',
    projectId: 'nkx-projects',
    storageBucket: 'nkx-projects.appspot.com',
    iosClientId: '272764470989-769babu03fageeit9ier11o4mfu8prmg.apps.googleusercontent.com',
    iosBundleId: 'com.example.healthApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAxTQKHaTcFFzZG8t2T-mD-5dCUM0NcPfQ',
    appId: '1:272764470989:ios:c4e47ba3747d3b7f0a4b84',
    messagingSenderId: '272764470989',
    projectId: 'nkx-projects',
    storageBucket: 'nkx-projects.appspot.com',
    iosClientId: '272764470989-7ulhtvvoh9m2h0b2fvjg92p4g4v6gsnf.apps.googleusercontent.com',
    iosBundleId: 'com.example.healthApp.RunnerTests',
  );
}
