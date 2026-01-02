import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vetnow_admin/component/responsive.dart';
import 'package:vetnow_admin/entities/doctor.dart';

class PetsManagementScreen extends StatefulWidget {
  const PetsManagementScreen({super.key});

  @override
  _PetsManagementScreenState createState() => _PetsManagementScreenState();
}

class _PetsManagementScreenState extends State<PetsManagementScreen> {
  // Filter States
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  String _statusFilter = 'All';
  List<Doctor> _doctors = [];
  bool _isLoading = false;
  bool _isFilterVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchDoctors(); // Initial API call
  }

  // API Call Simulation
  Future<void> _fetchDoctors({
    String? name,
    DateTime? date,
    String? status,
  }) async {
    setState(() => _isLoading = true);

    // Replace with your actual API call:
    // var response = await http.get(Uri.parse('api/doctors?name=$name&status=$status...'));
    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    // Mock Data
    _doctors = [
      Doctor(
        id: "1",
        name: "Dr. Sarah Connor",
        specialty: "Surgeon",
        isActive: true,
        joinedDate: DateTime.now(),
        image: "https://i.pravatar.cc/150?u=1",
      ),
      Doctor(
        id: "2",
        name: "Dr. John Doe",
        specialty: "Veterinarian",
        isActive: false,
        joinedDate: DateTime.now(),
        image: "https://i.pravatar.cc/150?u=2",
      ),
      Doctor(
        id: "3",
        name: "Dr. Mike Ross",
        specialty: "Neurologist",
        isActive: true,
        joinedDate: DateTime.now(),
        image: "https://i.pravatar.cc/150?u=3",
      ),
    ];

    setState(() => _isLoading = false);
  }

  void _resetFilters() {
    _nameController.clear();
    setState(() {
      _selectedDate = null;
      _statusFilter = 'All';
    });
    _fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: () => {
                setState(() => _isFilterVisible = !_isFilterVisible),
              },
              backgroundColor: Colors.indigo,
              icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
              label: const Text(
                "Filters",
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
      body: Column(
        children: [
          if (!isMobile || _isFilterVisible) _buildFilterBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildDoctorGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    bool isMobile = Responsive.isMobile(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // Add a slight grey background on mobile to differentiate from the list
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Wrap(
        spacing: 20, // Horizontal space between items
        runSpacing: 20, // Vertical space when items wrap to next line
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          // 1. Name Filter
          _buildFilterItem(
            label: "Doctor Name",
            width: isMobile ? double.infinity : 250,
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Search by name...",
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // 2. Date Filter
          _buildFilterItem(
            label: "Joined Date",
            width: isMobile ? double.infinity : 250,
            child: InkWell(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: Container(
                height: 48, // Match TextField height
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedDate == null
                          ? "Select Date"
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Status Filter
          _buildFilterItem(
            label: "Status",
            width: isMobile ? double.infinity : 250,
            child: DropdownButtonFormField<String>(
              value: _statusFilter,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: ['All', 'Active', 'Inactive']
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s, style: const TextStyle(fontSize: 14)),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _statusFilter = val!),
            ),
          ),

          // 4. Buttons (Apply & Reset)
          SizedBox(
            width: isMobile ? double.infinity : 250,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Apply Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _fetchDoctors(
                    name: _nameController.text,
                    date: _selectedDate,
                    status: _statusFilter,
                  ),
                  child: const Text("Apply Filters"),
                ),
                const SizedBox(width: 12),
                // Reset Button
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(100, 58),
                    side: const BorderSide(color: Colors.red),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _resetFilters,
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to keep the code clean
  Widget _buildFilterItem({
    required String label,
    required double width,
    required Widget child,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildDoctorGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // Responsiveness: 1 col for Mobile, 2 for Tablet, 3-4 for Desktop
        crossAxisCount: MediaQuery.of(context).size.width < 800
            ? 1
            : (MediaQuery.of(context).size.width < 1200 ? 2 : 4),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      itemCount: _doctors.length,
      itemBuilder: (context, index) => _DoctorCard(doctor: _doctors[index]),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 40, backgroundImage: NetworkImage(doctor.image)),
          const SizedBox(height: 15),
          Text(
            doctor.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(doctor.specialty, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: doctor.isActive ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              doctor.isActive ? "Active" : "Inactive",
              style: TextStyle(
                color: doctor.isActive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 30),
          Text(
            "Joined: ${DateFormat('MMM yyyy').format(doctor.joinedDate)}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
