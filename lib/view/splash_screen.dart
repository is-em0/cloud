import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:iug/helpers/app_router.dart';
import 'package:iug/providers/database_provider.dart';
import 'package:iug/providers/list_imgs.dart';
import 'package:iug/providers/list_posts.dart';
import 'package:iug/view/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? animation;
  bool _showprogressIndicator = false;
  bool isConnected = false;
  @override
  void initState() {
    getData();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = Tween<double>(begin: 0, end: 1).animate(animationController!)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _showprogressIndicator = true;
          if (!mounted) return;
          setState(() {});
        }
      });
    animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    isConnected = result != ConnectivityResult.none;
    if (!isConnected) {
      await Provider.of<DatebaseProvider>(
              AppRouter.route.navKey.currentContext!,
              listen: false)
          .fetchAndSetPosts();

    } else {
      Provider.of<ListPosts>(AppRouter.route.navKey.currentContext!,
              listen: false)
          .fetchPosts(1);
      await Provider.of<ListPosts>(AppRouter.route.navKey.currentContext!,
              listen: false)
          .getAllPosts();

      await Provider.of<ListSlides>(AppRouter.route.navKey.currentContext!,
              listen: false)
          .getAllImages();

    }

    Navigator.of(AppRouter.route.navKey.currentContext!)
        .pushReplacementNamed(HomeScreen.routeName);
  }

  Widget connected() {
    return Consumer<ListPosts>(builder: (context, provider, child) {
      return _showprogressIndicator
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Transform.scale(
              scale: animation!.value,
              child: Center(
                child: Image.asset("assets/images/logo.png"),
              ),
            );
    });
  }

  Widget notConnected() {
    return Consumer<DatebaseProvider>(builder: (context, provider, child) {
      return _showprogressIndicator
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Transform.scale(
              scale: animation!.value,
              child: Center(
                child: Image.asset("assets/images/logo.png"),
              ),
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: isConnected ? connected() : notConnected());
  }
}
