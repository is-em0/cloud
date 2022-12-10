import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iug/view/article_screen.dart';
import 'package:iug/view/image_screen.dart';
import 'package:transition/transition.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class NewsTile extends StatelessWidget {
  final String image, title, content, date, excerpt, index;
  NewsTile({
    required this.content,
    required this.date,
    required this.image,
    required this.title,
    required this.excerpt,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      margin: const EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(6),
            bottomLeft: Radius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Hero(
                  tag: 'image-$image-$index',
                  child: CachedNetworkImage(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    imageUrl: image,
                    placeholder: (context, url) => Image(
                      image: const AssetImage(
                          'assets/images/dotted-placeholder.jpg'),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageScreen(
                      imageUrl: image,
                      headline: title,
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: HtmlWidget(excerpt)),
                  const SizedBox(
                    height: 4,
                  ),
                  Text("Date: ${date.replaceFirst("T", " ")}",
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12.0))
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  Transition(
                    child: ArticleScreen(
                        content: content, title: title, date: date),
                    transitionEffect: TransitionEffect.BOTTOM_TO_TOP,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
