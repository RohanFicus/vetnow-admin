import 'package:flutter/material.dart';
import 'package:vetnow_admin/component/responsive.dart';
import 'package:vetnow_admin/core/app_colors.dart';
import 'package:vetnow_admin/services/api_service.dart';

class ResponsiveDashboard extends StatefulWidget {
  const ResponsiveDashboard({super.key});

  @override
  _ResponsiveDashboardState createState() => _ResponsiveDashboardState();
}

class _ResponsiveDashboardState extends State<ResponsiveDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _api = ApiService();

  @override
  Widget build(BuildContext context) {
    final ApiService _api = ApiService();
    return FutureBuilder(
      future: _api.fetchDashboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildResponsiveGrid(context), // Move your grid logic here
              const SizedBox(height: 25),
              _buildChartsSection(context), // Move your chart logic here
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDesktop) {
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
          const Text(
            "VetNow Dashboard",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

  Widget _buildResponsiveGrid(BuildContext context) {
    // Dynamic Columns: 1 for Mobile, 2 for Tablet, 4 for Desktop
    int crossAxisCount = Responsive.isMobile(context)
        ? 1
        : (Responsive.isTablet(context) ? 2 : 4);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.8,
      children: [
        _colorCard(
          "Total Registrations",
          "1,240",
          Icons.people,
          AppColors.blueGradients,
        ),
        _colorCard(
          "Total Doctors",
          "85",
          Icons.medical_services,
          AppColors.purpleGradients,
        ),
        _colorCard(
          "Pets Registered",
          "950",
          Icons.pets,
          AppColors.greenGradients,
        ),
        _colorCard(
          "Today's Bookings",
          "12",
          Icons.calendar_month,
          AppColors.orangeGradients,
        ),
      ],
    );
  }

  Widget _colorCard(
    String title,
    String value,
    IconData icon,
    List<Color> colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors[1].withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context) {
    // Stack charts vertically on Mobile, side-by-side on Desktop
    bool isWide = !Responsive.isMobile(context);

    return Flex(
      direction: isWide ? Axis.horizontal : Axis.vertical,
      children: [
        Expanded(
          flex: isWide ? 2 : 0,
          child: _whiteContainer(
            "Current Online Doctors",
            300,
            Icons.show_chart,
          ),
        ),
        if (isWide) const SizedBox(width: 20),
        if (!isWide) const SizedBox(height: 20),
        Expanded(
          flex: isWide ? 1 : 0,
          child: _whiteContainer("Cancelled Bookings", 300, Icons.pie_chart),
        ),
      ],
    );
  }

  Widget _whiteContainer(
    String title,
    double height,
    IconData placeholderIcon,
  ) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Center(
              child: Icon(placeholderIcon, size: 80, color: Colors.grey[200]),
            ),
          ),
        ],
      ),
    );
  }
}
