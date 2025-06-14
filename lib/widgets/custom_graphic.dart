import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:omega_dashboard/models/CircularData.dart';
import 'package:omega_dashboard/models/SalesDataWeekly.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../utils/format_rupiah.dart';
import 'custom_container.dart';

class CustomGraphic extends StatefulWidget {
  final String? title;
  final String? graphtype;
  final Color? color;
  final List<SalesDataWeekly>? data;
  final List<CircularData> dataCircular;
  final List<CircularData>? dataCircularService;
  final List<CircularData>? dataCircularProduct;

  const CustomGraphic(
      {super.key,
      this.title,
      this.graphtype,
      this.color,
      this.data,
      this.dataCircularProduct,
      this.dataCircularService,
      required this.dataCircular});

  @override
  State<CustomGraphic> createState() => CustomGraphicState();
}

class CustomGraphicState extends State<CustomGraphic> {
  String _selectedOption = 'qty';
  String startFrom = "Sunday";
  static List<CircularData> tempCircularData = [];
  static List<CircularData> tempCircularDataService = [];
  static List<CircularData> tempCircularDataProduct = [];
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 10, bottom: 10),
      child: CustomContainer(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: (widget.graphtype == 'dayofweeksales')
            ? dayOfWeekSales()
            : (widget.graphtype == 'hourlySales')
                ? hourlySales()
                : (widget.graphtype == 'netSalesVsInventory')
                    ? netSalesVsInventory()
                    : (widget.graphtype == 'mostsellingitem')
                        ? mostSellingItem()
                        : (widget.graphtype == 'Belowminimumstock')
                            ? bellowMinimumStock()
                            : mostSelling(),
      ),
    );
  }

  Widget dayOfWeekSales() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Start From',          // ← judul/label di atas
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              child: DropdownButton<String>(
                value: startFrom,
                style: TextStyle(
                  color: Colors.white
                ),
                items: <String>['Sunday', 'Monday'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    startFrom = value!;
                    List<SalesDataWeekly> temp = [];
                    if(value == "Monday"){
                      temp = widget.data!.toList();
                      widget.data!.remove(temp.where((test)=> test.day == "Sun").first);
                      widget.data!.add(temp.where((test)=> test.day == "Sun").first);
                    }else{
                      temp = widget.data!.toList();
                      widget.data!.remove(temp.where((test)=> test.day == "Sun").first);
                      widget.data!.insert(0,temp.where((test)=> test.day == "Sun").first);
                    }
                  });

                },
              ),
            ),
          ],
        ),
        SizedBox(
          width: 300,
          height:300,
          child: SfCartesianChart(
            backgroundColor: widget.color,
            title: ChartTitle(
                text: widget.title!.toUpperCase(),
                textStyle: TextStyle(color: Colors.white, fontSize: 12)),
            primaryXAxis: CategoryAxis(),
            series: <ColumnSeries<SalesDataWeekly, String>>[
              ColumnSeries<SalesDataWeekly, String>(
                  color: Colors.white,
                  dataSource: widget.data,
                  xValueMapper: (SalesDataWeekly datum, _) => datum.day,
                  yValueMapper: (SalesDataWeekly datum, _) => datum.sales,
                  dataLabelSettings:
                      const DataLabelSettings(isVisible: true, color: Colors.white))
            ],
          ),
        ),
      ],
    );
  }

  Widget hourlySales() {
    return SfCartesianChart(
      backgroundColor: widget.color,
      title: ChartTitle(
          text: widget.title!.toUpperCase(),
          textStyle: TextStyle(color: Colors.white)),
      primaryXAxis: CategoryAxis(
        isVisible: true,
      ),
      series: <StackedLineSeries<SalesDataWeekly, String>>[
        StackedLineSeries<SalesDataWeekly, String>(
            color: Colors.white,
            dataSource: widget.data,
            xValueMapper: (SalesDataWeekly datum, _) => datum.day,
            yValueMapper: (SalesDataWeekly datum, _) => datum.sales,
            dataLabelSettings:
                const DataLabelSettings(isVisible: false, color: Colors.white))
      ],
    );
  }

  Widget netSalesVsInventory() {
    return SfCartesianChart(
      backgroundColor: widget.color,
      title: ChartTitle(
          text: widget.title!.toUpperCase(),
          textStyle: const TextStyle(color: Colors.white)),
      primaryXAxis: const CategoryAxis(
        isVisible: true,
        maximumLabels: 30,
      ),
      series: <ColumnSeries<SalesDataWeekly, String>>[
        ColumnSeries<SalesDataWeekly, String>(
            color: Colors.white,
            dataSource: widget.data,
            xValueMapper: (SalesDataWeekly datum, _) => datum.day,
            yValueMapper: (SalesDataWeekly datum, _) => datum.sales,
            dataLabelSettings:
                const DataLabelSettings(isVisible: true, color: Colors.white))
      ],
    );
  }

  Widget mostSelling() {
    return Column(
      children: [
        (widget.title! == "Most Selling items")
            ? SizedBox(
                width: 300,
                height: 300,
                child: CarouselSlider(
                  items: [
                    SizedBox(
                      width: 300,
                      height: 300,
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
                            dataSource: tempCircularData,
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
                                builder: (data, point, series, pointIndex,
                                    seriesIndex) {
                                  if (_selectedOption == "totalprice") {
                                    return Text(
                                        FormatRupiah.convertToIdr(
                                                point.y!.toInt(), 0)
                                            .toString(),
                                        style: const TextStyle(fontSize: 10));
                                  } else if (_selectedOption == "persen") {
                                    return Text('${point.y.toString()} %',
                                        style: const TextStyle(fontSize: 10));
                                  } else {
                                    return Text(point.y!.toInt().toString(),
                                        style: const TextStyle(fontSize: 10));
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: 300,
                        height: 300,
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
                              dataSource: tempCircularDataProduct,
                              xValueMapper: (CircularData data, _) =>
                                  data.label,
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
                                  builder: (data, point, series, pointIndex,
                                      seriesIndex) {
                                    if (_selectedOption == "totalprice") {
                                      return Text(
                                          FormatRupiah.convertToIdr(
                                                  point.y!.toInt(), 0)
                                              .toString(),
                                          style: const TextStyle(fontSize: 10));
                                    } else if (_selectedOption == "persen") {
                                      return Text('${point.y.toString()} %',
                                          style: const TextStyle(fontSize: 10));
                                    } else {
                                      return Text(point.y!.toInt().toString(),
                                          style: const TextStyle(fontSize: 10));
                                    }
                                  }),
                            ),
                          ],
                        )),
                    SizedBox(
                      width: 300,
                      height: 300,
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
                            dataSource: tempCircularDataService,
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
                                builder: (data, point, series, pointIndex,
                                    seriesIndex) {
                                  if (_selectedOption == "totalprice") {
                                    return Text(
                                        FormatRupiah.convertToIdr(
                                                point.y!.toInt(), 0)
                                            .toString(),
                                        style: const TextStyle(fontSize: 10));
                                  } else if (_selectedOption == "persen") {
                                    return Text('${point.y.toString()} %',
                                        style: const TextStyle(fontSize: 10));
                                  } else {
                                    return Text(point.y!.toInt().toString(),
                                        style: const TextStyle(fontSize: 10));
                                  }
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                  options: CarouselOptions(
                    scrollDirection: Axis.horizontal,
                    scrollPhysics: ScrollPhysics(),
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    aspectRatio: 1,
                  ),
                ),
              )
            : SizedBox(
                width: 300,
                height: 300,
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
                      dataSource: tempCircularData,
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
                                  style: const TextStyle(fontSize: 10));
                            } else if (_selectedOption == "persen") {
                              return Text('${point.y.toString()} %',
                                  style: const TextStyle(fontSize: 10));
                            } else {
                              return Text(point.y!.toInt().toString(),
                                  style: const TextStyle(fontSize: 10));
                            }
                          }),
                    ),
                  ],
                ),
              ),
        SizedBox(
          child: Row(
            children: [
              SizedBox(
                width: 30,
                height: 50,
                child: Radio<String>(
                  value: 'persen',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      final Random random = Random();
                      double totalQty = 0;
                      tempCircularData.clear();

                      _selectedOption = value!;
                      widget.dataCircular.forEach((action) {
                        totalQty = totalQty + action.value;
                      });

                      widget.dataCircular.forEach((action) {
                        double persenValue = (action.value / totalQty) * 100;
                        tempCircularData.add(CircularData(
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
                      tempCircularData = widget.dataCircular.toList();
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
                      tempCircularData = widget.dataCircular.toList();
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
    );
  }

  Widget mostSellingItem() {
    return Column(
      children: [
        SizedBox(
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: TextButton(
                  onPressed: () => buttonCarouselController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear),
                  child: const Icon(Icons.chevron_left, color: Colors.white),
                ),
              ),
              SizedBox(
                width: 230,
                height: 300,
                child: CarouselSlider(
                  items: [
                    SizedBox(
                      width: 300,
                      height: 300,
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
                            dataSource: tempCircularData,
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
                                builder: (data, point, series, pointIndex,
                                    seriesIndex) {
                                  if (_selectedOption == "totalprice") {
                                    return Text(
                                        FormatRupiah.convertToIdr(
                                                point.y!.toInt(), 0)
                                            .toString(),
                                        style: const TextStyle(fontSize: 10));
                                  } else if (_selectedOption == "persen") {
                                    return Text('${point.y.toString()} %',
                                        style: const TextStyle(fontSize: 10));
                                  } else {
                                    return Text(point.y!.toInt().toString(),
                                        style: const TextStyle(fontSize: 10));
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: 300,
                        height: 300,
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
                              text: "Most Selling product".toUpperCase(),
                              textStyle: const TextStyle(color: Colors.white)),
                          series: <CircularSeries<CircularData, String>>[
                            PieSeries<CircularData, String>(
                              dataSource: tempCircularDataProduct,
                              xValueMapper: (CircularData data, _) =>
                                  data.label,
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
                                  builder: (data, point, series, pointIndex,
                                      seriesIndex) {
                                    if (_selectedOption == "totalprice") {
                                      return Text(
                                          FormatRupiah.convertToIdr(
                                                  point.y!.toInt(), 0)
                                              .toString(),
                                          style: const TextStyle(fontSize: 10));
                                    } else if (_selectedOption == "persen") {
                                      return Text('${point.y.toString()} %',
                                          style: const TextStyle(fontSize: 10));
                                    } else {
                                      return Text(point.y!.toInt().toString(),
                                          style: const TextStyle(fontSize: 10));
                                    }
                                  }),
                            ),
                          ],
                        )),
                    SizedBox(
                      width: 300,
                      height: 300,
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
                            text: "Most Selling service".toUpperCase(),
                            textStyle: const TextStyle(color: Colors.white)),
                        series: <CircularSeries<CircularData, String>>[
                          PieSeries<CircularData, String>(
                            dataSource: tempCircularDataService,
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
                                builder: (data, point, series, pointIndex,
                                    seriesIndex) {
                                  if (_selectedOption == "totalprice") {
                                    return Text(
                                        FormatRupiah.convertToIdr(
                                                point.y!.toInt(), 0)
                                            .toString(),
                                        style: const TextStyle(fontSize: 10));
                                  } else if (_selectedOption == "persen") {
                                    return Text('${point.y.toString()} %',
                                        style: const TextStyle(fontSize: 10));
                                  } else {
                                    return Text(point.y!.toInt().toString(),
                                        style: const TextStyle(fontSize: 10));
                                  }
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    scrollDirection: Axis.horizontal,
                    scrollPhysics: ScrollPhysics(),
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    aspectRatio: 1,
                  ),
                ),
              ),
              SizedBox(
                width: 30,
                child: TextButton(
                  onPressed: () => buttonCarouselController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: Row(
            children: [
              SizedBox(
                width: 30,
                height: 50,
                child: Radio<String>(
                  value: 'persen',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      final Random random = Random();
                      double totalQty = 0;
                      double totalQtyService = 0;
                      double totalQtyProduct = 0;

                      tempCircularData.clear();
                      tempCircularDataService.clear();
                      tempCircularDataProduct.clear();

                      _selectedOption = value!;
                      widget.dataCircular.forEach((action) {
                        totalQty = totalQty + action.value;
                      });
                      widget.dataCircularProduct!.forEach((action) {
                        totalQtyProduct = totalQtyProduct + action.value;
                      });
                      widget.dataCircularService!.forEach((action) {
                        totalQtyService = totalQtyService + action.value;
                      });

                      widget.dataCircular.forEach((action) {
                        double persenValue = (action.value / totalQty) * 100;
                        tempCircularData.add(CircularData(
                            action.label, persenValue, action.valuePrice!));
                      });
                      widget.dataCircularService!.forEach((action) {
                        double persenValue = (action.value / totalQty) * 100;
                        tempCircularDataService.add(CircularData(
                            action.label, persenValue, action.valuePrice!));
                      });
                      widget.dataCircularProduct!.forEach((action) {
                        double persenValue = (action.value / totalQty) * 100;
                        tempCircularDataProduct.add(CircularData(
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
                      tempCircularData = widget.dataCircular.toList();
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
                      tempCircularData = widget.dataCircular.toList();
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
    );
  }

  Widget bellowMinimumStock() {
    return SfCartesianChart(
      backgroundColor: widget.color,
      title: ChartTitle(
          text: widget.title!.toUpperCase(),
          textStyle: TextStyle(color: Colors.white)),
      primaryXAxis: CategoryAxis(
        isInversed: true,                 // ← urutan label dibalik
        labelRotation: 0,
      ),
      // primaryYAxis: NumericAxis(
      //   isInversed: true,
      // ),
      series: <BarSeries<SalesDataWeekly, String>>[
        BarSeries(
          dataSource: widget.data,
          xValueMapper: (SalesDataWeekly data, _) => data.day,
          yValueMapper: (SalesDataWeekly data, _) => data.sales,
        ),
        BarSeries(
          dataSource: widget.data,
          xValueMapper: (SalesDataWeekly data, _) => data.day,
          yValueMapper: (SalesDataWeekly data, _) => 0,
        )
      ],
    );
  }
}
