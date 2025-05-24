import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:upgrader/upgrader.dart';
import '../models/responses/dashboard_query_response.dart';
import '../utils/format_rupiah.dart';
import '../widgets/custom_container_dashboard.dart';
import '../constants/query_dashboard.dart';
import '../models/responses/query_branch_response.dart';
import '../services/query_service.dart';
import '../utils/shared_prefs.dart';
import '../widgets/custom_button.dart';
import '../constants/constants.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_text_form_field_date.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  PreferencesUtil util = PreferencesUtil();
  QueryService queryService = QueryService();
  bool isGetBranchQuery = false,
      isSubmittedForNetProfit = false,
      isSmallerPhone = false,
      isMiddlePhone = false,
      isTablet = false;

  String? dropdownValueTimeFrame,
      startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  String grossSales = FormatRupiah.convertToIdr(0, 0),
      grossSalesPOS = FormatRupiah.convertToIdr(0, 0),
      grossSalesInvoice = FormatRupiah.convertToIdr(0, 0),
      netSales = FormatRupiah.convertToIdr(0, 0),
      netSalesPOS = FormatRupiah.convertToIdr(0, 0),
      netSalesInvoice = FormatRupiah.convertToIdr(0, 0),
      grandTotalSales = FormatRupiah.convertToIdr(0, 0),
      grandTotalSalesPOS = FormatRupiah.convertToIdr(0, 0),
      grandTotalSalesInvoice = FormatRupiah.convertToIdr(0, 0),
      retur = FormatRupiah.convertToIdr(0, 0),
      grandTotalSalesMinusRetur = FormatRupiah.convertToIdr(0, 0),
      numberOfTransaction = "0",
      numberOfTransactionPOS = "0",
      numberOfTransactionInvoice = "0",
      avgSalesPerTransaction = FormatRupiah.convertToIdr(0, 0),
      avgSalesPerTransactionPOS = FormatRupiah.convertToIdr(0, 0),
      avgSalesPerTransactionInvoice = FormatRupiah.convertToIdr(0, 0),
      netProfit = FormatRupiah.convertToIdr(0, 0);
  QueryBranchResponse? dropdownValueBranch;
  List<QueryBranchResponse> itemBranches = [];
  Future<List<QueryBranchResponse>>? fGetBranch;
  var itemsTimeFrames = [
    'Today',
    'Yesterday',
    'This Week',
    'Last Week',
    'This Month',
    'Last Month',
    'This Year',
    'Last Year',
    'Custom'
  ];
  late TabController tabController;

  @override
  void initState() {
    fGetBranch = queryService.getBranch(
      QueryDashboard.getBranchesQuery(util.getString(PreferencesUtil.email)!),
    );

    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void getDashboardQuery() async {
    if (dropdownValueBranch == null && dropdownValueTimeFrame == null) {
      EasyLoading.showError("Please select a branch & time frame.");
      return;
    }
    if (dropdownValueBranch == null) {
      EasyLoading.showError("Please select a branch.");
      return;
    }
    if (dropdownValueTimeFrame == null) {
      EasyLoading.showError("Please select a time frame");
      return;
    }

    EasyLoading.show(
        status: 'loading...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black);
    await queryService
        .getDashboardQuery(QueryDashboard.dashBoardQuery(
            dropdownValueBranch!.cabang!.substring(0, 5),
            dropdownValueBranch!.cabang!,
            dropdownValueTimeFrame,
            startDate!,
            endDate!))
        .then((response) {
      EasyLoading.dismiss();
      if (response.isNotEmpty) {
        setState(() {
          grossSales = FormatRupiah.convertToIdr(response[0].nilai1, 0);
          netSales = FormatRupiah.convertToIdr(response[0].netsales, 0);
          grandTotalSales =
              FormatRupiah.convertToIdr(response[0].grandtotalsales, 0);
          retur = FormatRupiah.convertToIdr(response[0].returSales, 0);
          grandTotalSalesMinusRetur = FormatRupiah.convertToIdr(
              response[0].grandTotalSalesMinusReturSales, 0);
          numberOfTransaction = response[0].nilai2.toString();
          avgSalesPerTransaction =
              FormatRupiah.convertToIdr(response[0].nilai3, 0);

          if (dropdownValueTimeFrame == 'This Month' ||
              dropdownValueTimeFrame == 'Last Month') {
            DashboardQueryResponse q020 =
                response.where((element) => element.kode == "Q020").single;
            netProfit = FormatRupiah.convertToIdr(q020.nilai1, 0);
            isSubmittedForNetProfit = true;
          } else {
            isSubmittedForNetProfit = false;
          }

          DashboardQueryResponse q016 =
              response.where((element) => element.kode == "Q016").single;
          DashboardQueryResponse q017 =
              response.where((element) => element.kode == "Q017").single;

          avgSalesPerTransactionPOS =
              FormatRupiah.convertToIdr(q017.nilai3 ?? 0, 0);
          avgSalesPerTransactionInvoice =
              FormatRupiah.convertToIdr(q016.nilai3 ?? 0, 0);

          grandTotalSalesPOS =
              FormatRupiah.convertToIdr(q017.grandtotalsales ?? 0, 0);
          grandTotalSalesInvoice =
              FormatRupiah.convertToIdr(q016.grandtotalsales ?? 0, 0);

          numberOfTransactionPOS = q017.nilai2.toString();
          numberOfTransactionInvoice = q016.nilai2.toString();

          grossSalesPOS = FormatRupiah.convertToIdr(q017.nilai1, 0);
          grossSalesInvoice = FormatRupiah.convertToIdr(q016.nilai1, 0);

          netSalesPOS = FormatRupiah.convertToIdr(q017.netsales, 0);
          netSalesInvoice = FormatRupiah.convertToIdr(q016.netsales, 0);
        });
      } else {
        EasyLoading.showError("No data found.",
            maskType: EasyLoadingMaskType.black);
      }
    }).catchError((Object e) async {
      EasyLoading.dismiss();

      EasyLoading.showError(
          "Something went wrong when getting data, try again later.",
          maskType: EasyLoadingMaskType.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQueryData.fromView(View.of(context));
    if (data.size.shortestSide < 380) {
      isSmallerPhone = true;
      isTablet = false;
      isMiddlePhone = false;
    } else if (data.size.shortestSide > 380 && data.size.shortestSide < 425) {
      isSmallerPhone = false;
      isTablet = false;
      isMiddlePhone = true;
    } else if (data.size.shortestSide > 425 && data.size.shortestSide < 550) {
      isTablet = false;
      isSmallerPhone = false;
      isMiddlePhone = false;
    } else {
      isSmallerPhone = false;
      isTablet = true;
      isMiddlePhone = false;
    }

    return UpgradeAlert(
      canDismissDialog: true,
      dialogStyle: Platform.isAndroid
          ? UpgradeDialogStyle.material
          : UpgradeDialogStyle.cupertino,
      upgrader: Upgrader(
        minAppVersion: '1.0.3',
        messages: UpgraderMessages(code: 'id'),
      ),
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(Constants.colorBackgroundContainer),
          centerTitle: true,
          title: const Text(
            "Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  dropdownValueBranch = null;
                  dropdownValueTimeFrame = null;
                  fGetBranch = queryService.getBranch(
                    QueryDashboard.getBranchesQuery(
                        util.getString(PreferencesUtil.email)!),
                  );
                });
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: Container(
          color: const Color(Constants.colorBackgroundApp),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: fGetBranch,
                builder: (context,
                    AsyncSnapshot<List<QueryBranchResponse>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var dataBranch = snapshot.data;
                      itemBranches = dataBranch!;
                      if (dataBranch.isEmpty) {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: Text(
                              "Your branch is empty, check your Omega Account Data",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomContainer(
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  padding: const EdgeInsets.all(15),
                                  child: const Text(
                                    "Branch",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: DropdownButton<QueryBranchResponse>(
                                    hint: const Text(
                                      "Choose a branch",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    underline: Container(),
                                    isExpanded: true,
                                    iconEnabledColor: Colors.white,
                                    dropdownColor: const Color(
                                        Constants.colorBackgroundApp),
                                    value: dropdownValueBranch,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: itemBranches.map((items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items.namaCabang!),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        dropdownValueBranch = newValue!;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomContainer(
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  padding: const EdgeInsets.all(15),
                                  child: const Text(
                                    "Time Frame",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: DropdownButton(
                                    hint: const Text(
                                      "Choose a time frame",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    underline: Container(),
                                    isExpanded: true,
                                    iconEnabledColor: Colors.white,
                                    dropdownColor: const Color(
                                        Constants.colorBackgroundApp),
                                    value: dropdownValueTimeFrame,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: itemsTimeFrames.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValueTimeFrame = newValue!;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            if (dropdownValueTimeFrame == 'Custom')
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.10,
                                      height: isSmallerPhone ? 75 : 50,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "From",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Expanded(
                                            child: CustomTextFormFieldDate(
                                              isSmallerPhone: isSmallerPhone,
                                              ctrl: startDateController,
                                              readOnly: true,
                                              onTap: () {
                                                displayDatePicker(
                                                    context, false);
                                              },
                                              padding: const EdgeInsets.only(
                                                left: 22,
                                                right: 22,
                                                top: 20,
                                              ),
                                              obscureText: false,
                                              hintText: "Start Date",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.25,
                                      height: isSmallerPhone ? 75 : 50,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "To",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Expanded(
                                            child: CustomTextFormFieldDate(
                                              isSmallerPhone: isSmallerPhone,
                                              ctrl: endDateController,
                                              readOnly: true,
                                              onTap: () {
                                                displayDatePicker(
                                                    context, true);
                                              },
                                              padding: const EdgeInsets.only(
                                                left: 22,
                                                right: 22,
                                                top: 20,
                                              ),
                                              obscureText: false,
                                              hintText: "End Date",
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            CustomButton(
                              foregroundColor: Colors.blue,
                              backgroundColor: Colors.blue,
                              textButton: "Submit",
                              onPressed: () => getDashboardQuery(),
                            )
                          ],
                        );
                      }
                    } else {
                      return const SizedBox(
                        height: 150,
                        child: Center(
                          child: Text(
                            "Something went wrong, try again later",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  } else {
                    return const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text(
                          "Something went wrong, try again later",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
              ),
              TabBar(
                indicatorColor: const Color(Constants.colorSecondaryApp),
                labelStyle: const TextStyle(color: Colors.white),
                controller: tabController,
                tabs: const [
                  Tab(
                    text: "SALES SUMMARY",
                    icon: Icon(
                      Icons.text_snippet,
                    ),
                  ),
                  Tab(
                    text: "POS",
                    icon: Icon(
                      Icons.phonelink_sharp,
                    ),
                  ),
                  Tab(
                    text: "INVOICE",
                    icon: Icon(
                      Icons.list_alt,
                    ),
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomContainerDashboard(
                            nominal: grossSales,
                            title: "GROSS SALES",
                            subtitle: "(before disc, tax, and service)",
                          ),
                          CustomContainerDashboard(
                            nominal: netSales,
                            title: "NET SALES",
                            subtitle: "(after disc before tax and service)",
                          ),
                          CustomContainerDashboard(
                            nominal: grandTotalSales,
                            title: "GRAND TOTAL SALES",
                            subtitle: "(after disc, tax, and service)",
                          ),
                          CustomContainerDashboard(
                            nominal: retur,
                            title: "RETUR",
                          ),
                          CustomContainerDashboard(
                            nominal: grandTotalSalesMinusRetur,
                            title: "GRAND TOTAL SALES MINUS RETUR",
                            subtitle: "(after disc, tax, and service)",
                          ),
                          CustomContainerDashboard(
                            nominal: numberOfTransaction,
                            title: "NUMBER OF TRANSACTION",
                          ),
                          CustomContainerDashboard(
                            nominal: avgSalesPerTransaction,
                            title: "AVG SALES PER TRANSACTION",
                          ),
                          if (isSubmittedForNetProfit)
                            CustomContainerDashboard(
                              nominal: netProfit,
                              title: "NET PROFIT",
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        CustomContainerDashboard(
                          nominal: grossSalesPOS,
                          title: "GROSS SALES POS",
                        ),
                        CustomContainerDashboard(
                          nominal: netSalesPOS,
                          title: "NET SALES POS",
                        ),
                        CustomContainerDashboard(
                          nominal: grandTotalSalesPOS,
                          title: "GRAND TOTAL SALES POS",
                        ),
                        CustomContainerDashboard(
                          nominal: numberOfTransactionPOS,
                          title: "NUMBER OF TRANSACTION POS",
                        ),
                        CustomContainerDashboard(
                          nominal: avgSalesPerTransactionPOS,
                          title: "AVG SALES PER TRANSACTION POS",
                        )
                      ],
                    ),
                    Column(
                      children: [
                        CustomContainerDashboard(
                          nominal: grossSalesInvoice,
                          title: "GROSS SALES INVOICE",
                        ),
                        CustomContainerDashboard(
                          nominal: netSalesInvoice,
                          title: "NET SALES INVOICE",
                        ),
                        CustomContainerDashboard(
                          nominal: grandTotalSalesInvoice,
                          title: "GRAND TOTAL SALES INVOICE",
                        ),
                        CustomContainerDashboard(
                          nominal: numberOfTransactionInvoice,
                          title: "NUMBER OF TRANSACTION INVOICE",
                        ),
                        CustomContainerDashboard(
                          nominal: avgSalesPerTransactionInvoice,
                          title: "AVG SALES PER TRANSACTION INVOICE",
                        )
                      ],
                    )
                  ],
                ),
              ),
              // CustomContainerDashboard(
              //   nominal: grossSales,
              //   title: "GROSS SALES",
              //   subtitle: "(before disc, tax, and service)",
              // ),
              // CustomContainerDashboard(
              //   nominal: netSales,
              //   title: "NET SALES",
              //   subtitle: "(after disc before tax and service)",
              // ),
              // CustomContainerDashboard(
              //   nominal: grandTotalSales,
              //   title: "GRAND TOTAL SALES",
              //   subtitle: "(after disc, tax, and service)",
              // ),
              // CustomContainerDashboard(
              //   nominal: grandTotalSalesPOS,
              //   title: "GRAND TOTAL SALES POS",
              // ),
              // CustomContainerDashboard(
              //   nominal: retur,
              //   title: "RETUR",
              // ),
              // CustomContainerDashboard(
              //   nominal: grandTotalSalesMinusRetur,
              //   title: "GRAND TOTAL SALES MINUS RETUR",
              //   subtitle: "(after disc, tax, and service)",
              // ),
              // CustomContainerDashboard(
              //   nominal: numberOfTransaction,
              //   title: "NUMBER OF TRANSACTION",
              // ),
              // CustomContainerDashboard(
              //   nominal: numberOfTransactionPOS,
              //   title: "NUMBER OF TRANSACTION POS",
              // ),
              // CustomContainerDashboard(
              //   nominal: avgSalesPerTransaction,
              //   title: "AVG SALES PER TRANSACTION",
              // ),
              // CustomContainerDashboard(
              //   nominal: avgSalesPerTransactionPOS,
              //   title: "AVG SALES PER TRANSACTION POS",
              // ),
              // if (isSubmittedForNetProfit)
              //   CustomContainerDashboard(
              //     nominal: netProfit,
              //     title: "NET PROFIT",
              //   ),
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: EdgeInsets.only(left: 22, top: 20),
              //     child: Text(
              //       "SALES SUMMARY (INVOICE)",
              //       style: TextStyle(color: Colors.grey),
              //     ),
              //   ),
              // ),
              // CustomContainerDashboard(
              //   nominal: grandTotalSalesInvoice,
              //   title: "GRAND TOTAL SALES INVOICE",
              // ),
              // CustomContainerDashboard(
              //   nominal: numberOfTransactionInvoice,
              //   title: "NUMBER OF TRANSACTION INVOICE",
              // ),
              // CustomContainerDashboard(
              //   nominal: avgSalesPerTransactionInvoice,
              //   title: "AVG SALES PER TRANSACTION INVOICE",
              // )
            ],
          ),
        ),
      ),
    );
  }

  displayDatePicker(BuildContext context, bool isEndDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1800),
      lastDate: DateTime(2025),
      helpText: isEndDate ? "Select End Date" : "Select Start Date",
      confirmText: "OK",
      cancelText: "Cancel",
      fieldLabelText: isEndDate ? "Select End Date" : "Select Start Date",
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (isEndDate) {
          endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
          endDate = "${endDateController.text} 23:59:59";
        } else {
          startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
          startDate = "${startDateController.text} 00:00:00";
        }
      });
    }
  }
}
