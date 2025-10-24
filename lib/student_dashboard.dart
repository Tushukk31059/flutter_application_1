import 'package:flutter/material.dart';
import 'package:flutter_application_1/attendance.dart';
import 'dart:io';

import 'package:flutter_application_1/techcadd.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- COLOR AND CONSTANTS ---
// Custom Brand Primary Color (0xFF282C5C)
const Color primaryColor = Color(0xFF282C5C);
const Color backgroundColor = Color(0xFFF7F9FC); // Light background
const Color secondaryColor = Color(0xFF10B981); // Emerald - Success
const Color warningColor = Color(0xFFF59E0B); // Amber - Warning
const Color dangerColor = Color(0xFFEF4444); // Red - Critical/Due
const Color infoColor = Color(0xFF3B82F6); // Blue - Info
const Color codingColor = Color(0xFF06B6D4); // Cyan - Coding
const Color grayBorderColor = Color(0xFF6B7280); // Gray 500

// class StudentDashboardApp extends StatelessWidget {
//   final String name;
//   final String course;

//   const StudentDashboardApp({
//     super.key,
//     required this.name,
//     required this.course,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TechEdu Student Portal',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily:
//             'Inter', // Assuming Inter font is available or a sensible default is used
//         primaryColor: primaryColor,
//         scaffoldBackgroundColor: backgroundColor,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: primaryColor,
//           elevation: 0,
//         ),
//         colorScheme: ColorScheme.fromSwatch(
//           primarySwatch: const MaterialColor(0xFF282C5C, {
//             50: Color(0xFFE5E6E8),
//             100: Color(0xFFBFC2C7),
//             200: Color(0xFF949AA1),
//             300: Color(0xFF69727B),
//             400: Color(0xFF495460),
//             500: Color(0xFF282C5C), // Primary Color
//             600: Color(0xFF232854),
//             700: Color(0xFF1C2048),
//             800: Color(0xFF161A3C),
//             900: Color(0xFF0D102A),
//           }),
//         ).copyWith(secondary: infoColor),
//         cardTheme: CardThemeData(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadiusGeometry.circular(16),
//           ),
//         ),

//         // CardTheme(
//         //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         //   elevation: 4,
//         // )
//       ),
//       home: const StudentDashboardScreen(),
//     );
//   }
// }

class StudentDashboardScreen extends StatelessWidget {
  final String name;
  final String course;
  final String image;

  const StudentDashboardScreen({
    super.key,
    required this.name,
    required this.course,
    required this.image,
  });

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
          ? SidebarWidget(name: name, course: course, image: image)
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1024) {
            // Desktop Layout (Fixed Sidebar + Main Content)
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SidebarWidget(
                  isDesktop: true,
                  name: name,
                  course: course,
                  image: image,
                ),
                Expanded(
                  child: MainContentArea(name: name, course: course),
                ),
              ],
            );
          } else {
            // Mobile/Tablet Layout (Drawer Sidebar + Main Content)
            return MainContentArea(name: name, course: course);
          }
        },
      ),
    );
  }
}

// --- SIDEBAR WIDGET (DRAWER) ---
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
                    isActive: true,
                  ),
                  _buildNavLink(
                    Icons.calendar_today_rounded,
                    'Attendance Record',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AttendanceScreen(name: name, course: course, image: image,)),
                      );
                    },
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

// --- MAIN CONTENT AREA ---
class MainContentArea extends StatelessWidget {
  final String name;
  final String course;

  const MainContentArea({super.key, required this.name, required this.course});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Welcome,$name ',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          // Text(
          //   'Quick summary of your course.',
          //   style: TextStyle(color: Colors.grey.shade500),
          // ),
          const SizedBox(height: 24),

          // Top Row: Attendance and Fee Alert
          LayoutBuilder(
            builder: (context, constraints) {
              // Adjust layout for small vs large screens
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: FeeAlertCard()),
                  ],
                );
              } else {
                return Column(
                  children: [const SizedBox(height: 24), FeeAlertCard()],
                );
              }
            },
          ),
          const SizedBox(height: 32),

          // Middle Row: Topics, Progress, Announcements
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1000) {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: CourseProgressCard()),
                    SizedBox(width: 24),
                    Expanded(child: AnnouncementsCard()),
                  ],
                );
              } else {
                return Column(
                  children: const [
                    CourseProgressCard(),
                    SizedBox(height: 24),
                    AnnouncementsCard(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
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
      Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      const SizedBox(width: 4),
      Text(
        value,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

// --- 2. FEE ALERT CARD ---
class FeeAlertCard extends StatelessWidget {
  FeeAlertCard({super.key});

  final TextStyle labelStyle = TextStyle(
    fontSize: 13,
    color: Colors.grey.shade500,
  );
  final TextStyle valueStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: dangerColor,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: dangerColor, width: 4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fee and Payment Alerts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Next Installment Alert
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: dangerColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: dangerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Next Installment', style: labelStyle),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹ 15,000', style: valueStyle),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: dangerColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Due in 4 Days!',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Total Dues
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Dues', style: labelStyle),
                  const SizedBox(height: 4),
                  Text(
                    '₹ 30,000',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            TextButton(
              onPressed: () {},
              child: const Text(
                'Pay Now →',
                style: TextStyle(color: dangerColor, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 3. TODAY'S TOPIC CARD ---

// --- 4. COURSE PROGRESS CARD ---
class CourseProgressCard extends StatelessWidget {
  const CourseProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: infoColor, width: 4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Course Module Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Module Progress
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: infoColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MERN Stack Development (8 Modules)',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Module 4/8',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: infoColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.50, // 50%
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(infoColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Progress: 50% Completed',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Next Major Project
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Major Project',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'E-commerce API Backend',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Due Date: 15 Nov 2024',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            TextButton(
              onPressed: () {},
              child: const Text(
                'View All Projects →',
                style: TextStyle(color: infoColor, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 5. ANNOUNCEMENTS CARD ---
class AnnouncementsCard extends StatelessWidget {
  const AnnouncementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: warningColor, width: 4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Important Announcements",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250, // Fixed height for scrolling
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildAnnouncement(
                    isUrgent: true,
                    title: 'Project Submission Portal Closing',
                    body:
                        "The 'Authentication Module' project will not be accepted after 11:59 PM tonight.",
                  ),
                  _buildAnnouncement(
                    isUrgent: false,
                    title: 'New AI Course Batch Starts',
                    body:
                        "Students who registered should report to Lab 101 tomorrow at 9 AM.",
                  ),
                  _buildAnnouncement(
                    isUrgent: false,
                    title: 'Class Timing Change',
                    body:
                        "Python evening class will be held at 2 PM today (one-time change).",
                  ),
                  _buildAnnouncement(
                    isUrgent: false,
                    title: 'Holiday Notice',
                    body:
                        "The institute will be closed next Monday for a public holiday.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All Notifications →',
                style: TextStyle(color: warningColor, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncement({
    required bool isUrgent,
    required String title,
    required String body,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: isUrgent ? dangerColor : primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isUrgent ? dangerColor : primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
