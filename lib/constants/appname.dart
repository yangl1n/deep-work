class AppName {
  static const String WECHAT = "wechat";
  static const String WHATSAPP = "whatsapp";
  static const String OUTLOOK = "outlook";
  static const String NOTFOUND = "others";
  static const List<String> enableApps = [WECHAT, WHATSAPP, OUTLOOK];
  static const Map<String, String> enablePackages = {
    "com.tencent.mm": WECHAT,
    //"com.whatsapp" : WHATSAPP,
    //"com.microsoft.office.outlook" : OUTLOOK
  };
}