import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:omega_dashboard/models/CircularData.dart';
import 'package:omega_dashboard/models/SalesDataWeekly.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../utils/format_rupiah.dart';
import 'custom_container.dart';

class CustomGraphicCategory extends StatefulWidget {
  final String? title;
  final String? graphtype;
  final Color? color;
  final List<SalesDataWeekly>? data;
  final List<CircularData> dataCircular;
  final List<CircularData>? dataCircularService;
  final List<CircularData>? dataCircularProduct;

  const CustomGraphicCategory(
      {super.key,
        this.title,
        this.graphtype,
        this.color,
        this.data,
        this.dataCircularProduct,
        this.dataCircularService,
        required this.dataCircular});

  @override
  State<CustomGraphicCategory> createState() => CustomGraphicCategoryState();
}

class CustomGraphicCategoryState extends State<CustomGraphicCategory> {
  String _selectedOption = 'qty';
  String startFrom = "Sunday";
  late List<CircularData> _circularData;
  CarouselSliderController buttonCarouselController =
  CarouselSliderController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hydrateFromWidget();
  }

  @override
  void didUpdateWidget(CustomGraphicCategory oldWidget) {
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
        child: Column(
          children: [
            SizedBox(
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
                      if (_selectedOption == "totalprice") {
                        return data.valuePrice;
                      } else {
                        return data.value;
                      }
                    },
                    dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        builder:
                            (data, point, series, pointIndex, seriesIndex) {
                          if (_selectedOption == "totalprice") {
                            return Text(
                                FormatRupiah.convertToIdr(point.y!.toInt(), 0)
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white));
                          } else if (_selectedOption == "persen") {
                            return Text('${point.y!.toStringAsFixed(2)} %',
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white));
                          } else {
                            return Text(point.y!.toInt().toString(),
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white));
                          }
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    height: 50,
                    child: Radio<String>(
                      value: 'persen',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          double totalQty = 0;
                          _circularData.clear();

                          _selectedOption = value!;
                          widget.dataCircular.forEach((action) {
                            totalQty = totalQty + action.value;
                          });

                          widget.dataCircular.forEach((action) {
                            double persenValue = (action.value / totalQty) * 100;
                            _circularData.add(CircularData(
                                action.label, persenValue, action.valuePrice!));
                          });
                        });
                      },
                    ),
                  ),
                  Text(
                    'Percentage',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 30,
                    height: 50,
                    child: Radio<String>(
                      value: 'qty',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                          _circularData = widget.dataCircular.toList();
                        });
                      },
                    ),
                  ),
                  Text(
                    'Qty',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 30,
                    height: 50,
                    child: Radio<String>(
                      value: 'totalprice',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                          _circularData = widget.dataCircular.toList();
                        });
                      },
                    ),
                  ),
                  Text(
                    'Total Price',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
