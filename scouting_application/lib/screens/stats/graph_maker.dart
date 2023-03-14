//TODO
// -Allow users to star a chart type, each time they will enter this screen,
// show their favorite graphs
// -comparison between teams?
//

//

import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/themes/custom_themes.dart';
import 'package:scouting_application/widgets/collectors/dropdown_collector.dart';
import 'package:scouting_application/widgets/menu_button.dart';
import 'package:scouting_application/widgets/menu_text_button.dart';
import 'dart:math';

class GraphMaker extends StatefulWidget {
  GraphMaker({Key? key, required this.teamID}) : super(key: key);
  final String teamID;
  @override
  State<GraphMaker> createState() => _GraphMakerState();
}

class _GraphMakerState extends State<GraphMaker> {
  String y_value = "none";
  String x_value = "none";
  bool hasData = false;
  bool isDarkMode = false;
  bool shouldDrawGraph = false;
  List<LineChart> graph = [];
  bool initted = false;
  late Map<String, List<dynamic>> dataByKeys;
  Future<Map<String, dynamic>> getData(String teamKey) async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref(
            'teams/${widget.teamID}/events/${Global.instance.currentEventKey}/gms')
        .get();
    if (!snapshot.exists || snapshot.value == null) {
      return {};
    }
    try {
      Map<String, dynamic> res =
          Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

      return res;
    } catch (e) {
      print("error converting value to map, " +
          snapshot.value.runtimeType.toString() +
          " to Map<String, Map<String, dynamic>>");
    }
    return {};
  }

  Map<String, List<dynamic>> genListsFromData(Map<String, dynamic> data) {
    List<String> sortedKeys = List<String>.from(data.keys);
    sortedKeys.sort(compareGameKeys);
    Map<String, List<dynamic>> res = {};
    for (String gameKey in sortedKeys) {
      Map<String, dynamic> gameData = Map<String, dynamic>.from(data[gameKey]!);
      for (String valueKey in gameData.keys) {
        if (res[valueKey] == null) {
          res[valueKey] = [];
        }
        res[valueKey]!.add(gameData[valueKey]);
      }
    }
    return res;
  }

  Future<List<String>> getGraphOptions() async {
    if (initted) {
      List<String> ret = List<String>.from(dataByKeys.keys);
      ret.add("none");
      return ret;
    }

    dataByKeys = genListsFromData(await getData(widget.teamID));
    List<String> res = List<String>.from(dataByKeys.keys);
    if (res.length > 0) {
      x_value = "none";
      y_value = "none";
    }
    res.add("none");
    initted = true;
    return res;
  }

  void init() async {}

  @override
  void initState() {
    init();
    super.initState();
  }

  String gamePartToPartName(String part) {
    switch (part) {
      case "en":
        return "==Endgame==";
      case "te":
        return "==Teleop==";
      case "au":
        return "==Auto==";
      case "ge":
        return "==General==";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(title: Text("Team ${widget.teamID} Graphs")),
        body: Container(
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<List<String>>(
                            future: getGraphOptions(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              List<DropdownMenuItem<String>> items = [];
                              List<String> valueKeys =
                                  snapshot.data as List<String>;
                              if (valueKeys == null || valueKeys.length <= 1) {
                                return Center(
                                  child: Text(
                                    "No data for this team, try again later",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                              }
                              hasData = true;
                              valueKeys.sort();
                              valueKeys.remove("bluAll");
                              String prefix = "";

                              for (String key in valueKeys) {
                                String displayName = key;
                                String gamePartPrefix = key.split("_")[0];
                                if (gamePartPrefix != prefix) {
                                  String partName =
                                      gamePartToPartName(gamePartPrefix);
                                  if (partName != "") {
                                    items.add(DropdownMenuItem(
                                      child: Text(partName),
                                      enabled: false,
                                      value: null,
                                    ));
                                    prefix = gamePartPrefix;
                                  }
                                }
                                displayName =
                                    displayName.replaceFirst(prefix + "_", "");
                                items.add(DropdownMenuItem(
                                  child: Text(displayName),
                                  value: key,
                                ));
                              }

                              return Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    DropdownButton(
                                      value: x_value,
                                      items: items,
                                      iconEnabledColor: Colors.cyan,
                                      iconSize: 32.0,
                                      onChanged: (val) {
                                        if (val is String) {
                                          if (x_value != val)
                                            shouldDrawGraph = true;
                                          setState(() {
                                            x_value = val;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    DropdownButton(
                                      value: y_value,
                                      iconSize: 32.0,
                                      iconEnabledColor: Colors.purple,
                                      items: items,
                                      onChanged: (val) {
                                        if (val is String) {
                                          setState(() {
                                            if (y_value != val)
                                              shouldDrawGraph = true;
                                            y_value = val;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ]);
                            }),
                      ],
                    ),
                    hasData
                        ? MenuTextButton(
                            onPressed: shouldDrawGraph
                                ? () {
                                    setState(
                                      () {
                                        drawGraph();
                                        shouldDrawGraph = false;
                                      },
                                    );
                                  }
                                : null,
                            text: "Draw Graph")
                        : Text(""),
                  ],
                ),
                graph.length == 0
                    ? Text("")
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 12,
                                      left: 6,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: graph[index]),
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    10, 10, 10, 10),
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: isDarkMode
                                      ? Colors.grey[900]!
                                      : Colors.white24,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //       //bottom shadow
                                  //       color: isDarkMode
                                  //           ? Colors.grey[800]!
                                  //           : Colors.grey[600]!,
                                  //       blurRadius: isDarkMode ? 2 : 15,
                                  //       offset: const Offset(4, 4),
                                  //       spreadRadius: isDarkMode ? 0.01 : 1),
                                  //   BoxShadow(
                                  //       //top shadow
                                  //       color: isDarkMode
                                  //           ? Colors.grey[400]!
                                  //           : Colors.white,
                                  //       blurRadius: isDarkMode ? 0 : 02,
                                  //       offset: const Offset(-4, -4),
                                  //       spreadRadius: isDarkMode ? 0.03 : 1)
                                  // ],
                                ));
                          },
                          itemCount: graph.length,
                        ),
                      ),
              ],
            ),
          ),
        ));
  }

  int compareGameKeys(String gameKeyA, gameKeyB) {
    bool rfa = gameKeyA.startsWith("rf");
    bool rfb = gameKeyB.startsWith("rf");
    if (rfa && rfb) {
      int matcha = int.parse(gameKeyA.substring(2));
      int matchb = int.parse(gameKeyB.substring(2));
      return matcha.compareTo(matchb);
    } else if (rfa) {
      return -1;
    } else if (rfb) {
      return 1;
    }

    //yyyy[EVENT_CODE]_[COMP_LEVEL]m[MATCH_NUMBER]
    int stageEqual = gameKeyA // _[COMP_LEVEL]m
        .substring(0, gameKeyA.lastIndexOf("m"))
        .compareTo(gameKeyB.substring(0, gameKeyB.lastIndexOf("m")));
    if (stageEqual != 0) {
      return stageEqual;
    }
    //if match stage is not different, compare by match number
    return int.parse(gameKeyA.substring(gameKeyA.lastIndexOf("m") + 1)) -
        int.parse(
            gameKeyB.substring(gameKeyB.lastIndexOf("m") + 1)); //[MATCH_NUMBER]
  }

  void drawGraph() {
    if (dataByKeys == null) {
      print("keys null");
      return;
    }
    if (!dataByKeys.containsKey(x_value) && !dataByKeys.containsKey(y_value)) {
      print("values do not exist");
      return;
    }
    List<dynamic> x_data = [];
    List<dynamic> y_data = [];
    if (x_value != "none" && dataByKeys.containsKey(x_value)) {
      x_data = dataByKeys[x_value]!;
    }
    if (y_value != "none" && dataByKeys.containsKey(y_value)) {
      y_data = dataByKeys[y_value]!;
    }
    if (x_data.length < 2 && y_data.length < 2) {
      print("not enough data");
      return;
    }
    Type? x_type = null;
    Type? y_type = null;
    if (x_data.length >= 2) {
      x_type = x_data[0].runtimeType == x_data[1].runtimeType
          ? x_data[0].runtimeType
          : null;
    }
    if (y_data.length >= 2) {
      y_type = y_data[0].runtimeType == y_data[1].runtimeType
          ? y_data[0].runtimeType
          : null;
    }
    if (x_type == null && y_type == null) {
      print("type mismatch");
      return;
    }
    List<String> x_hints = [];
    List<String> y_hints = [];
    List<double> x_final_values = [];
    //figure the types
    for (dynamic value in x_data) {
      if (value.runtimeType != x_type) continue;
      if (value.runtimeType == bool) {
        x_final_values.add(value ? 1.0 : 0.0);
      } else if (value.runtimeType == int) {
        x_final_values.add(value.toDouble());
      } else if (value.runtimeType == double) {
        x_final_values.add(value);
      }
    }
    List<double> y_final_values = [];
    //figure the types
    for (dynamic value in y_data) {
      if (value.runtimeType != y_type) continue;
      if (value.runtimeType == bool) {
        y_final_values.add(value ? 1 : 0);
      } else if (value.runtimeType == int) {
        y_final_values.add(value.toDouble());
      } else if (value.runtimeType == double) {
        y_final_values.add(value);
      }
    }
    String graphName = "";
    bool addedFirst = false;

    if (x_value != "none") {
      String formatted = x_value;
      String rem = x_value.split("_")[0];
      formatted = formatted.replaceFirst(rem + "_", "");
      graphName += formatted;
      addedFirst = true;
    }
    if (y_value != "none") {
      String formatted = y_value;
      String rem = y_value.split("_")[0];
      formatted = formatted.replaceFirst(rem + "_", "");
      graphName += addedFirst ? (" & " + formatted) : formatted;
    }
    setState(() {
      graph.insert(
          0, LineChart(createGraph(x_final_values, y_final_values, graphName)));
    });
  }

  void x_callback(String? val) {
    if (val is String) {
      setState(() {
        x_value = val;
      });
    }
  }

  void y_callback(String? val) {
    if (val is String) {
      setState(() {
        y_value = val;
      });
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
    );

    return Text(value.toInt().toString(),
        style: style, textAlign: TextAlign.center);
  }

  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  LineChartData createGraph(List<double> x, List<double> y, String graphName,
      {List<String> xhints = const [], List<String> yhints = const []}) {
    List<FlSpot> pointsX = [];
    List<FlSpot> pointsY = [];
    bool hasXHints = xhints.length != 0;
    bool hasYHints = yhints.length != 0;
    double maxY = 0;
    for (int i = 0; i < x.length; i++) {
      if (x[i] > maxY) {
        maxY = x[i];
      }

      pointsX.add(new FlSpot(i.toDouble(), x[i]));
    }
    for (int i = 0; i < y.length; i++) {
      if (y[i] > maxY) {
        maxY = y[i];
      }
      pointsY.add(new FlSpot(i.toDouble(), y[i]));
    }
    ++maxY;
    double maxLength = max(x.length, y.length).toDouble();
    return LineChartData(
      lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              getTooltipItems: hasXHints
                  ? (touches) {
                      List<LineTooltipItem> res = [];
                      for (LineBarSpot barSpot in touches) {
                        print(barSpot.spotIndex);
                        res.add(LineTooltipItem(xhints[barSpot.spotIndex],
                            TextStyle(color: Colors.white)));
                      }
                      return res;
                    }
                  : null)),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          axisNameWidget: Container(
              child: Padding(
            padding: const EdgeInsets.only(
              right: 12,
              left: 12,
              top: 10,
              bottom: 10,
            ),
            child: Text(
              graphName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          )),
          axisNameSize: 80,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: maxLength,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        getBarData(pointsX),
        getBarData(pointsY),
        // LineChartBarData(
        //   spots: pointsX,
        //   isCurved: true,
        //   gradient: LinearGradient(
        //     colors: [
        //       ColorTween(begin: gradientColors[0], end: gradientColors[1])
        //           .lerp(0.2)!,
        //       ColorTween(begin: gradientColors[0], end: gradientColors[1])
        //           .lerp(0.2)!,
        //     ],
        //   ),
        //   barWidth: 5,
        //   isStrokeCapRound: true,
        //   dotData: FlDotData(
        //     show: false,
        //   ),
        //   belowBarData: BarAreaData(
        //     show: true,
        //     gradient: LinearGradient(
        //       colors: [
        //         ColorTween(begin: gradientColors[0], end: gradientColors[1])
        //             .lerp(0.2)!
        //             .withOpacity(0.1),
        //         ColorTween(begin: gradientColors[0], end: gradientColors[1])
        //             .lerp(0.2)!
        //             .withOpacity(0.1),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  int count = 0;
  LineChartBarData getBarData(List<FlSpot> points) {
    List<Color> colors = [];
    if (count == 0) {
      colors = [
        ColorTween(begin: Colors.cyan, end: Colors.cyan).lerp(0.2)!,
        ColorTween(begin: Colors.cyan, end: Colors.cyan).lerp(0.2)!
      ];
    } else {
      colors = [
        ColorTween(begin: Colors.purple, end: Colors.purple).lerp(0.2)!,
        ColorTween(begin: Colors.purple, end: Colors.purple).lerp(0.2)!
      ];
      count = -1;
    }
    ++count;
    return LineChartBarData(
      spots: points,
      isCurved: false,
      gradient: LinearGradient(
        colors: colors,
      ),
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      // belowBarData: BarAreaData(
      //   show: true,
      //   gradient: LinearGradient(
      //     colors: [
      //       ColorTween(begin: gradientColors[0], end: gradientColors[1])
      //           .lerp(0.2)!
      //           .withOpacity(0.1),
      //       ColorTween(begin: gradientColors[0], end: gradientColors[1])
      //           .lerp(0.2)!
      //           .withOpacity(0.1),
      //     ],
      //   ),
      // ),
    );
  }
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
