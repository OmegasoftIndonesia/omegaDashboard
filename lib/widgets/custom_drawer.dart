import 'package:flutter/material.dart';
import '../pages/report_list/report_list_page.dart';
import '../pages/tracking_history_page.dart';
import '../pages/tracking_live_view_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/login_page.dart';
import '../utils/shared_prefs.dart';
import '../constants/constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    PreferencesUtil util = PreferencesUtil();

    return Drawer(
      backgroundColor: const Color(Constants.colorBackgroundApp),
      surfaceTintColor: const Color(Constants.colorBackgroundApp),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " Dashboard",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportListPage(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " Report List",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            ExpansionTile(
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: const Text(
                "Tracking",
                style: TextStyle(color: Colors.white),
              ),
              childrenPadding: const EdgeInsets.only(left: 60),
              children: [
                ListTile(
                  title: const Text(
                    "Tracking Live View",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrackingLiveViewPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    "Tracking History",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrackingHistoryPage(),
                      ),
                    );
                  },
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () async {
                  logoutConfirmDialog(context, util);
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void logoutConfirmDialog(BuildContext context, PreferencesUtil util) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text("Confirmation"),
          content: const Text("Are you sure want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await util.clearAll().then((clear) {
                  if (clear) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  }
                });
              },
            )
          ],
        );
      },
    );
  }
}
