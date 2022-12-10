import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ArticleScreen extends StatefulWidget {
  final String content;
  final String title;
  final String date;
  const ArticleScreen(
      {super.key,
      required this.content,
      required this.title,
      required this.date});

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  int position = 1;
  bool _showConnected = false;
  bool isLightTheme = true;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((event) {
      checkConnectivity();
    });
  }

  checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    showConnectivitySnackBar(result);
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    var isConnected = result != ConnectivityResult.none;
    if (!isConnected) {
      _showConnected = true;
      const snackBar = SnackBar(
          content: Text(
            "You are Offline",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (isConnected && _showConnected) {
      _showConnected = false;
      const snackBar = SnackBar(
          content: Text(
            "You are back Online",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xff24292e),
        ),
        backgroundColor: const Color(0xff24292e),
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        title: Text(widget.date.contains("T")
            ? widget.date.substring(0, widget.date.indexOf("T"))
            : widget.date.substring(0, 10)),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: HtmlWidget(
                    widget.title,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 25),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: HtmlWidget(
                    widget.content,
                    textStyle: const TextStyle(fontSize: 17),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
