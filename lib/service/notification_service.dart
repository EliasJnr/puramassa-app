import 'package:http/http.dart' as http;

class NotificationService {
  String _fcmToken = "";
  String _fcmServerKey =
      "AAAAN7E8RPA:APA91bHeT3V21Sdv4x6bb_bRFqPOnX1qo2rTDvTOMSMB-CDZfSVdVPpatZ9Ze6Anw_7aymfrCMzRabhfdDYPnzo119Tqa_FQ4Nul1-umu3nplZ3nfojMyuRSo-MIcMk5an1LcZb-c_NE";

  NotificationService(this._fcmToken);

  sendNewNotification(String info, String title) {
    String body =
        "{\"notification\": {\"body\": \"$info\",\"title\": \"$title\"}, \"priority\": \"high\", \"data\": {\"click_action\": \"FLUTTER_NOTIFICATION_CLICK\", \"id\": \"1\", \"status\": \"done\"}, \"to\": \"$_fcmToken\"}";
    http.post("https://fcm.googleapis.com/fcm/send", body: body, headers: {
      "Content-Type": "application/json",
      "Authorization": "key=$_fcmServerKey"
    });
  }
}
