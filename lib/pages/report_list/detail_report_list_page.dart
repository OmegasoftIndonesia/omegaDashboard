import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../models/responses/detail_department_model.dart';
import '../../services/report_list_service.dart';

class DetailReportListPage extends StatefulWidget {
  final String department;

  const DetailReportListPage({super.key, required this.department});

  @override
  State<DetailReportListPage> createState() => _DetailReportListPageState();
}

class _DetailReportListPageState extends State<DetailReportListPage> {
  ReportListService reportListService = ReportListService();
  Future<List<DetailDepartmentModel>>? fDetailDepartmentService;

  @override
  void initState() {
    getDepartement(widget.department);
    super.initState();
  }

  getDepartement(String department) {
    setState(() {
      fDetailDepartmentService =
          reportListService.getDetailDepartement(department);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(Constants.colorBackgroundContainer),
        centerTitle: true,
        title: Text(
          widget.department,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              getDepartement(widget.department);
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          getDepartement(widget.department);
          return Future.value();
        },
        child: FutureBuilder(
          future: fDetailDepartmentService,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var dataDetailDepartement = snapshot.data!;
                if (dataDetailDepartement.isEmpty) {
                  return const Center(
                    child: Text(
                      "No departement available",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else {
                  return ListView.separated(
                    itemCount: dataDetailDepartement.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {},
                        title: Text(dataDetailDepartement[index].title!),
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
