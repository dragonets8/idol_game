import 'package:idol_game/generated/l10n.dart';
import 'package:idol_game/main.dart';
import 'package:idol_game/styles/styles.dart';
import 'package:idol_game/utils/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

const inProgressColor = Color(0xff5e6172);
const completeColor = Color(0xFF3978EA);
const todoColor = Color(0xffd1d2d7);

class ProcessTimelinePage extends StatefulWidget {
  @override
  _ProcessTimelinePageState createState() => _ProcessTimelinePageState();
}

class _ProcessTimelinePageState extends State<ProcessTimelinePage> {
  int _processIndex = 0;

  @override
  void initState() {
    super.initState();
    bus.on("guidetab", (args) {
      changeGuideTab(args[0]);
    });
  }

  changeGuideTab(int guideIndex) {
    if (!mounted) return;
    setState(() {
      _processIndex = guideIndex;
    });
  }

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Text(
          _titles[_processIndex],
          style: TextStyles.wallet_guide_bold24,
        ),
      ),
      Expanded(
          child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(
            space: 20.0,
            thickness: 4.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemExtentBuilder: (_, __) =>
              MediaQuery.of(context).size.width / _processes.length,
          oppositeContentsBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Icon(_icons[index], size: 24, color: getColor(index)),
            );
          },
          contentsBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                _processes[index],
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: getColor(index),
                    fontSize: 12),
              ),
            );
          },
          indicatorBuilder: (_, index) {
            var color;
            var child;
            if (index == _processIndex) {
              color = inProgressColor;
              child = Icon(
                Icons.edit,
                color: Colors.white,
                size: 12.0,
              );
            } else if (index < _processIndex) {
              color = completeColor;
              child = Icon(
                Icons.check,
                color: Colors.white,
                size: 12.0,
              );
            } else {
              color = todoColor;
            }

            if (index <= _processIndex) {
              return Stack(
                children: [
                  DotIndicator(
                    size: 23.0,
                    color: color,
                    child: child,
                  ),
                ],
              );
            } else {
              return Stack(
                children: [
                  OutlinedDotIndicator(
                    borderWidth: 4.0,
                    color: color,
                  ),
                ],
              );
            }
          },
          connectorBuilder: (_, index, type) {
            if (index > 0) {
              if (index == _processIndex) {
                final prevColor = getColor(index - 1);
                final color = getColor(index);
                List<Color> gradientColors;
                if (type == ConnectorType.start) {
                  gradientColors = [Color.lerp(prevColor, color, 0.5), color];
                } else {
                  gradientColors = [
                    prevColor,
                    Color.lerp(prevColor, color, 0.5)
                  ];
                }
                return DecoratedLineConnector(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                  ),
                );
              } else {
                return SolidLineConnector(
                  color: getColor(index),
                );
              }
            } else {
              return null;
            }
          },
          itemCount: _processes.length,
        ),
      ))
    ]);
  }
}

/// hardcoded bezier painter
///
BuildContext _context = navigatorKey.currentState.overlay.context;
final _processes = [
  S.of(_context).guide_name,
  S.of(_context).guide_mnemonic,
  S.of(_context).guide_verify,
  S.of(_context).guide_password
];
final _titles = [
  S.of(_context).wallet_name,
  S.of(_context).generate_mnemonic,
  S.of(_context).verify_mnemonic,
  S.of(_context).set_password
];
final _icons = [
  Octicons.credit_card,
  Octicons.file,
  Octicons.shield,
  Octicons.lock,
];
