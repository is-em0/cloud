import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:iug/helpers/app_router.dart';
import 'package:iug/helpers/utils.dart';
import 'package:iug/models/article.dart';
import 'package:iug/providers/database_provider.dart';
import 'package:iug/providers/list_posts.dart';
import 'package:iug/widgets/news_tile.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  var scrollController = ScrollController();
  bool isLoading = false;
  bool offlineLoading = false;
  int page = 1;
  List<Article> list = [];
  bool isConnected = false;
  bool _showConnected = false;

  Future<void> checkConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    isConnected = result != ConnectivityResult.none;
    if (!isConnected) {
      offlineLoading = true;
      if (!mounted) return;
      setState(() {});
      list = Provider.of<DatebaseProvider>(
              AppRouter.route.navKey.currentContext!,
              listen: false)
          .postsList;
      offlineLoading = false;
      if (!mounted) return;
      setState(() {});
    } else {
      list = Provider.of<ListPosts>(AppRouter.route.navKey.currentContext!,
              listen: false)
          .postsList;

      if (list.isEmpty) {
        list = Provider.of<DatebaseProvider>(
                AppRouter.route.navKey.currentContext!,
                listen: false)
            .postsList;
      }
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    scrollController.addListener(pagination);
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((event) {
      snackbarCheckConnectivity();
    });
    super.initState();
  }

  snackbarCheckConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    showConnectivitySnackBar(result);
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    var isConnected = result != ConnectivityResult.none;
    if (!isConnected) {
      _showConnected = true;
      if (!mounted) return;
      const snackBar = SnackBar(
          content: Text(
            "أنت غير متصل بالانترنت",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (isConnected && _showConnected) {
      _showConnected = false;
      if (!mounted) return;
      const snackBar = SnackBar(
          content: Text(
            "لقد عاد اتصالك بالانترنت",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(pagination);
    super.dispose();
  }

  void pagination() {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        isConnected)) {
      setState(() {
        isLoading = true;
        page += 1;
        //add api for load the more data according to new page
        Provider.of<ListPosts>(context, listen: false)
            .fetchPosts(page)
            .then((value) => isLoading = false);
      });
    }
  }

  Future<void> refreshList() async {
    list = await Provider.of<ListPosts>(context, listen: false).getAllPosts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return offlineLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            backgroundColor: const Color(0xff24292e),
            color: Colors.white,
            onRefresh: refreshList,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        String image =
                            Utils.utils.getFirstImage(list[index].content!);
                        if (image.isEmpty) {
                          image =
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6xP7BLA9ApZ6Rlo2nDmu59uv_bbD8rmRiEzy6lY_e46-6pYec_0E1hdCCq30g9O8GZ9E&usqp=CAU";
                        }
                        String content = list[index]
                            .content!
                            .replaceAll("&#8221;", "”")
                            .replaceAll("&#8220;", "“");
                        String excerpt = list[index]
                            .excerpt!
                            .replaceAll("&#8221;", "”")
                            .replaceAll("&#8220;", "“");
                        String title = list[index]
                            .title!
                            .replaceAll("&#8221;", "”")
                            .replaceAll("&#8220;", "“");

                        return NewsTile(
                          image: image,
                          title: title,
                          content: content,
                          date: list[index].date!,
                          excerpt: excerpt,
                          index: "$index",
                        );
                      },
                    ),
                  ),
                  if (isLoading == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          );
  }
}
