import 'package:flutter/material.dart';
import 'package:reserv/configs/apis.dart';
import 'package:reserv/models/available_slot.dart';
import 'package:reserv/models/session.dart';
import 'package:reserv/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecheduleRepository {
  final ApiService _apiService = ApiService.instance;

  Future<List<AvailableSlot>> getAvailableSlots({
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int capacity,
    required String moduleType,
  }) async {
    final Map<String, dynamic> data = {
      'date': "${date.year}-${date.month}-${date.day}",
      'startTime': "${startTime.hour}:${startTime.minute}",
      'endTime': "${endTime.hour}:${endTime.minute}",
      'capacity': capacity.toString(),
      'moduleType': moduleType
    };
    try {
      final res =
          await _apiService.postRequest(kRescheduleAvailable, data: data);

      // Check if response is a map and contains the expected key
      if (res.data is Map<String, dynamic> &&
          res.data.containsKey('available')) {
        final availableData = res.data['available'] as List<dynamic>;
        final slots = availableData.map((item) {
          if (item is Map<String, dynamic>) {
            return AvailableSlot.fromJson(item);
          } else {
            throw Exception("Unexpected data format");
          }
        }).toList();
        return slots;
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to load available slots: $e");
    }
  }

  Future<void> rescheduleModule(
      {required DateTime date,
      required TimeOfDay startTime,
      required TimeOfDay endTime,
      required int capacity,
      required Session session,
      required String hlName}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final Map<String, dynamic> data = {
      'date': "${date.year}-${date.month}-${date.day}",
      'startTime': "${startTime.hour}:${startTime.minute}",
      'endTime': "${endTime.hour}:${endTime.minute}",
      'capacity': capacity.toString(),
      'moduleType': session.moduleType,
      'hlName': hlName,
      'moduleCode': session.moduleCode,
      'token': token
    };
    try {
      final res = await _apiService.postRequest(kReschedule, data: data);
      print(res);
    } catch (e) {
      print(e);
      throw Exception("Failed to load available slots: $e");
    }
  }
}
