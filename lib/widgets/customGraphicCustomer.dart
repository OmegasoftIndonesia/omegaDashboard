import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:omega_dashboard/models/CircularData.dart';
import 'package:omega_dashboard/models/SalesDataWeekly.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../utils/format_rupiah.dart';
import 'custom_container.dart';

class CustomGraphicCustomer extends StatefulWidget {
  final String? title;
  final String? graphtype;
  final Color? color;
  final List<SalesDataWeekly>? data;
  final List<CircularData> dataCircular;
  final List<CircularData>? dataCircularService;
  final List<CircularData>? dataCircularProduct;

  const CustomGraphicCustomer(
      {super.key,
        this.title,
        this.graphtype,
        this.color,
        this.data,
        this.dataCircularProduct,
        this.dataCircularService,
        required this.dataCircular});

  @override
  State<CustomGraphicCustomer> createState() => CustomGraphicCustomerState();
}

class CustomGraphicCustomerState extends State<CustomGraphicCustomer> {
  late List<CircularData> _circularData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hydrateFromWidget();
  }

  @override
  void didUpdateWidget(CustomGraphicCustomer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataCircular != widget.dataCircular) {
      _hydrateFromWidget();
    }
  }

  /// put copies of the incoming lists into the local (non‑static) state
  void _hydrateFromWidget() {
    _circularData         = List<CircularData>.from(widget.dataCircular ?? []);
    setState(() {});              // rebuild the charts
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 10, bottom: 10),
      child: CustomContainer(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: SizedBox(
          width: 500,
          height: 500,
          child: SfCircularChart(
            backgroundColor: widget.color,
            legend: const Legend(
              isVisible: true,
              // Show the legend
              position: LegendPosition.auto,
              // Top, bottom, left, right
              overflowMode: LegendItemOverflowMode.wrap,
              // Avoid clipping
              textStyle: TextStyle(color: Colors.white),
              toggleSeriesVisibility: true,
            ),
            title: ChartTitle(
                text: widget.title!.toUpperCase(),
                textStyle: const TextStyle(color: Colors.white)),
            series: <CircularSeries<CircularData, String>>[
              PieSeries<CircularData, String>(
                dataSource: _circularData,
                xValueMapper: (CircularData data, _) => data.label,
                yValueMapper: (CircularData data, _) {
                  double total=0;
                  _circularData.forEach((action){
                    total = total+action.value;
                  });

                  double persenValue = (data.value / total) * 100;

                  return persenValue;
                },
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    builder:
                        (data, point, series, pointIndex, seriesIndex) {



                          return Text('${point.y!.toStringAsFixed(2)} %',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
