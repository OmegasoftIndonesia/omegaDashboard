import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final List<CircularData>? dataCircular;
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
      this.dataCircular});

  @override
  State<CustomGraphic> createState() => CustomGraphicState();
}

class CustomGraphicState extends State<CustomGraphic> {
  String _selectedOption = 'qty';
  String startFrom = "Sunday";
  late List<SalesDataWeekly> _dataGrafik;
  late List<CircularData> _circularData;
  late List<CircularData> _circularDataService;
  late List<CircularData> _circularDataProduct;
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hydrateFromWidget();
  }

  @override
  void didUpdateWidget(CustomGraphic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataCircular != widget.dataCircular ||
        oldWidget.data != widget.data ||
        oldWidget.dataCircularService != widget.dataCircularService ||
        oldWidget.dataCircularProduct != widget.dataCircularProduct) {
      _hydrateFromWidget();
    }
  }

  /// put copies of the incoming lists into the local (non‑static) state
  void _hydrateFromWidget() {
    _dataGrafik = List<SalesDataWeekly>.from(widget.data ?? []);
    _circularData = List<CircularData>.from(widget.dataCircular ?? []);
    _circularDataService =
        List<CircularData>.from(widget.dataCircularService ?? []);
    _circularDataProduct =
        List<CircularData>.from(widget.dataCircularProduct ?? []);
    setState(() {}); // rebuild the charts
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
                            : (widget.graphtype == 'mostselling')
                                ? mostSelling()
                                : SizedBox(),
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
              'Start From', // ← judul/label di atas
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              child: DropdownButton<String>(
                value: startFrom,
                dropdownColor: Colors.black,
                items: <String>['Sunday', 'Monday'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    startFrom = value!;
                    List<SalesDataWeekly> temp = [];
                    if (value == "Monday") {
                      temp = _dataGrafik.toList();
                      _dataGrafik.remove(
                          temp.where((test) => test.day == "Sun").first);
                      _dataGrafik
                          .add(temp.where((test) => test.day == "Sun").first);
                    } else {
                      temp = _dataGrafik.toList();
                      _dataGrafik.remove(
                          temp.where((test) => test.day == "Sun").first);
                      _dataGrafik.insert(
                          0, temp.where((test) => test.day == "Sun").first);
                    }
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(
          width: 500,
          height: 500,
          child: SfCartesianChart(
            backgroundColor: widget.color,
            // zoomPanBehavior: ZoomPanBehavior(
            //   enablePanning: true,
            //   enablePinching: true,
            //   zoomMode: ZoomMode.x,
            // ),
            title: ChartTitle(
                text: widget.title!.toUpperCase(),
                textStyle: TextStyle(color: Colors.white, fontSize: 12)),
            primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.none,
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              labelAlignment: LabelAlignment.center,
              //labelRotation: 45,
            ),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.decimalPattern('id_ID'),
            ),
            series: <ColumnSeries<SalesDataWeekly, String>>[
              ColumnSeries<SalesDataWeekly, String>(
                  color: Colors.white,
                  dataSource: _dataGrafik,
                  xValueMapper: (SalesDataWeekly datum, _) => datum.day,
                  yValueMapper: (SalesDataWeekly datum, _) => datum.sales,
                  dataLabelSettings: DataLabelSettings(
                    angle: -90,
                    isVisible: true,
                    color: Colors.white,
                    showZeroValue: true,
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    textStyle: TextStyle(fontSize: 7),
                    overflowMode:
                        OverflowMode.shift,
                    // builder: (data, point, series, pointIndex,
                    // seriesIndex){
                    //
                    // }
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget hourlySales() {
    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
        zoomMode: ZoomMode.x,
      ),
      backgroundColor: widget.color,
      title: ChartTitle(
          text: widget.title!.toUpperCase(),
          textStyle: TextStyle(color: Colors.white, fontSize: 12)),
      primaryXAxis: CategoryAxis(
        isVisible: true,
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.decimalPattern('id_ID'),
        labelRotation: 90,
      ),
      series: <StackedLineSeries<SalesDataWeekly, String>>[
        StackedLineSeries<SalesDataWeekly, String>(
            color: Colors.white,
            dataSource: _dataGrafik,
            xValueMapper: (SalesDataWeekly datum, _) => datum.day,
            yValueMapper: (SalesDataWeekly datum, _) => datum.sales,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              color: Colors.white,
              showZeroValue: true,
            ))
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
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.decimalPattern('id_ID'
        ),
      ),
      series: <ColumnSeries<SalesDataWeekly, String>>[
        ColumnSeries<SalesDataWeekly, String>(
            color: Colors.white,
            dataSource: _dataGrafik,
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
                width: 500,
                height: 500,
                child: CarouselSlider(
                  items: [
                    SizedBox(
                      width: 500,
                      height: 500,
                      child: SfCircularChart(
                        backgroundColor: widget.color,
                        legend: const Legend(
                          isVisible: true,
                          // Show the legend
                          position: LegendPosition.bottom,
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
                                builder: (data, point, series, pointIndex,
                                    seriesIndex) {
                                  if (_selectedOption == "totalprice") {
                                    return Text(
                                        FormatRupiah.convertToIdr(
                                                point.y!.toInt(), 0)
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white));
                                  } else if (_selectedOption == "persen") {
                                    return Text(
                                        '${point.y!.toStringAsFixed(2)} %',
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
                              dataSource: _circularDataProduct,
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
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white));
                                    } else if (_selectedOption == "persen") {
                                      return Text(
                                          '${point.y!.toStringAsFixed(2)} %',
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white));
                                    } else {
                                      return Text(point.y!.toInt().toString(),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white));
                                    }
                                  }),
                            ),
                          ],
                        )),
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
                            dataSource: _circularDataService,
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
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white));
                                  } else if (_selectedOption == "persen") {
                                    return Text(
                                        '${point.y!.toStringAsFixed(2)} %',
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
                      widget.dataCircular!.forEach((action) {
                        totalQty = totalQty + action.value;
                      });

                      widget.dataCircular!.forEach((action) {
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
                      _circularData = widget.dataCircular!.toList();
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
                      _circularData = widget.dataCircular!.toList();
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 500,
          height: 500,
          child: CarouselSlider(
            items: [
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
                        text: "Most Selling product".toUpperCase(),
                        textStyle: const TextStyle(color: Colors.white)),
                    series: <CircularSeries<CircularData, String>>[
                      PieSeries<CircularData, String>(
                        dataSource: _circularDataProduct,
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
                                    FormatRupiah.convertToIdr(
                                            point.y!.toInt(), 0)
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
                  )),
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
                      text: "Most Selling service".toUpperCase(),
                      textStyle: const TextStyle(color: Colors.white)),
                  series: <CircularSeries<CircularData, String>>[
                    PieSeries<CircularData, String>(
                      dataSource: _circularDataService,
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
              )
            ],
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              scrollPhysics: ScrollPhysics(),
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 1,
              aspectRatio: 0.5,
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => buttonCarouselController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear),
                child: SizedBox(
                  width: 50,
                  child: const Icon(Icons.chevron_left, color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () => buttonCarouselController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear),
                child: SizedBox(
                  width: 50,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      double totalQtyService = 0;
                      double totalQtyProduct = 0;

                      _circularData.clear();
                      _circularDataService.clear();
                      _circularDataProduct.clear();

                      _selectedOption = value!;
                      widget.dataCircular!.forEach((action) {
                        totalQty = totalQty + action.value;
                      });
                      widget.dataCircularProduct!.forEach((action) {
                        totalQtyProduct = totalQtyProduct + action.value;
                      });
                      widget.dataCircularService!.forEach((action) {
                        totalQtyService = totalQtyService + action.value;
                      });

                      widget.dataCircular!.forEach((action) {
                        double persenValue = (action.value / totalQty) * 100;
                        _circularData.add(CircularData(
                          action.label,
                          persenValue,
                          action.valuePrice!,
                        ));
                      });
                      widget.dataCircularService!.forEach((action) {
                        double persenValue =
                            (action.value / totalQtyService) * 100;
                        _circularDataService.add(CircularData(
                            action.label, persenValue, action.valuePrice!));
                      });
                      widget.dataCircularProduct!.forEach((action) {
                        double persenValue =
                            (action.value / totalQtyProduct) * 100;
                        _circularDataProduct.add(CircularData(
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
                      _circularData = widget.dataCircular!.toList();
                      _circularDataService =
                          widget.dataCircularService!.toList();
                      _circularDataProduct =
                          widget.dataCircularProduct!.toList();
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
                      _circularData = widget.dataCircular!.toList();
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
        ),
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
        isInversed: true, // ← urutan label dibalik
        labelRotation: 0,
        labelStyle: TextStyle(color: Colors.white),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(color: Colors.white),
      ),
      series: <BarSeries<SalesDataWeekly, String>>[
        BarSeries(
          dataSource: widget.data,
          xValueMapper: (SalesDataWeekly data, _) => data.day,
          yValueMapper: (SalesDataWeekly data, _) => data.sales,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            // show labels
            labelAlignment: ChartDataLabelAlignment.middle,
            // or: top, middle, bottom
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // BarSeries(
        //   dataSource: widget.data,
        //   xValueMapper: (SalesDataWeekly data, _) => data.day,
        //   yValueMapper: (SalesDataWeekly data, _) => 0,
        // )
      ],
    );
  }
}
