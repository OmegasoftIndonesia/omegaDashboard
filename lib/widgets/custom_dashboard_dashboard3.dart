import 'package:flutter/material.dart';
import 'package:omega_dashboard/models/SalesDataWeekly.dart';
import 'package:omega_dashboard/services/tracking_service.dart';
import '../utils/shared_prefs.dart';
import 'custom_container.dart';

class CustomContainerDashboard3 extends StatefulWidget {
  final List<Widget>? staffSales;
  final List<Widget>? staffName;
  final String? title;
  final String? cabang;

  const CustomContainerDashboard3(
      {super.key, this.staffName, this.staffSales, this.title, this.cabang});

  @override
  State<CustomContainerDashboard3> createState() =>
      _CustomContainerDashboard3State();
}

class _CustomContainerDashboard3State extends State<CustomContainerDashboard3> {
  final PreferencesUtil util = PreferencesUtil();
  TextEditingController controllerSales = TextEditingController();
  TrackingService service = TrackingService();

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
        child: Column(
          children: [
            Text(
              widget.title!.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.staffName!,
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.staffSales!,
                  ),
                ),
                (widget.title ==
                        'gross sales amount until today vs avg permonth')
                    ? InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext LogoutContext) {
                                return ButtonBarTheme(
                                    data: ButtonBarThemeData(
                                        alignment: MainAxisAlignment.center),
                                    child: AlertDialog(
                                      title: Text(
                                        "Setting Sales Goals",
                                        textAlign: TextAlign.center,
                                      ),
                                      content: TextField(
                                        controller: controllerSales,
                                      ),
                                      actions: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(LogoutContext)
                                                        .pop();
                                                    service
                                                        .updateKategori(
                                                            controllerSales
                                                                .text,
                                                            widget.cabang)
                                                        .then((onValue) {

                                                    });
                                                  },
                                                  child: Text("Ya")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(LogoutContext)
                                                        .pop();
                                                  },
                                                  child: Text("Tidak"))
                                            ])
                                      ],
                                    ));
                              },
                              barrierDismissible: false);
                        },
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ))
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
