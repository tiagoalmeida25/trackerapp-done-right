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
    apiKey: 'AIzaSyDZ2tJ9nKvNFw3O-v8t505UpXpqDjr_DQ4',
    appId: '1:761591335750:web:051b53d102c26308efb347',
    messagingSenderId: '761591335750',
    projectId: 'tracker-e915c',
    authDomain: 'tracker-e915c.firebaseapp.com',
    storageBucket: 'tracker-e915c.appspot.com',
    measurementId: 'G-DEX8QCX444',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6KYW9PQdLlcbLrE9LJtfKPa2fVGWLP8w',
    appId: '1:761591335750:android:e31ff523a6e594a9efb347',
    messagingSenderId: '761591335750',
    projectId: 'tracker-e915c',
    storageBucket: 'tracker-e915c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzCk-0Jf70JQD6F3T0KYafn8NGkao7KxU',
    appId: '1:761591335750:ios:4315c96a01b39cc4efb347',
    messagingSenderId: '761591335750',
    projectId: 'tracker-e915c',
    storageBucket: 'tracker-e915c.appspot.com',
    iosClientId: '761591335750-v3fdu9mc2krvn8kfdgaafhsgsiuo61ne.apps.googleusercontent.com',
    iosBundleId: 'com.example.trackerapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCzCk-0Jf70JQD6F3T0KYafn8NGkao7KxU',
    appId: '1:761591335750:ios:4315c96a01b39cc4efb347',
    messagingSenderId: '761591335750',
    projectId: 'tracker-e915c',
    storageBucket: 'tracker-e915c.appspot.com',
    iosClientId: '761591335750-v3fdu9mc2krvn8kfdgaafhsgsiuo61ne.apps.googleusercontent.com',
    iosBundleId: 'com.example.trackerapp',
  );
}