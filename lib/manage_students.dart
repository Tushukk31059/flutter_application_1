import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageStudentsPage extends StatelessWidget {
  const ManageStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Students"),
        backgroundColor: const Color(0xFF282C5C),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No students registered yet."));
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              var data = students[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: data['imageUrl'] != null
                        ? NetworkImage(data['imageUrl'])
                        : null,
                    child: data['imageUrl'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(data['name'] ?? 'Unknown'),
                  subtitle: Text("${data['email']} • ${data['mobile']}"),
                  trailing: Text(data['branch'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
