import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'assignment_form.dart';

class TeacherDashboard extends StatefulWidget {
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<DateTime, List<dynamic>> _events = {};
  DateTime _selectedDay = DateTime.now();
  List<dynamic> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  void _loadAssignments() async {
    // Fetch assignments from Firestore
    QuerySnapshot snapshot = await _firestore.collection('assignments').get();

    // Populate events with assignment data
    setState(() {
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime dueDate = (data['dueDate'] as Timestamp).toDate();
        _events[dueDate] = _events[dueDate] ?? [];
        _events[dueDate]!.add(data['title']);
      }
    });
  }

  void _showAssignmentDetails(List<dynamic> events) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assignment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: events.map((event) => Text(event.toString())).toList(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _createNewAssignment(DateTime selectedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentForm(
          initialDueDate: selectedDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime(2023),
            lastDay: DateTime(2100),
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              markersAlignment: Alignment.bottomCenter,
              markersMaxCount: 3,  // Limit number of visible markers
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _selectedEvents = _events[selectedDay] ?? [];
              });
              if (_selectedEvents.isNotEmpty) {
                _showAssignmentDetails(_selectedEvents);
              }
            },
          ),

          ElevatedButton(
            onPressed: () => _createNewAssignment(_selectedDay),
            child: Text('Create New Assignment'),
          ),
          Expanded(
            child: ListView(
              children: _selectedEvents.map((event) {
                return ListTile(
                  title: Text(event.toString()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}