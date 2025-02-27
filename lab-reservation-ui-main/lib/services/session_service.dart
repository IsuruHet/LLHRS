import 'package:reserv/configs/apis.dart';
import 'package:reserv/helpers/sessions_prefs.dart';
import 'package:reserv/models/reschadule.dart';
import 'package:reserv/models/session.dart';
import 'package:reserv/services/api_service.dart';

class SessionService {
  final ApiService _apiService = ApiService.instance;

  Future<List<Session>> getTodaySessions() async {
    final token = await _apiService.getToken();

    final area = await SessionsPrefs.getinitialSessionPrefStatus();

    final tokenWithLetter = "$token${area.areaLetter}";
    try {
      final res = await _apiService.postRequest(kgetAllModulePath,
          data: {'tokenWithLetter': tokenWithLetter});

      if (res.data is List) {
        final sessions = (res.data as List).map((data) {
          if (data is Map<String, dynamic>) {
            return Session.fromJson(data);
          } else {
            throw Exception("Unexpected data format");
          }
        }).toList();
        return sessions;
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      throw Exception("Failed to load sessions: $e");
    }
  }

  Future<List<Session>> getSessionsByDate({required DateTime date}) async {
    final token = await _apiService.getToken();

    // 2024-08-12
    final day = "${date.year}-${date.month}-${date.day}";

    final area = await SessionsPrefs.getinitialSessionPrefStatus();
    final tokenWithLetter = "$token${area.areaLetter}";
    try {
      final res = await _apiService.postRequest(kgetAllModuleByDatePath,
          data: {'tokenWithLetter': tokenWithLetter, 'date': day});
      if (res.data is List) {
        final sessions = (res.data as List).map((data) {
          if (data is Map<String, dynamic>) {
            return Session.fromJson(data);
          } else {
            throw Exception("Unexpected data format");
          }
        }).toList();
        return sessions;
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      throw Exception("Failed to load sessions: $e");
    }
  }

  Future<List<Reschadule>> getAvailableSchedules({
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    required int capacity,
    required DateTime moduleType,
  }) async {
    final data = {
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'capacity': capacity,
      'moduleType': moduleType,
    };
    try {
      final res =
          await _apiService.postRequest(kRescheduleAvailable, data: data);
      if (res.data is List) {
        final sessions = (res.data as List).map((data) {
          if (data is Map<String, dynamic>) {
            return Reschadule.fromJson(data);
          } else {
            throw Exception("Unexpected data format");
          }
        }).toList();
        return sessions;
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      throw Exception("Failed to load sessions: $e");
    }
  }

  Future<List<Session>> getRescheduleSessions() async {
    final token = await _apiService.getToken();

    final area = await SessionsPrefs.getinitialSessionPrefStatus();

    final tokenWithLetter = "$token${area.areaLetter}";
    try {
      final res = await _apiService.postRequest(kgetRescheduleFilter,
          data: {'tokenWithLetter': tokenWithLetter});

      if (res.data is List) {
        final sessions = (res.data as List).map((data) {
          if (data is Map<String, dynamic>) {
            return Session.fromJson(data);
          } else {
            throw Exception("Unexpected data format");
          }
        }).toList();
        return sessions;
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to load sessions: $e");
    }
  }
}
