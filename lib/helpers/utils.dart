class Utils {
  Utils._();
  static Utils utils = Utils._();
  String getFirstImage(String data) {
    List<String> l = data.split("\"");
    String res = "";
    l.forEach((element) {
      if (isValidURL(element)) {
        if (element.contains(".jpg")) {
          res = element.substring(0, element.indexOf(".jpg") + 4);
        }
        if (element.contains(".png")) {
          res = element.substring(0, element.indexOf(".png") + 4);
        }
        if (element.contains(".webp")) {
          res = element.substring(0, element.indexOf(".webp") + 5);
        }

        return;
      }
    });
    return res;
  }

  bool isValidURL(String link) {
    try {
      return Uri.parse(link).isAbsolute;
    } on Exception catch (_) {}
    return false;
  }
}
