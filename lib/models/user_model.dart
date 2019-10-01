import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  FirebaseMessaging _firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  UserModel() {
    _firebaseMessaging = FirebaseMessaging();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
        new InitializationSettings(
            new AndroidInitializationSettings('@mipmap/ic_launcher'),
            new IOSInitializationSettings()),
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    print("teste $payload");
  }

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
    firebaseCloudMessagingListeners();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((user) async {
      firebaseUser = user;

      await _loadCurrentUser();

      onSuccess();

      await _saveUserData(userData);

      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn(
      {@required String email,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      firebaseUser = user;
      await _loadCurrentUser();
      await updateToken(
          await _firebaseMessaging.getToken().then((value) => value));

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.getToken().then((token) async {
      if (isLoggedIn()) await updateToken(token);
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(
            message['notification']['title'], message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showNotification(
            message['notification']['title'], message['notification']['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showNotification(
            message['notification']['title'], message['notification']['body']);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  updateToken(token) async {
    DocumentSnapshot docUser = await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .get();
    docUser.data["token"] = token;
    await docUser.reference.updateData(docUser.data);
  }

  showNotification(String title, String body) async {
      var android = new AndroidNotificationDetails(
          'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
          priority: Priority.Max, importance: Importance.Max);
      var iOS = new IOSNotificationDetails();
      var platform = new NotificationDetails(android, iOS);
      await flutterLocalNotificationsPlugin.show(0, title, body, platform);

  }

  void signOut() async {
    await updateToken("");
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }
}
