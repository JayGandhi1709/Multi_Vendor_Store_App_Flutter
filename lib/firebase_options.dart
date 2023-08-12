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
    apiKey: 'AIzaSyBBI6svtFM6z3i7adkAtqS3dyYP15q6pQg',
    appId: '1:1086731920110:web:bb180206826e8e5a3f49ff',
    messagingSenderId: '1086731920110',
    projectId: 'multi-vender-store-67f8a',
    authDomain: 'multi-vender-store-67f8a.firebaseapp.com',
    storageBucket: 'multi-vender-store-67f8a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHr2m83YN-_dl8FVb7aaozlYDtcclPY9U',
    appId: '1:1086731920110:android:94a959cf5db1fb283f49ff',
    messagingSenderId: '1086731920110',
    projectId: 'multi-vender-store-67f8a',
    storageBucket: 'multi-vender-store-67f8a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCG-kWM3eFRXPmPVs62UanpVMX6t37zELs',
    appId: '1:1086731920110:ios:3399b8bccfd3a2153f49ff',
    messagingSenderId: '1086731920110',
    projectId: 'multi-vender-store-67f8a',
    storageBucket: 'multi-vender-store-67f8a.appspot.com',
    iosClientId: '1086731920110-qf1dk082ivhur0nr5n2i8f18u90ps58e.apps.googleusercontent.com',
    iosBundleId: 'com.example.multiVenderStoreApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCG-kWM3eFRXPmPVs62UanpVMX6t37zELs',
    appId: '1:1086731920110:ios:54ad4be2833540023f49ff',
    messagingSenderId: '1086731920110',
    projectId: 'multi-vender-store-67f8a',
    storageBucket: 'multi-vender-store-67f8a.appspot.com',
    iosClientId: '1086731920110-f1cf36jprucgf2kl03ado9b3seu1u1h0.apps.googleusercontent.com',
    iosBundleId: 'com.example.multiVenderStoreApp.RunnerTests',
  );
}
