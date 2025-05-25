import 'package:covid_app/Model/world_staes_model.dart';
import 'package:covid_app/Services/states.services.dart';
import 'package:covid_app/view/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

// used pie_Chart Library

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: Duration(seconds: 8), vsync: this)
        ..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final List<Color> colorList = [
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            FutureBuilder(
              future: statesServices.fetchworldStatesRecords(),
              builder: (context, AsyncSnapshot<WorldStaesModel> snapshot) {
                if (!snapshot.hasData) {
                  return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50,
                        controller: _controller,
                      ));
                } else {
                  return Column(
                    children: [
                      // piechart for golad chart
                      PieChart(
                        dataMap: {
                          "Total":
                              double.parse(snapshot.data!.cases!.toString()),
                          "Recovered":
                              double.parse(snapshot.data!.recovered.toString()),
                          "Deaths":
                              double.parse(snapshot.data!.deaths!.toString()),
                        },
                        chartValuesOptions: ChartValuesOptions(
                          showChartValuesInPercentage: true,
                        ),
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                        legendOptions:
                            LegendOptions(legendPosition: LegendPosition.left),
                        animationDuration: Duration(milliseconds: 2500),
                        chartType: ChartType.ring,
                        colorList: colorList,
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * .06),
                        child: Card(
                          child: Column(
                            children: [
                              ReasubleRow(
                                  title: 'Total',
                                  value: snapshot.data!.cases.toString()),
                              ReasubleRow(
                                  title: 'Deaths',
                                  value: snapshot.data!.deaths.toString()),
                              ReasubleRow(
                                  title: 'Recovered',
                                  value: snapshot.data!.recovered.toString()),
                              ReasubleRow(
                                  title: 'Active',
                                  value: snapshot.data!.active.toString()),
                              ReasubleRow(
                                  title: 'Critical',
                                  value: snapshot.data!.critical.toString()),
                              ReasubleRow(
                                  title: 'Today Death',
                                  value: snapshot.data!.todayDeaths.toString()),
                              ReasubleRow(
                                  title: 'Today Recover',
                                  value:
                                      snapshot.data!.todayRecovered.toString()),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CountriesListScreen()));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xff1aa260),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text('Track Country'),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      )),
    );
  }
}

class ReasubleRow extends StatelessWidget {
  String title, value;

  ReasubleRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
        ],
      ),
    );
  }
}
