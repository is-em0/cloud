import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart' as intl;
import 'package:iug/models/article.dart';
import 'package:iug/providers/list_posts.dart';
import 'package:iug/view/home_screen.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  static const routeName = '/add-post';

  const AddPostScreen({super.key});
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _contentFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _excerptFocusNode = FocusNode();
  final _titleController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController(
      text: intl.DateFormat("yyyy-MM-dd").format(DateTime.now()));
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _form = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initlizeNotification();
  }

  initlizeNotification() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        debugPrint('notification payload: $payload');
      }
      await Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const HomeScreen()),
      );
    });
  }

  showNotifiction() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('newPost', 'posts',
            channelDescription: 'notification for new posts',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'منشور جديد', 'تم إضافة منشور جديد', notificationDetails,
        payload: 'item x');
  }

  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _savePost() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: const Text('منشور جديد'),
        content: const Text('هل أنت متأكد؟'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Article article = Article(
                  id: DateTime.now().hashCode,
                  date: selectedDate.toString(),
                  title: _titleController.text,
                  content: _contentController.text,
                  excerpt: _excerptController.text);
              Provider.of<ListPosts>(context, listen: false).addPost(article);

              _titleController.text = '';
              _contentController.text = '';
              _excerptController.text = '';

              Navigator.of(context).pop();
              showNotifiction();
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                const ColorScheme.light(primary: Color.fromRGBO(0, 14, 89, 1)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة منشور جديد'),
        centerTitle: true,
        backgroundColor: const Color(0xff24292e),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'عنوان'),
                  controller: _titleController,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_contentFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) return 'الرجاء إدخال عنوان';
                    return null;
                  },
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'وصف قصير'),
                  controller: _excerptController,
                  focusNode: _descriptionFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_excerptFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) return 'الرجاء إدخال وصف قصير';
                    return null;
                  },
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'الوصف'),
                  controller: _contentController,
                  focusNode: _contentFocusNode,
                  maxLines: 10,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) return 'الرجاء إدخال وصف';
                    return null;
                  },
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                ),
                const Divider(height: 20, color: Colors.grey),
                const SizedBox(
                  height: 20.0,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    color: Colors.grey[300],
                    child: ListTile(
                      title: const Text("اضافة منشور جديد"),
                      leading: const Icon(Icons.add, color: Colors.black),
                      onTap: () => _savePost(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
