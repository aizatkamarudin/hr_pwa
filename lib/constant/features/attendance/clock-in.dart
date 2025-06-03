import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ClockInOutScreen extends StatefulWidget {
  const ClockInOutScreen({super.key});

  @override
  State<ClockInOutScreen> createState() => _ClockInOutScreenState();
}

class _ClockInOutScreenState extends State<ClockInOutScreen> {
  // Attendance states
  bool _isClockedIn = false;
  DateTime? _clockInTime;
  DateTime? _clockOutTime;
  String _currentStatus = 'Ready to clock in';
  // Position? _currentPosition;
  File? _attendancePhoto;
  String _note = '';

  // Work session duration
  Duration _workDuration = Duration.zero;
  Timer? _durationTimer;

  @override
  void initState() {
    super.initState();
    _checkExistingAttendance();
    // _requestLocationPermission();
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkExistingAttendance() async {
    // Here you would check with your backend if user is already clocked in
    // For demo, we'll use a hardcoded value
    await Future.delayed(const Duration(seconds: 1));

    // Simulate checking with backend
    setState(() {
      _isClockedIn = false; // Change to true to simulate already clocked in
      if (_isClockedIn) {
        _clockInTime = DateTime.now().subtract(const Duration(hours: 2));
        _currentStatus = 'Clocked in at ${DateFormat('hh:mm a').format(_clockInTime!)}';
        _startDurationTimer();
      }
    });
  }

  // Future<void> _requestLocationPermission() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     setState(() {
  //       _currentStatus = 'Location services are disabled';
  //     });
  //     return;
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       setState(() {
  //         _currentStatus = 'Location permissions are denied';
  //       });
  //       return;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     setState(() {
  //       _currentStatus = 'Location permissions are permanently denied';
  //     });
  //     return;
  //   }

  //   _getCurrentLocation();
  // }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     setState(() {
  //       _currentPosition = position;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _currentStatus = 'Could not get location: ${e.toString()}';
  //     });
  //   }
  // }

  Future<void> _captureAttendancePhoto() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _attendancePhoto = File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _currentStatus = 'Failed to capture photo: ${e.message}';
      });
    }
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_clockInTime != null) {
        setState(() {
          _workDuration = DateTime.now().difference(_clockInTime!);
        });
      }
    });
  }

  Future<void> _handleClockInOut() async {
    if (!_isClockedIn) {
      // Clock in process
      // if (_currentPosition == null) {
      //   setState(() {
      //     _currentStatus = 'Waiting for location...';
      //   });
      //   await _getCurrentLocation();
      //   if (_currentPosition == null) return;
      // }

      await _captureAttendancePhoto();
      if (_attendancePhoto == null) return;

      setState(() {
        _clockInTime = DateTime.now();
        _isClockedIn = true;
        _currentStatus = 'Clocked in at ${DateFormat('hh:mm a').format(_clockInTime!)}';
        _startDurationTimer();
      });

      // Here you would send data to your backend
      final attendanceData = {
        'type': 'clock_in',
        'time': _clockInTime,
        // 'latitude': _currentPosition!.latitude,
        // 'longitude': _currentPosition!.longitude,
        'photo': _attendancePhoto?.path,
        'note': _note,
      };
      print('Clock In Data: $attendanceData');
    } else {
      // Clock out process
      setState(() {
        _clockOutTime = DateTime.now();
        _isClockedIn = false;
        _currentStatus = 'Clocked out at ${DateFormat('hh:mm a').format(_clockOutTime!)}';
        _durationTimer?.cancel();
      });

      // Here you would send data to your backend
      final attendanceData = {
        'type': 'clock_out',
        'time': _clockOutTime,
        // 'latitude': _currentPosition?.latitude,
        // 'longitude': _currentPosition?.longitude,
        'note': _note,
      };
      print('Clock Out Data: $attendanceData');

      // Show summary dialog
      _showAttendanceSummary();
    }
  }

  void _showAttendanceSummary() {
    final duration = _clockOutTime!.difference(_clockInTime!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attendance Recorded'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clock In: ${DateFormat('hh:mm a').format(_clockInTime!)}'),
            Text('Clock Out: ${DateFormat('hh:mm a').format(_clockOutTime!)}'),
            const SizedBox(height: 10),
            Text('Total Work: $hours hours $minutes minutes'),
            if (_note.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text('Note: $_note'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to attendance history
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.access_time, size: 50, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text(
                      _currentStatus,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_isClockedIn) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Duration: ${_workDuration.inHours}h ${_workDuration.inMinutes.remainder(60)}m',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Location Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // _currentPosition == null
                    //     ? const Text('Waiting for location...')
                    //     : Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text('Latitude: ${_currentPosition!.latitude.toStringAsFixed(4)}'),
                    //           Text('Longitude: ${_currentPosition!.longitude.toStringAsFixed(4)}'),
                    //           const SizedBox(height: 10),
                    //           OutlinedButton(
                    //             onPressed: _getCurrentLocation,
                    //             child: const Text('Refresh Location'),
                    //           ),
                    //         ],
                    //       ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Attendance Photo
            if (_attendancePhoto != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Attendance Photo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _attendancePhoto!,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: _captureAttendancePhoto,
                        child: const Text('Retake Photo'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Notes Field
            TextField(
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
                hintText: 'Add any notes about your attendance...',
              ),
              maxLines: 2,
              onChanged: (value) => _note = value,
            ),

            const SizedBox(height: 30),

            // Clock In/Out Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _handleClockInOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isClockedIn ? Colors.red : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isClockedIn ? 'CLOCK OUT' : 'CLOCK IN',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
