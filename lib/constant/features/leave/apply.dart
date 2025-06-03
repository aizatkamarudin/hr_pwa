import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({super.key});

  @override
  State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String _leaveType = 'Annual';
  DateTime? _startDate;
  DateTime? _endDate;
  String _reason = '';
  bool _isHalfDay = false;
  String _halfDayPeriod = 'First Half';

  // Available leave types
  final List<String> _leaveTypes = ['Annual', 'Sick', 'Maternity', 'Paternity', 'Unpaid', 'Compensatory'];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Set end date same as start date by default
          if (_endDate == null || _endDate!.isBefore(picked)) {
            _endDate = picked;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitLeaveApplication() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Here you would typically send the data to your backend
      final leaveData = {
        'leaveType': _leaveType,
        'startDate': _startDate,
        'endDate': _endDate,
        'reason': _reason,
        'isHalfDay': _isHalfDay,
        'halfDayPeriod': _halfDayPeriod,
      };

      print('Leave Application Submitted: $leaveData');

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Your leave application has been submitted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Leave'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leave Type Dropdown
              DropdownButtonFormField<String>(
                value: _leaveType,
                decoration: const InputDecoration(
                  labelText: 'Leave Type',
                  border: OutlineInputBorder(),
                ),
                items: _leaveTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _leaveType = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a leave type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Date Selection
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _startDate == null ? 'Select date' : DateFormat('dd MMM yyyy').format(_startDate!),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_endDate == null ? 'Select date' : DateFormat('dd MMM yyyy').format(_endDate!)),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Half Day Checkbox
              CheckboxListTile(
                title: const Text('Half Day Leave'),
                value: _isHalfDay,
                onChanged: (bool? value) {
                  setState(() {
                    _isHalfDay = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              // Half Day Period (visible only if half day is selected)
              if (_isHalfDay) ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _halfDayPeriod,
                  decoration: const InputDecoration(
                    labelText: 'Half Day Period',
                    border: OutlineInputBorder(),
                  ),
                  items: ['First Half', 'Second Half'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _halfDayPeriod = newValue!;
                    });
                  },
                ),
              ],

              const SizedBox(height: 20),

              // Reason for Leave
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Reason for Leave',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the reason for your leave',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
                onSaved: (value) => _reason = value!,
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitLeaveApplication,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Submit Leave Application',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
