import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_application_1/techcadd.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color primaryColor = Color(0xFF282C5C);
const Color backgroundColor = Color(0xFFF7F9FC); // Light background
const Color secondaryColor = Color(0xFF10B981); // Emerald - Success
const Color warningColor = Color(0xFFF59E0B); // Amber - Warning
const Color dangerColor = Color(0xFFEF4444); // Red - Critical/Due
const Color infoColor = Color(0xFF3B82F6); // Blue - Info
const Color codingColor = Color(0xFF06B6D4); // Cyan - Coding
const Color grayBorderColor = Color(0xFF6B7280); // Gray 500



class AttendanceScreen extends StatefulWidget {
  final String name;
  final String course;
  final String image;
  const AttendanceScreen({super.key,
    required this.name,
    required this.course,
    required this.image,});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 1,
        title: Text(
          "Student Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
        ),
        backgroundColor: backgroundColor,
        // Hide the default drawer icon on desktop
        automaticallyImplyLeading: MediaQuery.of(context).size.width < 1024,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      drawer: MediaQuery.of(context).size.width < 1024
          ? SidebarWidget(name: widget.name, course: widget.course, image: widget.image)
          : null,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(children: [const SizedBox(height: 36),
              AttendanceCard()
            ]),
          ),
        ),
      ),
    );
  }
}


class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: primaryColor, width: 4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall Attendance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   'Required: 75% | Safe Zone: > 80%',
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     color: Colors.grey.shade500,
                    //   ),
                    // ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'MERN Stack Course',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Progress Circle (72%)
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(
                          value: 0.72, // 72%
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            warningColor,
                          ),
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: '72',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: warningColor,
                          ),
                          children: const [
                            TextSpan(text: '%', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(secondaryColor, 'Days Present:', '34/45'),
                    const SizedBox(height: 8),
                    _buildDetailRow(dangerColor, 'Days Absent:', '11'),
                    const SizedBox(height: 16),
                    Text(
                      'Status: Warning!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: warningColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: Text(
                'View Day-Wise Breakdown →',
                style: TextStyle(color: primaryColor, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
class SidebarWidget extends StatelessWidget {
  final bool isDesktop;
  final String name;
  final String course;
  final String image;

  const SidebarWidget({
    super.key,
    this.isDesktop = false,
    required this.name,
    required this.course,
    required this.image,
  });

  Widget _buildNavLink(
      IconData icon,
      String title, {
        bool isActive = false,
        VoidCallback? onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: isActive ? primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isDesktop ? 256 : 300,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: isDesktop
            ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]
            : null,
      ),
      child: Column(
        children: [
          // Logo/App Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Techcadd',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Student Portal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // Student Profile Widget
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: infoColor,
                  child: ClipOval(
                    child: Image.file(
                      File(image),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Course: $course',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // Navigation Links
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildNavLink(
                    Icons.dashboard_rounded,
                    'Dashboard',

                  ),
                  _buildNavLink(
                    Icons.calendar_today_rounded,
                    'Attendance Record',
                    isActive: true

                  ),
                  _buildNavLink(
                    Icons.assignment_rounded,
                    'Projects & Assignments',
                  ),
                  _buildNavLink(
                    Icons.account_balance_wallet_rounded,
                    'Fees & Payments',
                  ),
                ],
              ),
            ),
          ),
          // Logout Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: InkWell(
              onTap: () async {
                // ✅ Remove saved reg_id from SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('reg_id');

                // ✅ Navigate back to LoginScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: _buildNavLink(
                Icons.logout_rounded,
                'Logout',
                isActive: false,
                onTap: () async {
                  // ✅ Remove saved reg_id
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('reg_id');

                  // ✅ Navigate back to login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

