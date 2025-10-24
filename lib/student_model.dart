class Student {
  final int rNo;
  final String name;
  final String email;
  final int contact;
  final String password;
  final String branch;
  final String course;
  final String subCategory;
  final String typeOfCourse;
  final String duration;
  final String date;
  final String imagePath;

  Student({
    required this.rNo,
    required this.name,
    required this.email,
    required this.contact,
    required this.password,
    required this.branch,
    required this.course,
    required this.subCategory,
    required this.typeOfCourse,
    required this.duration,
    required this.date,
    required this.imagePath,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      rNo: map['r_no'],
      name: map['student_name'],
      email: map['student_email'],
      contact: map['student_contact'],
      password: map['password'],
      branch: map['branch'],
      course: map['course'],
      subCategory: map['sub_category'],
      typeOfCourse: map['type_of_course'],
      duration: map['duration'],
      date: map['date'],
      imagePath: map['student_image'],
    );
  }
}
