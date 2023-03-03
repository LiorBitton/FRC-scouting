import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scouting_application/classes/global.dart';
import 'package:scouting_application/widgets/collectors/dropdown_collector.dart';
import 'package:scouting_application/widgets/menu_button.dart';
import 'package:scouting_application/widgets/menu_text_button.dart';

class GraphMaker extends StatefulWidget {
  GraphMaker({Key? key, required this.teamID}) : super(key: key);
  final String teamID;
  @override
  State<GraphMaker> createState() => _GraphMakerState();
}

class _GraphMakerState extends State<GraphMaker> {
  String y_value = "1";
  String x_value = "1";
  Widget graph = new Text("");
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
    if (initted) return List<String>.from(dataByKeys.keys);
    dataByKeys = genListsFromData(await getData(widget.teamID));
    List<String> res = List<String>.from(dataByKeys.keys);
    if (res.length > 0) {
      x_value = res[0];
      y_value = res[0];
    }
    initted = true;
    return res;
  }

  void init() async {}

  @override
  void initState() {
    init();
    super.initState();
  }

  //TODO add none to dropdowns
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Team ${widget.teamID} Graphs")),
        body: Column(
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
                      List<String> valueKeys = snapshot.data as List<String>;
                      for (String key in valueKeys) {
                        items.add(DropdownMenuItem(
                          child: Text(key),
                          value: key,
                        ));
                      }

                      return Column(children: [
                        Row(
                          children: [
                            Text("X:"),
                            DropdownButton(
                              value: x_value,
                              items: items,
                              onChanged: (val) {
                                if (val is String) {
                                  print(val);
                                  setState(() {
                                    x_value = val;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Y:"),
                            DropdownButton(
                              value: y_value,
                              items: items,
                              onChanged: (val) {
                                if (val is String) {
                                  print(val);
                                  setState(() {
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
            MenuTextButton(
                onPressed: () {
                  print("drawing..");
                  setState(
                    () {
                      drawGraph();
                    },
                  );
                },
                text: "Draw Graph"),
            (graph.runtimeType != Text)
                ? Stack(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.70,
                        child: Padding(
                            padding: const EdgeInsets.only(
                              right: 18,
                              left: 12,
                              top: 24,
                              bottom: 12,
                            ),
                            child: graph),
                      ),
                    ],
                  )
                : Text("")
          ],
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
    print("how");
    if (dataByKeys == null) {
      print("keys null");
      return;
    }
    if (!dataByKeys.containsKey(x_value) || !dataByKeys.containsKey(y_value)) {
      print("values not exeise");
      return;
    }
    print(x_value);
    print(y_value);
    List<dynamic> x_data = dataByKeys[x_value]!;
    List<dynamic> y_data = dataByKeys[y_value]!;
    if (x_data.length < 2 || y_data.length < 2) {
      print("not enough data");
      return;
    }
    Type? x_type = x_data[0].runtimeType == x_data[1].runtimeType
        ? x_data[0].runtimeType
        : null;
    Type? y_type = y_data[0].runtimeType == y_data[1].runtimeType
        ? y_data[0].runtimeType
        : null;
    if (x_type == null || y_type == null) {
      print("type mismatch");
      return;
    }
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
    print("=======");
    print(x_final_values);
    print(y_final_values);
    setState(() {
      print("in graph");
      graph = LineChart(createGraph(x_final_values, y_final_values));
    });
  }

  void createGrap2h(List<double> x, List<double> y) {}

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
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    return Text(value.toInt().toString(),
        style: style, textAlign: TextAlign.left);
  }

  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  LineChartData createGraph(List<double> x, List<double> y) {
    List<FlSpot> points = [];
    for (int i = 0; i < x.length; i++) {
      print(x[i].toString() + "," + y[i].toString());
      points.add(new FlSpot(i.toDouble(), y[i]));
    }
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
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
          sideTitles: SideTitles(showTitles: false),
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
      maxX: points.length.toDouble(),
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: points,
          // spots: const [
          //   FlSpot(0, 3.44),
          //   FlSpot(2.6, 3.44),
          //   FlSpot(4.9, 3.44),
          //   FlSpot(6.8, 3.44),
          //   FlSpot(8, 3.44),
          //   FlSpot(9.5, 3.44),
          //   FlSpot(11, 3.44),
          // ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
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
