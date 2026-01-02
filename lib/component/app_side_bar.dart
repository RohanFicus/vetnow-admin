import 'package:flutter/material.dart';
import 'package:vetnow_admin/screens/login_screen.dart';

import '../core/app_colors.dart';

class AppSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sidebarBg,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                "VETNOW",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          _menuTile(0, Icons.dashboard_rounded, "Dashboard"),
          _menuTile(
            1,
            Icons.medical_information,
            "Doctors",
          ), // Index 1 for Doctors
          _menuTile(2, Icons.people_alt, "User Management"),
          _menuTile(3, Icons.pets, "Pet Management"),
          _menuTile(4, Icons.calendar_today, "Bookings"),
          const Spacer(),
          _menuTile(5, Icons.logout, "Logout", color: Colors.redAccent),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menuTile(
    int index,
    IconData icon,
    String title, {
    Color color = Colors.white70,
  }) {
    bool active = widget.selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: active ? Colors.white : color),
      title: Text(
        title,
        style: TextStyle(color: active ? Colors.white : color),
      ),
      selected: active,
      selectedTileColor: AppColors.primary.withOpacity(0.2),
      onTap: () {
        if (title == "Logout") {
          // Show the dialog instead of switching pages
          showLogoutDialog(context);
        } else {
          widget.onItemSelected(index);
        }
      },
    );
  }
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 10),
            Text("Logout Confirmation"),
          ],
        ),
        content: const Text(
          "Are you sure you want to log out from the VetNow Admin Panel?",
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          // Confirm Logout Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // 1. Clear any local storage/session here (e.g., SharedPreferences)
              // 2. Navigate to Login and remove all previous routes
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );
}
