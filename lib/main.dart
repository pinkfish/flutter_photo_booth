import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'src/model/photos_library_api_model.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import 'src/froggy_booth_app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sign into google.
  final apiModel = PhotosLibraryApiModel();
  apiModel.signInSilently();

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(ScopedModel<PhotosLibraryApiModel>(
      model: apiModel,
      child: ChangeNotifierProvider.value(
          value: settingsController,
          child: FroggyBoothApp(settingsController: settingsController))));
}
