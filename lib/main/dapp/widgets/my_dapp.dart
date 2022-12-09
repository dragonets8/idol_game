import 'package:idol_game/database/dapp_database.dart';
import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main/dapp/models/dapp_entity.dart';
import 'package:idol_game/main/dapp/widgets/dapp_cell.dart';
import 'package:idol_game/main/widgets/empty_widgets.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDapp extends StatefulWidget {
  MyDapp({Key key, this.dappClick}) : super(key: key);
  final Function(DappConf) dappClick;

  @override
  MyDappState createState() => MyDappState();
}

class MyDappState extends State<MyDapp> {
  List<DappConf> myDapps = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      queryMyDapps();
      bus.on("refresh_my_dapp", (args) {
        queryMyDapps();
      });
    });
  }

  queryMyDapps() {
    DappDB().queryAllDapp((dapps) {
      setState(() {
        myDapps = dapps;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return myDapps.length == 0
        ? EmptyWidgets.listEmpty(S.of(context).transaction_no_data)
        : Container(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
            child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    width: Screen.width - 40,
                    color: Colours.bg_dark,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: myDapps.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DappCell(
                              dapp: myDapps[index],
                              isLast: index == myDapps.length - 1,
                              dappClick: (dapp) {
                                widget.dappClick(dapp);
                              });
                        }))));
  }
}
