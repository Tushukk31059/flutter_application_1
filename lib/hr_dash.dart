import 'package:flutter/material.dart';



// Define custom colors based on user request
const Color primaryColor = Color(0xFF282C5C);
const Color secondaryBackgroundColor = Colors.white;
const Color dashboardBackgroundColor = Color(0xFFF5F5F5); // Clean, light grey (Grey 100)
const Color successColor = Color(0xFF10B981); // Green-600
const Color dangerColor = Color(0xFFEF4444); // Red-500
const Color warningColor = Color(0xFFFF9800); // Orange-500

class HRDashboard extends StatelessWidget {
  const HRDashboard({super.key});

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
              'HR Navigation',
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
            title: const Text('Employee Directory'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.blue),
            title: const Text('Attendance & Leave'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on, color: successColor),
            title: const Text('Payroll & Salary'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.analytics, color: warningColor),
            title: const Text('Reports'),
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
        title: const Text('HR Executive Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    '3', // HR Alerts count
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            // --- 4. Quick Actions (TOP) ---
            _buildQuickActions(context),

            const SizedBox(height: 24),
            
            // --- 1. HR Overview – Quick Stats (KPIs) ---
            const Text(
              'HR Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildKPIsGrid(context),
            
            const SizedBox(height: 24),

            // --- 3. Attendance & Leave Tracking ---
            _buildAttendanceSummary(),

            const SizedBox(height: 24),

            // --- 4. Task Monitoring & Alerts ---
            _buildTaskAndAlerts(),

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
          title: 'Total Employees',
          value: '150',
          icon: Icons.people,
          iconColor: primaryColor,
          subtitle: '120 Teaching',
          subtitleColor: Colors.grey[500],
        ),
        _buildKPICard(
          title: 'Present Today',
          value: '142',
          icon: Icons.check_circle_outline,
          iconColor: successColor,
          subtitle: '94.7% Attendance',
          subtitleColor: successColor,
        ),
        _buildKPICard(
          title: 'Leave Requests',
          value: '8',
          icon: Icons.date_range,
          iconColor: dangerColor,
          subtitle: 'Pending Approval',
          subtitleColor: dangerColor,
        ),
        _buildKPICard(
          title: 'Tasks Completed',
          value: '95%',
          icon: Icons.task_alt,
          iconColor: Colors.blue,
          subtitle: 'Avg. Rate',
          subtitleColor: Colors.grey[500],
        ),
        _buildKPICard(
          title: 'Pending Disbursement',
          value: '\$0',
          icon: Icons.paid,
          iconColor: successColor,
          subtitle: 'All Cleared',
          subtitleColor: successColor,
        ),
        _buildKPICard(
          title: 'Complaints/Feedback',
          value: '4',
          icon: Icons.feedback,
          iconColor: warningColor,
          subtitle: 'Pending Resolution',
          subtitleColor: warningColor,
        ),
        _buildKPICard(
          title: 'New Hires (QTD)',
          value: '12',
          icon: Icons.person_add,
          iconColor: Colors.teal,
          subtitle: 'Onboarding in Prog.',
          subtitleColor: Colors.grey[500],
        ),
        _buildKPICard(
          title: 'HR Alerts',
          value: '3',
          icon: Icons.warning_amber,
          iconColor: dangerColor,
          subtitle: 'Critical Issues',
          subtitleColor: dangerColor,
        ),
      ],
    );
  }

  // Section 3: Attendance & Leave Tracking (Replaces Finance Overview)
  Widget _buildAttendanceSummary() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance & Leave Tracking',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildStatusItem('Monthly Attendance Rate:', '93.5%', Colors.blue),
            _buildStatusItem('Late Coming Alerts:', '15 Employees', warningColor),
            
            const SizedBox(height: 16),
            const Text(
              'Pending Leave Requests (8)',
              style: TextStyle(fontWeight: FontWeight.w500, color: dangerColor),
            ),
            
            // Pending Leave List
            _buildLeaveItem('J. Doe (Admin)', '3 days: Sick Leave', dangerColor),
            _buildLeaveItem('A. Smith (Trainer)', '5 days: Vacation', dangerColor),

            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.approval, size: 20, color: primaryColor),
                label: const Text('Approve/Reject Requests', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveItem(String employee, String reason, Color color) {
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
          Text(employee, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(reason, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  // Section 4: Task Monitoring & Alerts (Replaces AI Insights)
  Widget _buildTaskAndAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Monitoring & Alerts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        _buildAlertCard(
          title: 'High Priority: Delayed Task',
          message: 'The Q4 Recruitment Plan is 3 days overdue. Escalate now.',
          color: dangerColor,
          buttonText: 'Escalate',
        ),
        _buildAlertCard(
          title: 'Employee Complaint Received',
          message: 'A new employee complaint regarding desk allocation needs resolution.',
          color: warningColor,
          buttonText: 'Assign Resolution',
        ),
        const SizedBox(height: 16),
        _buildPayrollStatus(),
      ],
    );
  }

  Widget _buildAlertCard({required String title, required String message, required Color color, required String buttonText}) {
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
              child: Text(buttonText, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPayrollStatus() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payroll Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
            ),
            const SizedBox(height: 8),
            _buildStatusItem('Next Payroll Date:', '25th of the Month', Colors.blue),
            _buildStatusItem('Total Monthly Expense:', '\$520,000', successColor),
            _buildStatusItem('Pending Bonus Approvals:', '5 Employees', warningColor),
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
            _buildActionButton(context, Icons.person_add, 'Add New Employee', primaryColor, isDesktop),
            _buildActionButton(context, Icons.approval, 'Approve Leave', dangerColor, isDesktop),
            _buildActionButton(context, Icons.assignment_add, 'Assign Task', Colors.blue, isDesktop),
            _buildActionButton(context, Icons.campaign, 'Post Notice', warningColor, isDesktop),
            _buildActionButton(context, Icons.folder_open, 'Employee Docs', Colors.teal, isDesktop),
          ],
        ),
      ],
    );
  }

  // Helper widget for action buttons - Made Responsive
  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, bool isDesktop) {
    // Determine button width based on screen size
    final double buttonWidth = isDesktop
        ? (MediaQuery.of(context).size.width * 0.9 / 5) // Allows for up to 5 buttons in a row on desktop
        : 160.0; // Fixed width for mobile

    return SizedBox(
      width: buttonWidth.clamp(140.0, 300.0), // Ensure min/max sensible size
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 13, color: Colors.white)),
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
