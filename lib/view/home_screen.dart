import 'package:flutter/material.dart';
import 'package:iug/helpers/app_router.dart';
import 'package:iug/view/about_screen.dart';
import 'package:iug/view/add_post_screen.dart';
// import 'package:iug/view/pages_screen.dart';
import 'package:iug/view/posts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    PostsScreen(),
    // PagesScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("IUG"),
          backgroundColor: const Color(0xff24292e),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff24292e),
            onPressed: () =>
                AppRouter.route.pushNamed(AddPostScreen.routeName, {}),
            child: const Icon(Icons.post_add)),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.document_scanner_outlined,
                color: Color(0xff24292e),
              ),
              label: 'Posts',
              backgroundColor: Color(0xff24292e),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.pages,
            //     color: Color(0xff24292e),
            //   ),
            //   label: 'Pages',
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_box,
                color: Color(0xff24292e),
              ),
              label: 'About',
            ),
          ],
        ),
        body: _pages.elementAt(_selectedIndex));
  }
}
