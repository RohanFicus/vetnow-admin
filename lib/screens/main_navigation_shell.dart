import 'package:flutter/material.dart';
import 'package:vetnow_admin/component/app_side_bar.dart';
import 'package:vetnow_admin/component/responsive.dart';
import 'package:vetnow_admin/core/app_colors.dart';
import 'package:vetnow_admin/screens/booking_management_screen.dart';
import 'package:vetnow_admin/screens/dashboard_layout.dart';
import 'package:vetnow_admin/screens/doctor_management_screen.dart';
import 'package:vetnow_admin/screens/pets_management_screen.dart';
import 'package:vetnow_admin/screens/user_management_screen.dart';
// Import your new doctors screen here
// import 'package:vetnow_admin/screens/doctor_management_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  _MainNavigationShellState createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0; // 0 = Dashboard, 1 = Doctors

  // List of screens to switch between
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ResponsiveDashboard(), // We move your dashboard logic here
      const DoctorManagementScreen(), // The screen we created in the previous step
      const UserManagementScreen(), // Placeholder
      const PetsManagementScreen(), // Placeholder
      const BookingManagementScreen(), // Placeholder
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      // Pass the index and callback to sidebar
      drawer: !isDesktop
          ? AppSidebar(
              selectedIndex: _currentIndex,
              onItemSelected: (index) {
                setState(() => _currentIndex = index);
                Navigator.pop(context); // Close drawer on mobile
              },
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            Expanded(
              flex: 1,
              child: AppSidebar(
                selectedIndex: _currentIndex,
                onItemSelected: (index) {
                  if (index == 5) {
                    // Assuming 5 is the Logout index
                    showLogoutDialog(context);
                  } else {
                    setState(() => _currentIndex = index);
                    if (!isDesktop) {
                      Navigator.pop(context); // Close drawer on mobile
                    }
                  }
                },
              ),
            ),

          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildTopBar(context, isDesktop),
                // This is where the magic happens: it displays the selected page
                Expanded(child: _pages[_currentIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDesktop) {
    // Determine title based on index
    String title = "VetNow Dashboard";
    if (_currentIndex == 1) title = "Doctor Management";
    if (_currentIndex == 2) title = "User Management";
    if (_currentIndex == 3) title = "Pets Management";
    if (_currentIndex == 4) title = "Bookings";

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            ),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.notifications_none_rounded),
          const SizedBox(width: 20),
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
