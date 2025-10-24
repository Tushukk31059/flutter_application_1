import 'package:flutter/material.dart';
import 'package:flutter_application_1/manage_students.dart';

// Define custom colors based on user request
const Color primaryColor = Color(0xFF282C5C);
const Color secondaryBackgroundColor = Colors.white;
const Color dashboardBackgroundColor = Color(
  0xFFF5F5F5,
); // Clean, light grey (Grey 100)
const Color successColor = Color(0xFF10B981); // Green-600
const Color dangerColor = Color(0xFFEF4444); // Red-500
const Color warningColor = Color(0xFFFF9800); // Orange-500

class OperationsManagerDashboard extends StatelessWidget {
  // Renamed Class
  const OperationsManagerDashboard({super.key});

  // --- Helper: Navigation Drawer ---
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: Text(
              'Operations Navigation', // Updated Title
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: primaryColor),
            title: const Text('Dashboard'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.people, color: Colors.purple),
            title: const Text('Student Management'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageStudentsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payments, color: successColor),
            title: const Text('Fees & Payments'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.book, color: Colors.teal),
            title: const Text('Course & Batch Mgmt'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.analytics, color: warningColor),
            title: const Text('Reports & Analytics'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('Admin Controls'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: dangerColor),
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Operations Manager Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: dangerColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '2', // Ops Alerts count
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- 4. Quick Actions (TOP) ---
            _buildQuickActions(context),

            const SizedBox(height: 24),

            // --- 1. Dashboard Summary – Quick Stats (KPIs) ---
            const Text(
              'Dashboard Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildKPIsGrid(context),

            const SizedBox(height: 24),

            // --- 3. Fees & Payments ---
            _buildFeesAndPayments(),

            const SizedBox(height: 24),

            // --- 4. Course & Progress Management ---
            _buildProgressAndCourseMgmt(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper widget for a single KPI card
  Widget _buildKPICard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    String? subtitle,
    Color? subtitleColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 28, color: iconColor),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: subtitleColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Section 1: KPIs Grid - Made Responsive
  Widget _buildKPIsGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Show 3 columns on medium screens (tablet), 4 on wide (desktop), 2 on mobile
    final crossAxisCount = screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2);
    // Adjust aspect ratio (taller cards on wider screens)
    final aspectRatio = screenWidth > 700 ? 1.0 : 1.4;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      childAspectRatio: aspectRatio,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        _buildKPICard(
          title: 'Total Students',
          value: '3,200',
          icon: Icons.person_pin,
          iconColor: primaryColor,
          subtitle: 'Active & Enrolled',
          subtitleColor: Colors.grey[500],
        ),
        _buildKPICard(
          title: 'Active Courses',
          value: '15',
          icon: Icons.book,
          iconColor: Colors.blue,
          subtitle: 'Q4 Schedule',
          subtitleColor: Colors.blue,
        ),
        _buildKPICard(
          title: 'Fees Collected (M)',
          value: '\$120K',
          icon: Icons.payments,
          iconColor: successColor,
          subtitle: '+10% MoM',
          subtitleColor: successColor,
        ),
        _buildKPICard(
          title: 'Pending Dues',
          value: '\$35,000',
          icon: Icons.money_off,
          iconColor: dangerColor,
          subtitle: 'High Priority',
          subtitleColor: dangerColor,
        ),
        _buildKPICard(
          title: 'Avg. Attendance',
          value: '96.2%',
          icon: Icons.calendar_month,
          iconColor: Colors.teal,
          subtitle: 'This Week',
          subtitleColor: Colors.teal,
        ),
        _buildKPICard(
          title: 'Certificates Issued',
          value: '1,560',
          icon: Icons.workspace_premium,
          iconColor: warningColor,
          subtitle: 'Last Quarter',
          subtitleColor: warningColor,
        ),
      ],
    );
  }

  // Section 3: Fees & Payments
  Widget _buildFeesAndPayments() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fees & Payment Tracking',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildStatusItem('Overdue Accounts:', '35 Students', dangerColor),
            _buildStatusItem(
              'Next Installment Total:',
              '\$45,000',
              Colors.blue,
            ),

            const SizedBox(height: 16),
            const Text(
              'Overdue Reminders (5)',
              style: TextStyle(fontWeight: FontWeight.w500, color: dangerColor),
            ),

            // Overdue List
            _buildDueItem('Student ID 1001', 'Installment #2', dangerColor),
            _buildDueItem('Student ID 1205', 'Final Payment', dangerColor),

            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.alarm, size: 20, color: warningColor),
                label: const Text(
                  'Send Payment Reminders',
                  style: TextStyle(
                    color: warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDueItem(String student, String installment, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            student,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            installment,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Section 4: Course & Progress Management
  Widget _buildProgressAndCourseMgmt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course & Progress Management',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _buildAlertCard(
          title: 'Low Progress Alert',
          message:
              'Batch C101 is 15% behind schedule in Course 3 syllabus completion.',
          color: dangerColor,
          buttonText: 'Notify Instructor',
        ),
        _buildAlertCard(
          title: 'New Feedback Received (7)',
          message:
              'New student feedback items are pending assignment to relevant instructors.',
          color: warningColor,
          buttonText: 'View Feedback Queue',
        ),
        const SizedBox(height: 16),
        _buildBatchSummary(),
      ],
    );
  }

  Widget _buildAlertCard({
    required String title,
    required String message,
    required Color color,
    required String buttonText,
  }) {
    return Card(
      elevation: 2,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(fontSize: 13, color: color.withOpacity(0.8)),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                buttonText,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchSummary() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Batch Status Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildStatusItem(
              'Next Certificate Batch:',
              'Batch B201 (Due 1 week)',
              warningColor,
            ),
            _buildStatusItem(
              'Highest Attendance Batch:',
              'Batch A105',
              successColor,
            ),
            _buildStatusItem(
              'Pending Syllabus Updates:',
              'Course 5 (Needs Review)',
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  // Section: Quick Actions - Made Responsive (TOP)
  Widget _buildQuickActions(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: [
            _buildActionButton(
              context,
              Icons.person_add,
              'Add New Student',
              primaryColor,
              isDesktop,
            ),
            _buildActionButton(
              context,
              Icons.library_add,
              'Add New Course',
              Colors.teal,
              isDesktop,
            ),
            _buildActionButton(
              context,
              Icons.attach_money,
              'Record Payment',
              successColor,
              isDesktop,
            ),
            _buildActionButton(
              context,
              Icons.workspace_premium,
              'Gen. Certificates',
              warningColor,
              isDesktop,
            ),
            _buildActionButton(
              context,
              Icons.people_alt,
              'View Student List',
              Colors.blue,
              isDesktop,
            ),
          ],
        ),
      ],
    );
  }

  // Helper widget for action buttons - Made Responsive
  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    bool isDesktop,
  ) {
    // Determine button width based on screen size
    final double buttonWidth = isDesktop
        ? (MediaQuery.of(context).size.width *
              0.9 /
              5) // Allows for up to 5 buttons in a row on desktop
        : 160.0; // Fixed width for mobile

    return SizedBox(
      width: buttonWidth.clamp(140.0, 300.0), // Ensure min/max sensible size
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
