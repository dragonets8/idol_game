class MyItem {
  String title;
  String image;

  MyItem({
    this.title,
    this.image,
  });

  factory MyItem.fromJson(Map<String, dynamic> json) => MyItem(
        title: json["title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
      };
}
