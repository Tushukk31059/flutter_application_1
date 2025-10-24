import 'package:flutter/material.dart';

// Define custom colors based on user request
const Color primaryColor = Color(0xFF282C5C);
const Color secondaryBackgroundColor = Colors.white;
const Color dashboardBackgroundColor = Color(0xFFF5F5F5); // Clean, light grey (Grey 100)
const Color successColor = Color(0xFF10B981); // Green-600
const Color dangerColor = Color(0xFFEF4444); // Red-500
const Color warningColor = Color(0xFFFF9800); // Orange-500


class ExecutiveDashboard extends StatelessWidget {
  const ExecutiveDashboard({super.key});

  // --- Helper: Navigation Drawer ---
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Text(
              'CEO Navigation',
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
            leading: const Icon(Icons.show_chart, color: Colors.blue),
            title: const Text('Reports & Analytics'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.people, color: Colors.purple),
            title: const Text('Employee Management'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('Settings & Controls'),
            onTap: () {},
          ),
          const Divider(),
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
        title: const Text('Executive Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        // The Drawer button automatically appears here because we set the drawer property
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
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
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: const Text(
                    '5',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(), // ADDED: Drawer layout
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- 1. KPIs Overview ---
            const Text(
              'Key Performance Indicators (KPIs)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildKPIsGrid(context), // Context passed for responsiveness
            
            const SizedBox(height: 24),

            // --- 4. Quick Actions (MOVED TO TOP) ---
            _buildQuickActions(context), // Context passed for responsiveness

            const SizedBox(height: 24),

            // --- 2. Finance Overview ---
            _buildFinanceOverview(),

            const SizedBox(height: 24),

            // --- 3. AI Insights & Critical Alerts ---
            _buildAIInsights(),

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
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subtitleColor),
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
    // Show 4 columns on wide screens (desktop/tablet), 2 on mobile
    final crossAxisCount = screenWidth > 700 ? 4 : 2;
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
          value: '5,400',
          icon: Icons.school,
          iconColor: Colors.blue,
          subtitle: '+2% MoM',
          subtitleColor: successColor,
        ),
        _buildKPICard(
          title: 'Revenue This Month',
          value: '\$450.2K',
          icon: Icons.trending_down,
          iconColor: dangerColor,
          subtitle: '-15% MoM',
          subtitleColor: dangerColor,
        ),
        _buildKPICard(
          title: 'Pending Fees',
          value: '\$85,000',
          icon: Icons.warning,
          iconColor: dangerColor,
          subtitle: 'High Alert',
          subtitleColor: dangerColor,
        ),
        _buildKPICard(
          title: 'Student Attendance',
          value: '92.1%',
          icon: Icons.check_circle,
          iconColor: Colors.teal,
          subtitle: 'Avg.',
          subtitleColor: Colors.grey[500],
        ),
        _buildKPICard(
          title: 'Total Employees',
          value: '150',
          icon: Icons.group,
          iconColor: Colors.purple,
        ),
        _buildKPICard(
          title: 'Tasks Pending',
          value: '12',
          icon: Icons.assignment_late,
          iconColor: warningColor,
          subtitle: '7 Overdue',
          subtitleColor: dangerColor,
        ),
        _buildKPICard(
          title: 'Course Completion',
          value: '88%',
          icon: Icons.percent,
          iconColor: Colors.amber,
          subtitle: 'Goal Met',
          subtitleColor: successColor,
        ),
        _buildKPICard(
          title: 'Certificates Issued',
          value: '1,560',
          icon: Icons.card_membership,
          iconColor: Colors.lime,
          subtitle: 'Q3 Total',
          subtitleColor: Colors.grey[500],
        ),
      ],
    );
  }

  // Section 2: Finance Overview (Mock Chart)
  Widget _buildFinanceOverview() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Finance Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              'Monthly Fees Collected Trend',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            
            // Mock Line Graph Area
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Center(
                child: Text(
                  'Simulated Revenue Trend Chart',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            
            // Pending Installments List
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.credit_card, color: dangerColor),
              title: const Text('Pending Installments', style: TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Text('View All', style: TextStyle(color: Colors.blue, fontSize: 12)),
            ),
            _buildInstallmentItem(
                'Student A - \$1,500', 'Overdue (2 Days)', dangerColor),
            _buildInstallmentItem(
                'Upcoming - \$8,200', 'Due in 5 days', warningColor),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentItem(String title, String status, Color color) {
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
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(status, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Section 3: AI Insights & Critical Alerts
  Widget _buildAIInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Insights & Critical Alerts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: dangerColor),
        ),
        const SizedBox(height: 12),
        _buildAlertCard(
          title: 'Student Retention Alert',
          message: 'These 10 students are likely to drop based on attendance and low performance scores.',
          color: dangerColor,
        ),
        _buildAlertCard(
          title: 'Task Management Concern',
          message: 'Employee ID 305 (Admin) has missed 5 deadlines this quarter.',
          color: warningColor,
        ),
        const SizedBox(height: 16),
        _buildEmployeeStatus(),
      ],
    );
  }

  Widget _buildAlertCard({required String title, required String message, required Color color}) {
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(fontSize: 13, color: color.withOpacity(0.8)),
            ),
            TextButton(
              onPressed: () {},
              child: Text('View Details', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeStatus() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Employee Status Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
            ),
            const SizedBox(height: 8),
            _buildStatusItem('Attendance Today:', '98% Present', successColor),
            _buildStatusItem('Leave Requests Pending:', '3 Approvals', warningColor),
            _buildStatusItem('Salary Disbursement:', 'Scheduled for T-3', Colors.blue),
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
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }


  // Section 4: Quick Actions - Made Responsive
  Widget _buildQuickActions(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: [
            _buildActionButton(context, Icons.announcement, 'Post New Notice', warningColor, isDesktop),
            _buildActionButton(context, Icons.assignment, 'Assign Task', Colors.blue, isDesktop),
            _buildActionButton(context, Icons.analytics, 'View Reports', successColor, isDesktop),
            _buildActionButton(context, Icons.file_download, 'Export Data', dangerColor, isDesktop),
            _buildActionButton(context, Icons.security, 'Delegate Access', Colors.purple, isDesktop),
          ],
        ),
      ],
    );
  }

  // Helper widget for action buttons - Made Responsive
  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, bool isDesktop) {
    // Determine button width based on screen size
    final double buttonWidth = isDesktop
        ? (MediaQuery.of(context).size.width * 0.9 / 4) // Allows for up to 4 buttons in a row on desktop
        : 160.0; // Fixed width for mobile

    return SizedBox(
      width: buttonWidth.clamp(140.0, 300.0), // Ensure min/max sensible size
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: color),
        label: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}