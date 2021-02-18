import 'dart:async';
import 'dart:html';
import 'package:katikati_ui_lib/components/router/route.dart';

class Router {
  Map<String, Route> _routes;
  Route _authRoute;
  Route _defaultRoute;
  Route _currentRoute;

  Router() {
    _routes = {};
  }

  void set authPageHandler(Route route) {
    _routes[route.path] = route;
    _authRoute = route;
  }

  void set defaultPageHandler(Route route) {
    _routes[route.path] = route;
    _defaultRoute = route;
  }

  void addOtherPageHandler(Route route) {
    _routes[route.path] = route;
  }

  StreamSubscription _locationChangeListener;
  void listen() {
    // todo: how to pass the controller?
    _locationChangeListener = window.onPopState.listen((_) => routeTo(window.location.hash, true));
  }

  Map<String, String> get routeParams => _currentRoute.params;
  // todo: how to pass the controller / logged in state?
  void routeTo(String path, bool userSignedIn) {
    if (!userSignedIn) {
      _setRouteAndHandle(_authRoute);
      return;
    }
    if (userSignedIn && _currentRoute == _authRoute) {
      _setRouteAndHandle(_defaultRoute);
      return;
    }
    var pathUri = Uri.parse(path);
    // Check if there's a query after the fragment and process it, it seems that traditional URIs don't suppor this.
    if (pathUri.fragment.contains('?')) {
      var tuple = pathUri.fragment.split('?');
      pathUri = pathUri.replace(
        fragment: tuple[0],
        query: tuple[1]
      );
    }
    var desiredRoute;
    if (pathUri.fragment.isNotEmpty) {
      desiredRoute = _routes['#${pathUri.fragment}'];
    } else {
      desiredRoute = _routes[pathUri.path];
    }
    if (desiredRoute == null) {
      _setRouteAndHandle(_defaultRoute);
      return;
    }
    if (pathUri.hasQuery) {
      desiredRoute.params = pathUri.queryParameters;
    }
    _setRouteOrReload(desiredRoute);
  }

  /// Sets the route and calls its corresponding handler if the location has changed.
  /// To be used for pages that don't carry any data, and so where loading the page multiple times doesn't cause an issue.
  void _setRouteAndHandle(Route route) {
    _currentRoute = route;
    if (window.location.hash != _currentRoute.path) {
      window.location.hash = _currentRoute.path;
      return;
    }
    _currentRoute.handler();
  }

  /// Sets the route and reloads the page if the URL has changed, otherwise calls its corresponding handler.
  /// To be used for pages processing data, and so where loading the page multiple times can cause an issue.
  void _setRouteOrReload(Route route) {
    _currentRoute = route;
    if (route.path.startsWith('/')) {
      _locationChangeListener.cancel();
      var baseWebsite = window.location.href.split('configure').first;
      var newUrl = '$baseWebsite${route.path}';
      window.location.replace(newUrl);
      return;
    }
    if (window.location.hash != _currentRoute.path) {
      var newFragment = _currentRoute.path.replaceAll('#', '');
      var newUrl = Uri.parse(window.location.href).replace(fragment: newFragment);

      _locationChangeListener.cancel();
      window.location.href = newUrl.toString();
      window.location.reload();
      return;
    }
    _currentRoute.handler();
  }
}
