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
    apiKey: 'AIzaSyDqItm9daZ0yxeTc9p8_mbWm6IFNaF4n0s',
    appId: '1:573972721772:web:a5c11ab15dac7bc86c6849',
    messagingSenderId: '573972721772',
    projectId: 'my-cool-corporate-media',
    authDomain: 'my-cool-corporate-media.firebaseapp.com',
    storageBucket: 'my-cool-corporate-media.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiroYigzxILTPR9pwtL_9mG99rnEIU_rA',
    appId: '1:573972721772:android:841ece18bf6f51d56c6849',
    messagingSenderId: '573972721772',
    projectId: 'my-cool-corporate-media',
    storageBucket: 'my-cool-corporate-media.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBttiQwIzEcAWykTkZP8h4I1Q7gOxOfCi4',
    appId: '1:573972721772:ios:240188a11e7fee5e6c6849',
    messagingSenderId: '573972721772',
    projectId: 'my-cool-corporate-media',
    storageBucket: 'my-cool-corporate-media.appspot.com',
    iosBundleId: 'com.example.corporateMedia',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBttiQwIzEcAWykTkZP8h4I1Q7gOxOfCi4',
    appId: '1:573972721772:ios:240188a11e7fee5e6c6849',
    messagingSenderId: '573972721772',
    projectId: 'my-cool-corporate-media',
    storageBucket: 'my-cool-corporate-media.appspot.com',
    iosBundleId: 'com.example.corporateMedia',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDqItm9daZ0yxeTc9p8_mbWm6IFNaF4n0s',
    appId: '1:573972721772:web:968e7cabc886b7426c6849',
    messagingSenderId: '573972721772',
    projectId: 'my-cool-corporate-media',
    authDomain: 'my-cool-corporate-media.firebaseapp.com',
    storageBucket: 'my-cool-corporate-media.appspot.com',
  );
}
