import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misch/pages/teach_dashboard.dart';

class AssignmentForm extends StatefulWidget {
  final DateTime initialDueDate;  // Add this

  AssignmentForm({required this.initialDueDate});  // Modify the constructor

  @override
  _AssignmentFormState createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _selectedDueDate = DateTime.now();
  List<String> _questions = [];
  List<String> _students = [];
  final _questionController = TextEditingController();
  final _studentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDueDate = widget.initialDueDate;  // Use the passed initial due date
  }

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Badge logic (for simplicity, we'll use a hardcoded badge name for now)
  String badgeName = 'Animal Adventurer'; // Example badge

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Save assignment data to Firestore
        await _firestore.collection('assignments').add({
          'title': _title,
          'dueDate': _selectedDueDate,
          'questions': _questions,
          'students': _students,
          'created_at': Timestamp.now(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Assignment created successfully!')),
        );

        // Return to Teacher Dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TeacherDashboard()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Could not add assignment.')),
        );
      }
    }
  }



  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDueDate)
      setState(() {
        _selectedDueDate = pickedDate;
      });
  }

// Update _pickDueDate function to show feedback when a date is selected
  void _pickDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
      // Show feedback when a date is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Due date selected: ${_selectedDueDate.toLocal()}'.split(' ')[0])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Assignment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Assignment Title Field
                TextFormField(
                  decoration: InputDecoration(labelText: 'Assignment Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                // Due Date Picker
                Row(
                  children: [
                    Text(
                      'Due Date: ${_selectedDueDate.toLocal()}'.split(' ')[0],
                    ),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () => _pickDueDate(context),
                      child: Text('Select Due Date'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Questions Field
                Text('Questions:'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_questions[index]),
                    );
                  },
                ),
                TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(labelText: 'Add a Question'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_questionController.text.isNotEmpty) {
                      setState(() {
                        _questions.add(_questionController.text);
                        _questionController.clear();
                      });
                    }
                  },
                  child: Text('Add Question'),
                ),
                SizedBox(height: 20),
                // Student Names Field
                Text('Student Names:'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_students[index]),
                    );
                  },
                ),
                TextFormField(
                  controller: _studentController,
                  decoration: InputDecoration(labelText: 'Add a Student Name'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_studentController.text.isNotEmpty) {
                      setState(() {
                        _students.add(_studentController.text);
                        _studentController.clear();
                      });
                    }
                  },
                  child: Text('Add Student'),
                ),
                SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}