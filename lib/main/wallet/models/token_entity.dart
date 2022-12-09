class TokenEntityList {
  TokenEntityList({
    this.list,
  });

  List<TokenEntity> list;

  factory TokenEntityList.fromJson(Map<String, dynamic> json) =>
      TokenEntityList(
        list: List<TokenEntity>.from(
            json["list"].map((x) => TokenEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class TokenEntity {
  TokenEntity({
    this.id,
    this.walletId,
    this.tokenId,
    this.name,
    this.image,
    this.chain,
    this.chainName,
    this.display,
    this.isSelect,
    this.contract,
    this.decimals,
    this.coingecko,
    this.address,
    this.btcPrice,
    this.usdPrice,
    this.cnyPrice,
    this.balance,
    this.legalBalance,
    this.modify,
    this.priceTime,
  });

  int id;
  int walletId;
  int tokenId;
  String name;
  String image;
  String chain;
  String chainName;
  bool display;
  int isSelect;
  String contract;
  String decimals;
  String coingecko;
  String address;
  double btcPrice;
  double usdPrice;
  double cnyPrice;
  double balance;
  double legalBalance;
  int modify;
  int priceTime;

  factory TokenEntity.fromJson(Map<String, dynamic> json) => TokenEntity(
        id: json["id"],
        walletId: json["walletId"],
        tokenId: json["tokenId"],
        name: json["name"],
        image: json["image"],
        chain: json["chain"],
        chainName: json["chainName"],
        display: json["display"],
        isSelect: json["isSelect"],
        contract: json["contract"],
        decimals: json["decimals"],
        coingecko: json["coingecko"],
        address: json["address"],
        btcPrice: json["btcPrice"],
        usdPrice: json["usdPrice"],
        cnyPrice: json["cnyPrice"],
        balance: json["balance"],
        legalBalance: json["legalBalance"],
        modify: json["modify"],
        priceTime: json["priceTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "walletId": walletId,
        "tokenId": tokenId,
        "name": name,
        "image": image,
        "chain": chain,
        "chainName": chainName,
        "display": display,
        "isSelect": isSelect,
        "contract": contract,
        "decimals": decimals,
        "coingecko": coingecko,
        "address": address,
        "btcPrice": btcPrice,
        "usdPrice": usdPrice,
        "cnyPrice": cnyPrice,
        "balance": balance,
        "legalBalance": legalBalance,
        "modify": modify,
        "priceTime": priceTime,
      };
}
