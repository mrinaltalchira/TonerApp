import 'package:Trako/color/colors.dart';
import 'package:Trako/model/dashboard.dart';
import 'package:Trako/network/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../pref_manager.dart';
import '../authFlow/signin.dart';

class CategoriesDashboard extends StatefulWidget {
  const CategoriesDashboard({Key? key}) : super(key: key);

  @override
  State<CategoriesDashboard> createState() => _CategoriesDashboardState();
}

double parseValueSafely(String value) {
  try {
    return double.parse(value);
  } catch (e) {
    print('Error parsing value: $value, Error: $e');
    return 0.0; // Return a default value or handle the error case
  }
}

class _CategoriesDashboardState extends State<CategoriesDashboard> {
  late Future<DashboardResponse> dashboardFuture;
  final ApiService _apiService = ApiService();
  List<GraphData>  graphData = [];

  @override
  void initState() {
    super.initState();
    dashboardFuture = getDashboard(context);
  }

  Future<DashboardResponse> getDashboard(BuildContext context) async {
    try {
      return await _apiService.getDashboard(context);
    } catch (e) {
      print('Error fetching dashboard: $e');
      throw Exception('Failed to fetch dashboard data.');
    }
  }

  String getCategoryTitle(int index, Details data) {
    switch (index) {
      case 0:
        return "Total Distribute\n${data.totalDistribute}";
      case 1:
        return "Total Return\n${data.totalReturn}";
      case 2:
        return "Today's Distribute\n${data.todayDistribute}";
      case 3:
        return "Today's Return\n${data.todayReturn}";
      default:
        return "";
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      dashboardFuture = getDashboard(context);
    });
    await dashboardFuture;
  }

  Details defaultData = Details(
    totalDistribute: "0",
    totalReturn: "0",
    todayDistribute: "0",
    todayReturn: "0",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DashboardResponse>(
        future: dashboardFuture,
        builder: (context, snapshot) {
          Details data = defaultData;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.hasError}');
          } else if (snapshot.hasData) {
            data = snapshot.data!.data.details;
            graphData = snapshot.data!.data.graphData;
          }

          print('Response data: $graphData');

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Dashboard",
                          style: TextStyle(
                            fontSize: 24.0,
                            color: colorFirstGrad,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.0),
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 1.2,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                // Handle onTap for each category item
                                // You can navigate to another screen or perform any action here
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                elevation: 3.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/ic_trako.png',
                                      width: 80,
                                      height: 40,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      snapshot.hasError
                                          ? ""
                                          : getCategoryTitle(index, data),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: 4,
                        ),
                        SizedBox(height: 24.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            // Adjusted aspect ratio for LineChart
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                            decoration: BoxDecoration(
                            color: colorMixGrad.withOpacity(.08),
                            borderRadius:
                            BorderRadius.circular(5.0),
                          ),
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: const Center(
                                       child: Text(
                                         'Monthly Dispatch and Receive Analysis',
                                         style: TextStyle(fontSize: 18),
                                       )),
                                 ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.00),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 12.0,
                                            height: 12.0,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(width: 4.0),
                                          Text(
                                            'Receive',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 12.0,
                                            height: 12.0,
                                            color: Colors.pink,
                                          ),
                                          SizedBox(width: 4.0),
                                          Text(
                                            'Dispatch',
                                            style: TextStyle(
                                                color: Colors.pink,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),

                                    legend: Legend(isVisible: false),
                                    // Enable tooltip
                                    tooltipBehavior:
                                        TooltipBehavior(enable: true),
                                    series: <ChartSeries>[
                                      LineSeries<GraphData, String>(
                                        dataSource: graphData,
                                        xValueMapper: (GraphData data, _) =>
                                            data.month,
                                        yValueMapper: (GraphData data, _) =>
                                            parseValueSafely(data.receive),
                                        name: 'Receive',
                                        // Enable data label
                                        dataLabelSettings:
                                            DataLabelSettings(isVisible: true),
                                      ),
                                      LineSeries<GraphData, String>(
                                        dataSource: graphData,
                                        xValueMapper: (GraphData data, _) =>
                                            data.month,
                                        yValueMapper: (GraphData data, _) =>
                                            parseValueSafely(data.dispatch),
                                        name: 'Dispatch',
                                        // Enable data label
                                        dataLabelSettings: DataLabelSettings(isVisible: true),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
