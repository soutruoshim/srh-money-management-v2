import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monsey/common/constant/colors.dart';
import 'package:monsey/common/util/helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/constant/styles.dart';
import '../../../common/model/chart_model.dart';
import '../../onboarding/bloc/user/bloc_user.dart';
import '../bloc/chart/bloc_chart.dart';

class PieChartCustom extends StatefulWidget {
  const PieChartCustom({Key? key, required this.typeAnalysis})
      : super(key: key);
  final String typeAnalysis;
  @override
  State<PieChartCustom> createState() => _PieChartCustomState();
}

class _PieChartCustomState extends State<PieChartCustom> {
  int _currentIndex = 0;
  String _title = 'All categories';
  double _balance = 1000;

  @override
  Widget build(BuildContext context) {
    final String symbol =
        BlocProvider.of<UserBloc>(context).userModel?.currencySymbol ?? '\$';
    final bool isIncome = widget.typeAnalysis == 'income';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BlocBuilder<ChartBloc, ChartState>(builder: (context, state) {
        if (state is ChartLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ChartLoaded) {
          List<ChartData> dataPieChart =
              isIncome ? state.dataIncomePieChart : state.dataExpensePieChart;
          dataPieChart = handleChartData(dataPieChart, isIncome);
          _balance = isIncome ? state.incomeTotal : state.expenseTotal;
          return SfCircularChart(annotations: [
            CircularChartAnnotation(
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_title, style: headline(color: black)),
                  Text(
                      '$symbol${_balance < 1 && _balance >= 0 ? '0' : ''}${formatMoney(context).format(_balance)}',
                      style: body(color: isIncome ? blueCrayola : redCrayola)),
                ],
              ),
            )
          ], series: <CircularSeries>[
            dataPieChart.isNotEmpty
                ? DoughnutSeries<ChartData, String>(
                    onPointTap: (pointInteractionDetails) {
                      setState(() {
                        _currentIndex = pointInteractionDetails.pointIndex!;
                        _title =
                            dataPieChart[_currentIndex].categoryModel!.name;
                        _balance = dataPieChart[_currentIndex].balance;
                      });
                    },
                    dataSource: dataPieChart,
                    dataLabelSettings: DataLabelSettings(
                        builder: (dynamic data, dynamic point, dynamic series,
                            pointIndex, seriesIndex) {
                          return Text('${point.y}%',
                              style: footnote(color: grey1));
                        },
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside),
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) =>
                        data.categoryModel!.name,
                    yValueMapper: (ChartData data, index) {
                      final int balanceTmp =
                          handleBalance(dataPieChart, index, _balance, data);

                      return balanceTmp;
                    },
                    radius: '80%',
                    explode: true,
                    explodeIndex: _currentIndex)
                : DoughnutSeries<ChartData, String>(
                    dataSource: [ChartData(grey4, balance: 0, trans: const [])],
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => '',
                    yValueMapper: (ChartData data, _) => 100,
                    radius: '80%'),
          ]);
        }
        return const SizedBox();
      }),
    );
  }
}
