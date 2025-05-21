import 'strings.dart';

bool isProgressiveWebApp() {
  return false;
}

String getWebsocketEndpointPath(String uriPath) {
  var pagePath = trim(uriPath, "/");
  if (pagePath != "") {
    pagePath = "$pagePath/";
  }
  return "${pagePath}ws";
}

String getMantarixRouteUrlStrategy() {
  return "";
}

bool isMantarixWebPyodideMode() {
  return false;
}

void openPopupBrowserWindow(
    String url, String windowName, int minWidth, int minHeight) {}
