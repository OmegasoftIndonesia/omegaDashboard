import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import '../models/responses/get_staff_position_response.dart';
import '../models/responses/get_branch_kc_response.dart'
    as g_branch_kc_response;
import '../services/tracking_service.dart';
import '../constants/constants.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_drawer.dart';

class TrackingLiveViewPage extends StatefulWidget {
  const TrackingLiveViewPage({super.key});

  @override
  State<TrackingLiveViewPage> createState() => _TrackingLiveViewPageState();
}

class _TrackingLiveViewPageState extends State<TrackingLiveViewPage> {
  LatLng initialLocation = const LatLng(5.00, 120.00);
  Set<Marker> markers = {};
  GoogleMapController? gMapsController;
  TrackingService trackingService = TrackingService();
  Future<g_branch_kc_response.GetBranchKCResponse>? fGetBranchKC;
  Future<GetStaffPositionResponse>? fGetStaffPosition;
  g_branch_kc_response.Data? dropdownValueBranchKC;
  List<g_branch_kc_response.Data> kcBranchItems = [];
  List<Data> staffPositionItems = [];

  @override
  void initState() {
    fGetBranchKC = trackingService.getBranch();
    super.initState();
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
          "Tracking Live View",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                dropdownValueBranchKC = null;
                fGetBranchKC = trackingService.getBranch();
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
                            onChanged: (newValue) {
                              setState(() {
                                dropdownValueBranchKC = newValue!;
                                fGetStaffPosition =
                                    trackingService.getStaffPosition(
                                        dropdownValueBranchKC!.branch!);
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
            const SizedBox(height: 10),
            dropdownValueBranchKC == null
                ? const Expanded(
                    child: Center(
                      child: Text(
                        "Please choose an area",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : FutureBuilder(
                    future: fGetStaffPosition,
                    builder: (context,
                        AsyncSnapshot<GetStaffPositionResponse> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        var dataBranch = snapshot.data!.data;
                        staffPositionItems = dataBranch!;
                        if (dataBranch.isEmpty) {
                          return const Expanded(
                            child: Center(
                              child: Text(
                                "Staff position not found in the selected area",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else {
                          for (Data dataStaffPosition in staffPositionItems) {
                            markers.addLabelMarker(
                              LabelMarker(
                                label: dataStaffPosition.namaAlias!,
                                markerId:
                                    MarkerId(dataStaffPosition.namaAlias!),
                                position: LatLng(
                                    double.parse(dataStaffPosition.latitude!),
                                    double.parse(dataStaffPosition.longitude!)),
                                backgroundColor:
                                    const Color(Constants.colorMainApp),
                              ),
                            );
                          }

                          initialLocation = LatLng(
                              double.parse(staffPositionItems[
                                      (staffPositionItems.length / 2).round()]
                                  .latitude!),
                              double.parse(staffPositionItems[
                                      (staffPositionItems.length / 2).round()]
                                  .longitude!));

                          return Expanded(
                            child: GoogleMap(
                              myLocationButtonEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: initialLocation,
                                zoom: 10,
                              ),
                              onMapCreated: (controller) {
                                setState(() {
                                  gMapsController = controller;
                                });
                              },
                              markers: markers,
                            ),
                          );
                        }
                      } else {
                        return const Expanded(
                          child: Center(
                            child: Text(
                              "Something went wrong, try again later",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }
}
