import 'package:flutter/material.dart';
// Note: You would typically need packages like fl_chart for real graphs.
// This code provides the structure and styling.

// --- Color Constants ---
const Color kPrimaryColor = Color(0xFF282C5C);
const Color kBackgroundColor = Color(0xFFF7F9FC);
const Color kAccentGreen = Color(0xFF4CAF50);
const Color kAccentRed = Color(0xFFF44336);
const Color kAccentAmber = Color(0xFFFFC107);
const Color kAccentGray = Color(0xFF6B7280);
const Color kCardColor = Colors.white;

// --- Main Widget ---
class CEOAdminDashboard extends StatelessWidget {
  const CEOAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // For large screens, use a Row with Sidebar and Content
      body: Row(
        children: [
          // 1. Sidebar (Visible on large screens)
          const AdminSidebar(),

          // 2. Main Content Area (Flexible)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const DashboardHeader(),
                  const SizedBox(height: 24),

                  // 1. KPI Cards Row
                  const KpiCardRow(),
                  const SizedBox(height: 32),

                  // 2. Charts and Data Section
                  const DashboardMetricsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Sidebar Implementation ---
class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Check screen size to hide sidebar on mobile (simplified for this context)
    final isLargeScreen = MediaQuery.of(context).size.width > 900;

    if (!isLargeScreen) return const SizedBox.shrink();

    return Container(
      width: 256,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo/Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: RichText(
              text: TextSpan(
                text: 'ORG.',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
                children: [
                  TextSpan(
                    text: 'ADMIN',
                    style: TextStyle(
                      color: kAccentGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // CEO Profile
          ListTile(
            leading: CircleAvatar(
              backgroundColor: kAccentGreen,
              child: const Text(
                'C',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: const Text(
              'Super Admin',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'Executive Oversight',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const Divider(color: Colors.white24, thickness: 1, height: 24),

          // Navigation Links
          _SidebarItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            isActive: true,
          ),
          _SidebarItem(
            icon: Icons.currency_exchange,
            title: 'Financial Approvals',
          ),
          _SidebarItem(icon: Icons.security, title: 'System & Security'),
          _SidebarItem(icon: Icons.insert_drive_file, title: 'All Reports'),
          _SidebarItem(icon: Icons.people_alt, title: 'Admin Management'),

          const Spacer(),

          // Logout Link
          _SidebarItem(
            icon: Icons.logout,
            title: 'Logout',
            textColor: kAccentRed,
          ),
        ],
      ),
    );
  }
}

// Helper Widget for Sidebar Items
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final Color? textColor;

  const _SidebarItem({
    required this.icon,
    required this.title,
    this.isActive = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? (isActive ? Colors.white : Colors.white70);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, color: color, size: 24),
          title: Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          onTap: () {
            // Handle navigation logic
          },
        ),
      ),
    );
  }
}

// --- Header Implementation ---
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Executive Dashboard',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        const Text(
          'Monitor overall organizational performance and governance.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }
}

// --- KPI Card Row Implementation ---
class KpiCardRow extends StatelessWidget {
  const KpiCardRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth =
            (constraints.maxWidth - 48) / 3; // 24 padding * 2

        return Wrap(
          spacing: 24.0,
          runSpacing: 24.0,
          children: [
            // Card 1: Financial Decisions Pending
            _KpiCard(
              title: 'FINANCIAL DECISIONS PENDING',
              value: '12',
              valueColor: kAccentRed,
              subtitle: 'Approvals/Rejections Awaiting Action',
              icon: Icons.account_balance_wallet,
              borderColor: kAccentRed,
              width: cardWidth,
            ),
            // Card 2: Overall Active Users
            _KpiCard(
              title: 'OVERALL ACTIVE USERS',
              value: '1,540',
              valueColor: kPrimaryColor,
              subtitle: 'Total Students & Employees',
              icon: Icons.people_alt,
              borderColor: kPrimaryColor,
              trend: '+3% MoM',
              trendColor: kAccentGreen,
              width: cardWidth,
            ),
            // Card 3: Total Revenue
            _RevenueCard(width: cardWidth),
          ],
        );
      },
    );
  }
}

// Helper Widget for Generic KPI Card
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final String subtitle;
  final IconData icon;
  final Color borderColor;
  final String? trend;
  final Color? trendColor;
  final double width;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.subtitle,
    required this.icon,
    required this.borderColor,
    this.trend,
    this.trendColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: borderColor, width: 6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
              Icon(icon, color: borderColor, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          if (trend != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_upward, color: trendColor, size: 18),
                  Text(
                    trend!,
                    style: TextStyle(
                      color: trendColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// Specific Revenue Card with Gauge
class _RevenueCard extends StatelessWidget {
  final double width;
  const _RevenueCard({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: kAccentGreen, width: 6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOTAL FEES COLLECTED YTD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '\$7.5M',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const Text(
                'Target: \$10.0M',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          // Placeholder for Radial Gauge (requires a chart package like fl_chart)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kAccentGreen, width: 4),
            ),
            child: Center(
              child: Icon(Icons.trending_up, color: kAccentGreen, size: 40),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Metrics Section Implementation (Charts and Logs) ---
class DashboardMetricsSection extends StatelessWidget {
  const DashboardMetricsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column (Performance Metrics)
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORGANIZATIONAL PERFORMANCE REPORTS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const Divider(color: kAccentGray, thickness: 1, height: 24),

                    // Payroll Trend Placeholder
                    const Text(
                      'MONTHLY PAYROLL TREND (Salaries Report)',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      color:
                          kBackgroundColor, // Placeholder for line chart area
                      child: const Center(
                        child: Text(
                          'Line Chart Placeholder',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sub-Metrics Row
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Course Completion Rate
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'COURSE COMPLETION RATE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '60%',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                'Needs Improvement',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        // Attendance Rate
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AVG. ORGANIZATION ATTENDANCE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '94%',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: kAccentGreen,
                                ),
                              ),
                              Text(
                                'Combined Student & Employee Rate',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        // Outstanding Fees
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'OUTSTANDING FEES VALUE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '\$45K',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: kAccentAmber,
                                ),
                              ),
                              Text(
                                '35% of monthly target pending',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Right Column (System & Security)
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SYSTEM & SECURITY OVERSIGHT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const Divider(color: kAccentGray, thickness: 1, height: 24),

                    // Backup Status
                    ListTile(
                      leading: Icon(
                        Icons.cloud_done,
                        color: kAccentGreen,
                        size: 36,
                      ),
                      title: const Text(
                        'Backup Successful',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kAccentGreen,
                        ),
                      ),
                      subtitle: const Text(
                        'Last run: 2025-10-09 02:00 AM',
                        style: TextStyle(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),

                    const Divider(color: kAccentGray, thickness: 1, height: 24),

                    // Critical Error Log
                    const Text(
                      'CRITICAL ERROR LOG',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 50,
                      color:
                          kBackgroundColor, // Placeholder for error bar chart
                      child: const Center(
                        child: Text(
                          'Error Bar Chart Placeholder',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Admin Activity Log
                    const Text(
                      'ADMIN ACTIVITY LOG',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _ActivityLogItem(
                      action: 'CEO removed user John Doe.',
                      detail: '5 mins ago | User Mgmt',
                    ),
                    const _ActivityLogItem(
                      action: 'HR Admin access role updated to \'Limited\'.',
                      detail: '1 hour ago | Permissions',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Helper Widget for Activity Log Item
class _ActivityLogItem extends StatelessWidget {
  final String action;
  final String detail;

  const _ActivityLogItem({required this.action, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6.0, right: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  detail,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// NOTE: This file is purely conceptual for use in a Flutter/Dart project.
