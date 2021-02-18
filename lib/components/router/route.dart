class Route {
  String path;
  Map<String, String> params;
  Function handler;

  Route(this.path, this.handler, [this.params]) {
    if (params == null) params = {};
  }
}
