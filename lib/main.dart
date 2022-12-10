import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iug/providers/database_provider.dart';
import 'package:iug/providers/list_posts.dart';
import 'package:iug/providers/list_imgs.dart';
import 'package:iug/view/add_post_screen.dart';
import 'package:iug/view/splash_screen.dart';
import 'package:provider/provider.dart';

import 'helpers/app_router.dart';
import 'view/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ListPosts>(
          create: (_) => ListPosts(),
        ),
        ChangeNotifierProvider<ListSlides>(
          create: (_) => ListSlides(),
        ),
        ChangeNotifierProvider<DatebaseProvider>(
          create: (_) => DatebaseProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IUG App',
      navigatorKey: AppRouter.route.navKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            return // const SplashScreen();
                Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                title: const Text("Something is Wrong"),
                centerTitle: true,
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const SplashScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        AddPostScreen.routeName: (ctx) => const AddPostScreen(),
      },
    );
  }
}
