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
    apiKey: 'AIzaSyB1JE8PMPXzfkzShKW2ceCeAgJYGmFznu8',
    appId: '1:289822193769:web:21780d6b6304d67d644af8',
    messagingSenderId: '289822193769',
    projectId: 'aunthentication-4baea',
    authDomain: 'aunthentication-4baea.firebaseapp.com',
    storageBucket: 'aunthentication-4baea.firebasestorage.app',
    measurementId: 'G-T4YBSD32ZB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDk70nf-reJomO1nA9d3wHMPyP3TbzN0DQ',
    appId: '1:289822193769:android:04431a01c5f94cce644af8',
    messagingSenderId: '289822193769',
    projectId: 'aunthentication-4baea',
    storageBucket: 'aunthentication-4baea.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3J8OHUhiF5CM46E3rkVgBfGBpLFBN49w',
    appId: '1:289822193769:ios:c43d4ca650073042644af8',
    messagingSenderId: '289822193769',
    projectId: 'aunthentication-4baea',
    storageBucket: 'aunthentication-4baea.firebasestorage.app',
    iosBundleId: 'com.example.stockly',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB3J8OHUhiF5CM46E3rkVgBfGBpLFBN49w',
    appId: '1:289822193769:ios:c43d4ca650073042644af8',
    messagingSenderId: '289822193769',
    projectId: 'aunthentication-4baea',
    storageBucket: 'aunthentication-4baea.firebasestorage.app',
    iosBundleId: 'com.example.stockly',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB1JE8PMPXzfkzShKW2ceCeAgJYGmFznu8',
    appId: '1:289822193769:web:908446800c7f8858644af8',
    messagingSenderId: '289822193769',
    projectId: 'aunthentication-4baea',
    authDomain: 'aunthentication-4baea.firebaseapp.com',
    storageBucket: 'aunthentication-4baea.firebasestorage.app',
    measurementId: 'G-KL221MJ3QJ',
  );

}