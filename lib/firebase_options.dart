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
    apiKey: 'AIzaSyDi2CZdWIsjVJx2WIf7B8LY4X3QIbmZP6s',
    appId: '1:13709382143:android:34c020b6350019476017ca',
    messagingSenderId: '13709382143',
    projectId: 'gebesa-desk-controller',
    storageBucket: 'gebesa-desk-controller.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBeG-Jp5hplY2K8y2gJgt4OKPvJ4U0a6aA',
    appId: '1:13709382143:ios:fc097e3470f8a21b6017ca',
    messagingSenderId: '13709382143',
    projectId: 'gebesa-desk-controller',
    storageBucket: 'gebesa-desk-controller.firebasestorage.app',
    androidClientId: '13709382143-02899ioa0ohleso4eo41sab3kmss2441.apps.googleusercontent.com',
    iosClientId: '13709382143-jgrp713eagn8an6ekfe5gim8lh2j4531.apps.googleusercontent.com',
    iosBundleId: 'app.gebesa.controller.RunnerTests',
  );

}