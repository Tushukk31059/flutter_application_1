import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/admin_login.dart';
import 'package:flutter_application_1/databasehelper.dart';
import 'package:flutter_application_1/employeeform.dart';
import 'package:flutter_application_1/student_dashboard.dart';
// import 'package:animations/animations.dart';
import 'package:flutter_application_1/validate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TechCadd extends StatelessWidget {
  const TechCadd({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Login',
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primaryColor: const Color(0xFF282C5C),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF282C5C),
          secondary: Color(0xFF282C5C),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _loading=true;
  final TextEditingController _regController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  int selectedIndex = 0;
  int oldIndex = 0;

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  final List<String> userTypes = ['Student', 'Employer', 'Admin'];
  final List<IconData> userIcons = [
    Icons.school,
    Icons.business,
    Icons.admin_panel_settings,
  ];
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _logoAnimation = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
    _logoController.forward();
  }
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final regId = prefs.getString('reg_id');

    if (regId != null) {
      final student = await DatabaseHelper.instance.getStudentByRegId(regId);
      if (student != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDashboardScreen(
              name: student.name,
              course: student.course,
              image: student.imagePath,
            ),
          ),
        );
        return;
      }
    }

    // no auto-login
    setState(() {
      _loading = false;
    });
  }



  @override
  void dispose() {
    _logoController.dispose();
    _regController.dispose();
    _passController.dispose();

    super.dispose();
  }

  void _onTabChanged(int index) {
    if (index != selectedIndex) {
      HapticFeedback.lightImpact();
      setState(() {
        oldIndex = selectedIndex;
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                const SizedBox(height: 36),

                // Animated Welcome Text
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF282C5C), Color(0xFF282C5C)],
                            ).createShader(bounds),
                            child: const Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue to your account',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                Image.asset(
                  "assets/images/gtechh.png",
                  width: 240,
                  height: 69,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 20),

                // Tab Selector
                AnimatedUserTypeSelector(
                  userTypes: userTypes,
                  userIcons: userIcons,
                  selectedIndex: selectedIndex,
                  onTabChanged: _onTabChanged,
                ),

                const SizedBox(height: 30),

                // Swipeable Content Area with PageTransitionSwitcher
                // Swipeable Content Area (NO animation, instant switch)
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0 && selectedIndex > 0) {
                      _onTabChanged(selectedIndex - 1);
                    } else if (details.primaryVelocity! < 0 &&
                        selectedIndex < userTypes.length - 1) {
                      _onTabChanged(selectedIndex + 1);
                    }
                  },
                  child: KeyedSubtree(
                    key: ValueKey<int>(selectedIndex),
                    child: _buildContent(),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return _buildStudentForm();
      case 1:
        return _buildEmployerForm();
      case 2:
        return _buildAdminForm();
      default:
        return _buildStudentForm();
    }
  }

  // ------------------- Forms -------------------

  Widget _buildStudentForm() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _formHeader(Icons.school, 'Student Login'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Registration Number',
                controller: _regController,
                icon: Icons.badge,
                hintText: 'Enter Registration Number',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Password',
                icon: Icons.lock,
                hintText: 'Enter your password',
                isPassword: true,
                controller: _passController
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => HapticFeedback.lightImpact(),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF282C5C),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              _buildStudentSignInButton(),
              SizedBox(height: 10),
              Center(child: _buildNewRegistrationButton()),
            ],
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildEmployerForm() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _formHeader(Icons.business, 'Employer Login'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Email Address',
                icon: Icons.email,
                hintText: 'Enter your email address',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Password',
                icon: Icons.lock,
                hintText: 'Enter your password',
                isPassword: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => HapticFeedback.lightImpact(),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF282C5C),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              _buildEmployeeSignInButton(),
              SizedBox(height: 10),
              Center(child: _buildNewEmpRegistrationButton()),
            ],
          ),
        ),
      ],
    );
  }
  

  Widget _buildAdminForm() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _formHeader(Icons.admin_panel_settings, 'Admin Access'),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!, width: 1.5),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    prefixIcon: Icon(
                      Icons.account_tree,
                      color: Color(0xFF282C5C),
                    ),
                  ),
                  hint: Text(
                    'Select Branch',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Jalandhar-I',
                      child: const Text('Jalandhar-I'),
                    ),
                    DropdownMenuItem(
                      value: 'Jalandhar-II',
                      child: const Text('Jalandhar-II'),
                    ),
                    DropdownMenuItem(
                      value: 'Phagwara',
                      child: const Text('Phagwara'),
                    ),
                    DropdownMenuItem(
                      value: 'Hoshiarpur',
                      child: const Text('Hoshiarpur'),
                    ),
                    DropdownMenuItem(
                      value: 'Ludhiana',
                      child: const Text('Ludhiana'),
                    ),
                    DropdownMenuItem(
                      value: "Chandigarh",
                      child: const Text("Chandigarh"),
                    ),
                  ],
                  onChanged: (value) => HapticFeedback.lightImpact(),
                ),
              ),
              const SizedBox(height: 32),
              _buildSignInButton(),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------- Helpers -------------------

  Widget _formHeader(IconData icon, String title) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF282C5C), size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF282C5C),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(26),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextEditingController? controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
          ),
          child: TextField(
            obscureText: isPassword,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(icon, color: const Color(0xFF282C5C)),
              contentPadding: const EdgeInsets.all(13),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF282C5C), Color(0xFF282C5C)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF282C5C).withAlpha(26),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminLoginScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentSignInButton() {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF282C5C), Color(0xFF282C5C)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF282C5C).withAlpha(26),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child:ElevatedButton(
      onPressed: () async {
        HapticFeedback.lightImpact();
        final regId = _regController.text.trim();
        final password = _passController.text.trim();

        if (regId.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill all fields')),
          );
          return;
        }

        // validate using your DatabaseHelper
        final student = await DatabaseHelper.instance.validateStudent(regId, password);

        if (student != null) {
          // ✅ store reg_id only
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('reg_id', regId);

          // ✅ navigate to dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDashboardScreen(
                name: student.name,
                course: student.course,
                image: student.imagePath,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Registration or Password')),
          );
        }
      },

      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeSignInButton() {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF282C5C), Color(0xFF282C5C)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF282C5C).withAlpha(26),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AdminLoginScreen()),
          // );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
  Widget _buildNewRegistrationButton() {
    return TextButton(
      focusNode: FocusNode(canRequestFocus: false),
      onPressed: () => {
        HapticFeedback.lightImpact(),
        FocusManager.instance.primaryFocus?.unfocus(),
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentFormPage()),
        ),

        //         showDialog(
        //   context: context,
        //   // builder: (context) {
        //   //   final TextEditingController _passwordController = TextEditingController();
        //   //   bool isPasswordVisible = false;
        //   //   bool isPasswordValid = false;

        //   //   // return StatefulBuilder(
        //   //   //   builder: (context, setState) {
        //   //   //     return Dialog(
        //   //   //       shape: RoundedRectangleBorder(
        //   //   //         borderRadius: BorderRadius.circular(20),
        //   //   //       ),
        //   //   //       backgroundColor: Colors.white,
        //   //   //       child: Container(
        //   //   //         padding: const EdgeInsets.all(20),
        //   //   //         child: Column(
        //   //   //           mainAxisSize: MainAxisSize.min,
        //   //   //           children: [
        //   //   //             const Icon(Icons.info, size: 50, color: Color(0xFF282C5C)),
        //   //   //             const SizedBox(height: 12),
        //   //   //             const Text(
        //   //   //               "Please Enter Your Password to Register",
        //   //   //               textAlign: TextAlign.center,
        //   //   //               style: TextStyle(
        //   //   //                 fontSize: 18,
        //   //   //                 fontWeight: FontWeight.bold,
        //   //   //                 color: Color(0xFF282C5C),
        //   //   //               ),
        //   //   //             ),
        //   //   //             const SizedBox(height: 16),

        //   //   //             // Password field styled same as form
        //   //   //             Container(
        //   //   //               decoration: BoxDecoration(
        //   //   //                 borderRadius: BorderRadius.circular(16),
        //   //   //                 border: Border.all(color: Colors.grey[300]!, width: 1.5),
        //   //   //               ),
        //   //   //               child: TextField(
        //   //   //                 controller: _passwordController,
        //   //   //                 obscureText: !isPasswordVisible,
        //   //   //                 onChanged: (value) {
        //   //   //                   setState(() {
        //   //   //                     isPasswordValid = value.length >= 6; // simple check
        //   //   //                   });
        //   //   //                 },
        //   //   //                 decoration: InputDecoration(
        //   //   //                   hintText: "Enter password",
        //   //   //                   hintStyle: TextStyle(color: Colors.grey[500]),
        //   //   //                   border: InputBorder.none,
        //   //   //                   prefixIcon: const Icon(Icons.lock,
        //   //   //                       color: Color(0xFF282C5C)),
        //   //   //                   suffixIcon: Row(
        //   //   //                     mainAxisSize: MainAxisSize.min,
        //   //   //                     children: [
        //   //   //                       Icon(
        //   //   //                         isPasswordValid
        //   //   //                             ? Icons.check_circle
        //   //   //                             : Icons.cancel,
        //   //   //                         color:
        //   //   //                             isPasswordValid ? Colors.green : Colors.red,
        //   //   //                       ),
        //   //   //                       IconButton(
        //   //   //                         icon: Icon(
        //   //   //                           isPasswordVisible
        //   //   //                               ? Icons.visibility
        //   //   //                               : Icons.visibility_off,
        //   //   //                           color: Colors.grey[700],
        //   //   //                         ),
        //   //   //                         onPressed: () {
        //   //   //                           setState(() {
        //   //   //                             isPasswordVisible = !isPasswordVisible;
        //   //   //                           });
        //   //   //                         },
        //   //   //                       ),
        //   //   //                     ],
        //   //   //                   ),
        //   //   //                   contentPadding: const EdgeInsets.all(13),
        //   //   //                 ),
        //   //   //                 style: const TextStyle(
        //   //   //                   fontSize: 16,
        //   //   //                   fontWeight: FontWeight.w500,
        //   //   //                 ),
        //   //   //               ),
        //   //   //             ),

        //   //   //             const SizedBox(height: 20),

        //   //   //             SizedBox(
        //   //   //               width: double.infinity,
        //   //   //               child: ElevatedButton(
        //   //   //                 onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentFormPage())),
        //   //   //                 style: ElevatedButton.styleFrom(
        //   //   //                   backgroundColor: const Color(0xFF282C5C),
        //   //   //                   shape: RoundedRectangleBorder(
        //   //   //                     borderRadius: BorderRadius.circular(28),
        //   //   //                   ),
        //   //   //                   padding: const EdgeInsets.symmetric(vertical: 14),
        //   //   //                 ),
        //   //   //                 child: const Text(
        //   //   //                   "Close",
        //   //   //                   style: TextStyle(
        //   //   //                     color: Colors.white,
        //   //   //                     fontSize: 16,
        //   //   //                     fontWeight: FontWeight.w600,
        //   //   //                   ),
        //   //   //                 ),
        //   //   //               ),
        //   //   //             ),
        //   //   //           ],
        //   //   //         ),
        //   //   //       ),
        //   //   //     );
        //   //   //   },
        //   //   // );
        //   // },
        // ),
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_add, color: Color(0xFF282C5C), size: 20),
          SizedBox(width: 8),
          Text(
            'New Registration? Click here',
            style: TextStyle(
              color: Color(0xFF282C5C),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewEmpRegistrationButton() {
    return TextButton(
      focusNode: FocusNode(canRequestFocus: false),
      onPressed: () => {
        HapticFeedback.lightImpact(),
        FocusManager.instance.primaryFocus?.unfocus(),
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmployeeFormPage()),
        ),
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_add, color: Color(0xFF282C5C), size: 20),
          SizedBox(width: 8),
          Text(
            'New Registration? Click here',
            style: TextStyle(
              color: Color(0xFF282C5C),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- Animated Tab Selector -------------------

class AnimatedUserTypeSelector extends StatefulWidget {
  final List<String> userTypes;
  final List<IconData> userIcons;
  final int selectedIndex;
  final Function(int) onTabChanged;

  const AnimatedUserTypeSelector({
    super.key,
    required this.userTypes,
    required this.userIcons,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  State<AnimatedUserTypeSelector> createState() =>
      _AnimatedUserTypeSelectorState();
}

class _AnimatedUserTypeSelectorState extends State<AnimatedUserTypeSelector> {
  @override
  Widget build(BuildContext context) {
    final tabWidth = (MediaQuery.of(context).size.width - 32) / 3;

    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: tabWidth * widget.selectedIndex,
            top: 0,
            bottom: 0,
            child: Container(
              width: tabWidth,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF282C5C), Color(0xFF282C5C)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF282C5C).withAlpha(26),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: widget.userTypes.asMap().entries.map((entry) {
              int index = entry.key;
              String userType = entry.value;
              IconData icon = widget.userIcons[index];
              bool isSelected = index == widget.selectedIndex;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!isSelected) widget.onTabChanged(index);
                  },
                  child: SizedBox(
                    height: 48,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            color: isSelected ? Colors.white : Colors.grey[600],
                            size: 16,
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 6),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              child: Text(userType),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
