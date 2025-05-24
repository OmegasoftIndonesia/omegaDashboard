import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:label_marker/label_marker.dart';
import '../models/responses/get_staff_position_history_response.dart';
import '../constants/constants.dart';
import '../models/responses/get_branch_kc_response.dart'
    as g_branch_kc_response;
import '../models/responses/get_staff_response.dart' as g_staff_response;
import '../services/tracking_service.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_drawer.dart';

class TrackingHistoryPage extends StatefulWidget {
  const TrackingHistoryPage({super.key});

  @override
  State<TrackingHistoryPage> createState() => _TrackingHistoryPageState();
}

class _TrackingHistoryPageState extends State<TrackingHistoryPage> {
  LatLng initialLocation = const LatLng(5.00, 120.00);
  Set<Marker> markers = {};
  GoogleMapController? gMapsController;
  TrackingService trackingService = TrackingService();
  Future<g_branch_kc_response.GetBranchKCResponse>? fGetBranchKC;
  List<g_branch_kc_response.Data> kcBranchItems = [];
  List<g_staff_response.Data> staffItems = [];
  g_branch_kc_response.Data? dropdownValueBranchKC;
  g_staff_response.Data? dropdownValueStaff;
  TextEditingController selectedDateController = TextEditingController();
  TextEditingController selectedTimeController = TextEditingController();
  String googleAPiKey = Constants.mapsAPI, selectedDateString = "Select date";
  DateTime selectedDate = DateTime.now();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  bool isRefresh = false, isHasData = false;

  @override
  void initState() {
    fGetBranchKC = trackingService.getBranch();
    super.initState();
  }

  getDirections(LatLng startLocation, LatLng endLocation) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      if (kDebugMode) {
        print(result.errorMessage);
      }
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: const Color(Constants.colorMainApp),
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void doDrawPolylines(List<Data> staffPositionHistories) {
    for (int i = 0; i < staffPositionHistories.length; i++) {
      if (i == 0) {
        LatLng location = LatLng(
            double.parse(staffPositionHistories[i].latitude!),
            double.parse(staffPositionHistories[i].longitude!));

        LatLng nextLocation = LatLng(
            double.parse(staffPositionHistories[i + 1].latitude!),
            double.parse(staffPositionHistories[i + 1].longitude!));

        markers.addLabelMarker(
          LabelMarker(
            label: staffPositionHistories[i].namaAlias!,
            markerId: MarkerId(staffPositionHistories[i].namaAlias!),
            position: location,
            backgroundColor: const Color(Constants.colorMainApp),
          ),
        );

        markers.addLabelMarker(
          LabelMarker(
            label: staffPositionHistories[i + 1].namaAlias!,
            markerId: MarkerId(staffPositionHistories[i + 1].namaAlias!),
            position: nextLocation,
            backgroundColor: const Color(Constants.colorMainApp),
          ),
        );

        getDirections(location, nextLocation);

        initialLocation = location;

        if (!isRefresh) {
          gMapsController?.animateCamera(
            CameraUpdate.newLatLngZoom(location, 15),
          );
        }
      } else {
        LatLng location = LatLng(
            double.parse(staffPositionHistories[0].latitude!),
            double.parse(staffPositionHistories[0].longitude!));

        LatLng nextLocation = LatLng(
            double.parse(staffPositionHistories[i].latitude!),
            double.parse(staffPositionHistories[i].longitude!));

        markers.addLabelMarker(
          LabelMarker(
            label: staffPositionHistories[i].namaAlias!,
            markerId: MarkerId(staffPositionHistories[i].namaAlias!),
            position: nextLocation,
            backgroundColor: const Color(Constants.colorMainApp),
          ),
        );

        getDirections(location, nextLocation);
        isRefresh = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(Constants.colorBackgroundContainer),
        centerTitle: true,
        title: const Text(
          "Tracking History",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                dropdownValueBranchKC = null;
                dropdownValueStaff = null;
                selectedDateController.text = "";
                markers = {};
                polylinePoints = PolylinePoints();
                polylines = {};
                fGetBranchKC = trackingService.getBranch();
                kcBranchItems = [];
                isRefresh = true;
                isHasData = false;
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(Constants.colorBackgroundApp),
        child: Column(
          children: [
            const SizedBox(height: 10),
            FutureBuilder(
              future: fGetBranchKC,
              builder: (context,
                  AsyncSnapshot<g_branch_kc_response.GetBranchKCResponse>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  var dataBranch = snapshot.data!.data;
                  kcBranchItems = dataBranch!;
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
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomContainer(
                          width: MediaQuery.of(context).size.width * 0.33,
                          padding: const EdgeInsets.all(15),
                          child: const Text(
                            "Select Area",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: DropdownButton<g_branch_kc_response.Data>(
                            hint: const Text(
                              "Choose an area",
                              style: TextStyle(color: Colors.black),
                            ),
                            underline: Container(),
                            isExpanded: true,
                            iconEnabledColor: Colors.white,
                            dropdownColor: Colors.white,
                            value: dropdownValueBranchKC,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: kcBranchItems.map((items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items.namaCabang!,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) async {
                              setState(() {
                                dropdownValueBranchKC = newValue!;
                                dropdownValueStaff = null;
                                isRefresh = true;
                                isHasData = false;
                              });

                              EasyLoading.show(
                                  status: 'loading...',
                                  dismissOnTap: false,
                                  maskType: EasyLoadingMaskType.black);
                              await trackingService
                                  .getStaff(dropdownValueBranchKC!.branch!)
                                  .then((response) {
                                EasyLoading.dismiss();
                                if (response.data!.isEmpty) {
                                  EasyLoading.showToast(
                                      "Staff from the selected area not found");
                                } else {
                                  setState(() {
                                    staffItems = response.data!;
                                  });
                                }
                              });
                            },
                          ),
                        )
                      ],
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 100,
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
            if (kcBranchItems.isNotEmpty) const SizedBox(height: 10),
            if (kcBranchItems.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomContainer(
                    width: MediaQuery.of(context).size.width * 0.33,
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      "Select Staff",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DropdownButton<g_staff_response.Data>(
                      hint: const Text(
                        "Choose a staff",
                        style: TextStyle(color: Colors.black),
                      ),
                      underline: Container(),
                      isExpanded: true,
                      iconEnabledColor: Colors.white,
                      dropdownColor: Colors.white,
                      value: dropdownValueStaff,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: staffItems.map((items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items.email!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        setState(() {
                          dropdownValueStaff = newValue!;
                        });

                        if (selectedDateController.text != "") {
                          EasyLoading.show(
                              status: 'loading...',
                              dismissOnTap: false,
                              maskType: EasyLoadingMaskType.black);
                          await trackingService
                              .getStaffPositionHistory(
                                  dropdownValueBranchKC!.branch!,
                                  dropdownValueStaff!.kode!,
                                  selectedDateString)
                              .then((response) {
                            EasyLoading.dismiss();
                            var staffPositionHistories = response.data;

                            if (response.data!.isEmpty) {
                              setState(() {
                                isHasData = false;
                                isRefresh = true;
                              });
                              EasyLoading.showToast(
                                  "Staff position from the selected area & date not found");
                              return;
                            }

                            setState(() {
                              isHasData = true;
                              markers = {};
                              polylinePoints = PolylinePoints();
                              polylines = {};
                            });
                            doDrawPolylines(staffPositionHistories!);
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            if (kcBranchItems.isNotEmpty) const SizedBox(height: 10),
            if (kcBranchItems.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomContainer(
                    width: MediaQuery.of(context).size.width * 0.33,
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      "Select Date",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      enabled: dropdownValueBranchKC != null &&
                          dropdownValueStaff != null,
                      controller: selectedDateController,
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1900, 01, 01),
                            maxTime: DateTime(DateTime.now().year + 1),
                            onConfirm: (date) async {
                          selectedDate = date;
                          selectedDateString =
                              DateFormat("yyyy-MM-dd").format(selectedDate);
                          selectedDateController.text = selectedDateString;

                          EasyLoading.show(
                              status: 'loading...',
                              dismissOnTap: false,
                              maskType: EasyLoadingMaskType.black);
                          await trackingService
                              .getStaffPositionHistory(
                                  dropdownValueBranchKC!.branch!,
                                  dropdownValueStaff!.kode!,
                                  selectedDateString)
                              .then((response) {
                            EasyLoading.dismiss();
                            var staffPositionHistories = response.data;

                            if (response.data!.isEmpty) {
                              setState(() {
                                isHasData = false;
                                isRefresh = true;
                              });
                              EasyLoading.showToast(
                                  "Staff position from the selected area & date not found");
                              return;
                            }

                            setState(() {
                              isHasData = true;
                              markers = {};
                              polylinePoints = PolylinePoints();
                              polylines = {};
                            });
                            doDrawPolylines(staffPositionHistories!);
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.id);
                      },
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select date",
                      ),
                    ),
                  )
                ],
              ),
            const SizedBox(height: 10),
            !isHasData
                ? const Expanded(
                    child: Center(
                      child: Text(
                        "Please choose an area, staff & date first",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Expanded(
                    child: GoogleMap(
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: initialLocation,
                        zoom: 15,
                      ),
                      onMapCreated: (controller) {
                        setState(() {
                          gMapsController = controller;
                        });
                      },
                      mapType: MapType.normal,
                      polylines: Set<Polyline>.of(polylines.values),
                      markers: markers,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
