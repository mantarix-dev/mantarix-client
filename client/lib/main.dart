import 'dart:io';

import 'package:mantarix/mantarix.dart';
// --FAT_CLIENT_START--
import 'package:mantarix_audio/mantarix_audio.dart' as mantarix_audio;
// --FAT_CLIENT_END--
import 'package:mantarix_audio_recorder/mantarix_audio_recorder.dart'
    as mantarix_audio_recorder;
import "package:mantarix_flashlight/mantarix_flashlight.dart"
    as mantarix_flashlight;
import "package:mantarix_camera/mantarix_camera.dart"
    as mantarix_camera;
import "package:mantarix_lightsensor/mantarix_lightsensor.dart"
    as mantarix_lightsensor;
import 'package:mantarix_geolocator/mantarix_geolocator.dart'
    as mantarix_geolocator;
import 'package:mantarix_lottie/mantarix_lottie.dart' as mantarix_lottie;
import 'package:mantarix_map/mantarix_map.dart' as mantarix_map;
import 'package:mantarix_permission_handler/mantarix_permission_handler.dart'
    as mantarix_permission_handler;
import 'package:mantarix_rive/mantarix_rive.dart' as mantarix_rive;
import 'package:mantarix_ads/mantarix_ads.dart' as mantarix_ads;
// --FAT_CLIENT_START--
import 'package:mantarix_video/mantarix_video.dart' as mantarix_video;
// --FAT_CLIENT_END--
import 'package:mantarix_webview/mantarix_webview.dart' as mantarix_webview;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');

void main([List<String>? args]) async {
  if (isProduction) {
    // ignore: avoid_returning_null_for_void
    debugPrint = (String? message, {int? wrapWidth}) => null;
  }

  await setupDesktop();

  WidgetsFlutterBinding.ensureInitialized();

  // --FAT_CLIENT_START--
  mantarix_audio.ensureInitialized();
  mantarix_video.ensureInitialized();
  // --FAT_CLIENT_END--
  mantarix_audio_recorder.ensureInitialized();
  mantarix_geolocator.ensureInitialized();
  mantarix_permission_handler.ensureInitialized();
  mantarix_lottie.ensureInitialized();
  mantarix_map.ensureInitialized();
  mantarix_ads.ensureInitialized();
  mantarix_rive.ensureInitialized();
  mantarix_webview.ensureInitialized();
  mantarix_flashlight.ensureInitialized();
  mantarix_camera.ensureInitialized();
  mantarix_lightsensor.ensureInitialized();

  var pageUrl = Uri.base.toString();
  var assetsDir = "";
  //debugPrint("Uri.base: ${Uri.base}");

  if (kDebugMode) {
    pageUrl = "http://localhost:8550";
  }

  if (kIsWeb) {
    debugPrint("Mantarix View is running in Web mode");
    var routeUrlStrategy = getMantarixRouteUrlStrategy();
    debugPrint("URL Strategy: $routeUrlStrategy");
    if (routeUrlStrategy == "path") {
      setPathUrlStrategy();
    }
  } else if ((Platform.isWindows || Platform.isMacOS || Platform.isLinux) &&
      !kDebugMode) {
    debugPrint("Mantarix View is running in Desktop mode");
    // first argument must be
    if (args!.isEmpty) {
      throw Exception('Page URL must be provided as a first argument.');
    }
    pageUrl = args[0];
    if (args.length > 1) {
      var pidFilePath = args[1];
      debugPrint("Args contain a path to PID file: $pidFilePath}");
      var pidFile = await File(pidFilePath).create();
      await pidFile.writeAsString("$pid");
    }
    if (args.length > 2) {
      assetsDir = args[2];
      debugPrint("Args contain a path assets directory: $assetsDir}");
    }
  }

  debugPrint("Page URL: $pageUrl");

  MantarixAppErrorsHandler errorsHandler = MantarixAppErrorsHandler();

  if (!kDebugMode) {
    FlutterError.onError = (details) {
      errorsHandler.onError(details.exceptionAsString());
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      errorsHandler.onError(error.toString());
      return true;
    };
  }

  runApp(MantarixApp(
    title: 'Mantarix',
    pageUrl: pageUrl,
    assetsDir: assetsDir,
    errorsHandler: errorsHandler,
    createControlFactories: [
// --FAT_CLIENT_START--
      mantarix_audio.createControl,
      mantarix_video.createControl,
// --FAT_CLIENT_END--
      mantarix_audio_recorder.createControl,
      mantarix_geolocator.createControl,
      mantarix_permission_handler.createControl,
      mantarix_lottie.createControl,
      mantarix_map.createControl,
      mantarix_ads.createControl,
      mantarix_rive.createControl,
      mantarix_webview.createControl,
      mantarix_flashlight.createControl,
      mantarix_camera.createControl,
      mantarix_lightsensor.createControl,
    ],
  ));
}
