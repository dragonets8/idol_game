class LucidItem {
  LucidItem({
    this.number,
    this.name,
    this.amount,
    this.image,
  });
  String number;
  String name;
  String amount;
  String image;

  factory LucidItem.fromJson(Map<String, dynamic> json) => LucidItem(
        number: json["number"],
        name: json["name"],
        amount: json["amount"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "amount": amount,
        "image": image,
      };
}

class NFTItem {
  NFTItem({
    this.number,
    this.name,
    this.description,
    this.image,
  });
  String number;
  String name;
  String description;
  String image;

  factory NFTItem.fromJson(Map<String, dynamic> json) => NFTItem(
        name: json["name"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "image": image,
      };
}

class DreamCard {
  DreamCard({
    this.name,
    this.serial,
    this.description,
    this.image,
    this.attributes,
    this.externalUri,
  });
  String name;
  String serial;
  String description;
  String image;
  CardAttributes attributes;
  dynamic externalUri;

  factory DreamCard.fromJson(Map<String, dynamic> json) => DreamCard(
        name: json["name"],
        description: json["description"],
        image: json["image"],
        attributes: CardAttributes.fromJson(json["attributes"]),
        externalUri: json["external_uri"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "image": image,
        "attributes": attributes.toJson(),
        "external_uri": externalUri,
      };
}

class CardAttributes {
  CardAttributes({
    this.grade,
    this.fiveElement,
    this.generations,
    this.star,
    this.experience,
    this.hp,
    this.atk,
    this.win,
    this.lose,
    this.skills,
  });

  String grade;
  String fiveElement;
  int generations;
  int star;
  int experience;
  int hp;
  int atk;
  int win;
  int lose;
  List<dynamic> skills;

  factory CardAttributes.fromJson(Map<String, dynamic> json) => CardAttributes(
        grade: json["grade"],
        fiveElement: json["fiveElement"],
        generations: json["generations"],
        star: json["star"],
        experience: json["experience"],
        hp: json["hp"],
        atk: json["atk"],
        win: json["win"],
        lose: json["lose"],
        skills: List<dynamic>.from(json["skills"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "grade": grade,
        "fiveElement": fiveElement,
        "generations": generations,
        "star": star,
        "experience": experience,
        "hp": hp,
        "atk": atk,
        "win": win,
        "lose": lose,
        "skills": List<dynamic>.from(skills.map((x) => x)),
      };
}
