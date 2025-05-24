import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/responses/department_model.dart';
import '../../services/report_list_service.dart';
import '../../widgets/custom_drawer.dart';
import 'detail_report_list_page.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  ReportListService reportListService = ReportListService();
  Future<List<DepartmentModel>>? fDepartmentService;

  @override
  void initState() {
    getDepartement();
    super.initState();
  }

  getDepartement() {
    setState(() {
      fDepartmentService = reportListService.getDepartement();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(Constants.colorBackgroundContainer),
        centerTitle: true,
        title: const Text(
          "Report List",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              getDepartement();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          getDepartement();
          return Future.value();
        },
        child: FutureBuilder(
          future: fDepartmentService,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var dataDepartement = snapshot.data!;
                if (dataDepartement.isEmpty) {
                  return const Center(
                    child: Text(
                      "No departement available",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else {
                  return ListView.separated(
                    itemCount: dataDepartement.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailReportListPage(
                                department: dataDepartement[index].dept!,
                              ),
                            ),
                          );
                        },
                        title: Text(dataDepartement[index].dept!),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  );
                }
              } else {
                return const Center(
                  child: Text(
                    "Something went wrong, try again later",
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
            } else {
              return const Center(
                child: Text(
                  "Something went wrong, try again later",
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
