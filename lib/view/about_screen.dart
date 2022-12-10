import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iug/helpers/text_style.dart';
import 'package:iug/models/slide.dart';
import 'package:iug/providers/list_imgs.dart';
import 'package:iug/view/image_screen.dart';
import 'package:iug/widgets/map.dart';
import 'package:iug/widgets/social_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

String viewID = "youtube-placeholder";

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '7IlozqRdO8o',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  String socialName = "الجامعة الإسلامية في غزة";
  String description =
      "الجامعة الإسلامية بغزة مؤسسة أكاديمية مستقلة من مؤسسات التعليم العالي، تعمل بإشراف وزارة التربية والتعليم العالي، وهي عضو في: اتحاد الجامعات العربية، ورابطة الجامعات الإسلامية ، واتحاد الجامعات الإسلامية ، ورابطة جامعات البحر الأبيض المتوسط، والاتحاد الدولي للجامعات، وتربطها علاقات تعاون بالكثير من الجامعات العربية والأجنبية. توفر الجامعة لطلبتها جواً أكاديمياً ملتزماً بالقيم الإسلامية ومراعياً لظروف الشعب الفلسطيني وتقاليده، وتضع كل الإمكانيات المتاحة لخدمة العملية التعليمية، وتهتم بالجانب التطبيقي اهتمامها بالجانب النظري، كما وتهتم بتوظيف وسائل التكنولوجيا المتوفرة في خدمة العملية التعليمية.";

  AnimationController? animationController;
  Animation<double>? rotateY;
  List<Slide> slide = [];
  List<Widget> imageSliders = [];
  @override
  void dispose() {
    animationController!.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    slide = Provider.of<ListSlides>(context, listen: false).pagesList;
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    rotateY = Tween<double>(
      begin: .0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: animationController!,
      curve: Curves.ease,
    ));

    imageSliders = slide
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageScreen(
                                imageUrl: item.img!,
                                headline: item.img!,
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                            imageUrl: item.img!,
                            fit: BoxFit.cover,
                            width: 1000.0),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'صورة ${slide.indexOf(item) + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 25,
              ),
              AnimatedBuilder(
                animation: animationController!,
                builder: (context, child) {
                  final card = Container(
                    width: 250,
                    height: 150,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/logo.png'),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 4),
                          blurRadius: 4.0,
                        )
                      ],
                    ),
                  );

                  return Transform(
                    transform: Matrix4.rotationY(rotateY!.value * math.pi),
                    alignment: Alignment.center,
                    child: card,
                  );
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                socialName,
                style: normalText(
                  fontSize: 28,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: normalText(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "إنجازات الجامعة الإسلامية لعام 2022",
                textAlign: TextAlign.center,
                style: normalText(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0),
              ),
              const SizedBox(
                height: 15,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: imageSliders,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "إنجازات الجامعة الإسلامية لعام 2021",
                textAlign: TextAlign.center,
                style: normalText(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0),
              ),
              const SizedBox(
                height: 15,
              ),
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'موقع الجامعة على الخريطة',
                style: normalText(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 250,
                height: 1,
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => MapWidget(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text("الخريطة")),
              const SizedBox(
                height: 30,
              ),
              Text(
                'وسائل التواصل والسوشيال ميديا',
                style: normalText(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 250,
                height: 1,
                color: Colors.grey[300],
              ),
              const SizedBox(
                height: 30,
              ),
              SocialButton(
                url: 'https://www.facebook.com/IUGAZA/',
                icon: MdiIcons.facebook,
                iconColor: Colors.blue[800]!,
                label: "Facebook Page",
              ),
              const SizedBox(
                height: 25,
              ),
              SocialButton(
                url: 'https://www.linkedin.com/school/iugaza/',
                icon: MdiIcons.linkedin,
                iconColor: Colors.blue[800]!,
                label: "LinkedIn Page",
              ),
              const SizedBox(
                height: 25,
              ),
              const SocialButton(
                url: 'https://www.youtube.com/channel/UCfGSd18MW8D9rUP4-jXD_Tw',
                icon: MdiIcons.youtube,
                iconColor: Colors.red,
                label: "Youtube Channel",
              ),
              const SizedBox(
                height: 25,
              ),
              const SocialButton(
                url: 'https://twitter.com/iugaza',
                icon: MdiIcons.twitter,
                iconColor: Colors.lightBlue,
                label: "Twitter Page",
              ),
              const SizedBox(
                height: 25,
              ),
              SocialButton(
                url: 'http://public@iugaza.edu.ps',
                icon: MdiIcons.gmail,
                iconColor: Colors.red[400]!,
                label: "Email",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
