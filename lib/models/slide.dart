class Slide {
  // int? id;
  String? img;

  Slide({
    // required this.id,
    required this.img,
  });

  Slide.fromJson(Map<String, dynamic> json) {
    // id = json['id']!;
    img = json['img']!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = id;
    data['img'] = img;
    return data;
  }
}
