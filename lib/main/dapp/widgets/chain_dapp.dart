import 'package:idol_game/main/dapp/models/dapp_entity.dart';
import 'package:idol_game/main/dapp/widgets/dapp_cell.dart';
import 'package:idol_game/styles/colors.dart';
import 'package:idol_game/styles/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChainDapp extends StatelessWidget {
  ChainDapp({Key key, this.chain, this.dappEntity, this.dappClick})
      : super(key: key);

  final String chain;
  final DappEntity dappEntity;
  final Function(DappConf) dappClick;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    itemCount: dappEntity == null ? 0 : getChainDapps().length,
                    itemBuilder: (BuildContext context, int index) {
                      return DappCell(
                          dapp: getChainDapps()[index],
                          isLast: index == getChainDapps().length - 1,
                          dappClick: (dapp) {
                            dappClick(dapp);
                          });
                    }))));
  }

  List<DappConf> getChainDapps() {
    Map<String, List<DappConf>> dappConfs = dappEntity.dappConfs;
    List<DappConf> chainDapps =
        (dappConfs["0"] + dappConfs["1"] + dappConfs["2"])
            .where((element) => element.chainName == chain)
            .toList();
    chainDapps.sort((a, b) => (b.displayWeight).compareTo(a.displayWeight));
    return chainDapps;
  }
}
