import '../../../../core/services/api_service.dart';
import '../dtos/reminder_dto.dart';
import '../../domain/entities/reminder.dart';

class ReminderRepository {
  final ApiService _apiService;

  ReminderRepository(this._apiService);

  // POST /api/reminders - Create reminder (admin)
  Future<Reminder> createReminder(Map<String, dynamic> data) async {
    final response = await _apiService.post('reminders', data: data);
    final dynamic respData = response.data;
    final Map<String, dynamic> reminderJson =
        (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
    return Reminder.fromDto(ReminderDto.fromJson(reminderJson));
  }

  // GET /api/reminders - All reminders (admin)
  Future<List<Reminder>> getAllReminders() async {
    final response = await _apiService.get('reminders');
    final dynamic data = response.data;
    final List<dynamic> remindersJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return remindersJson
        .map((json) => Reminder.fromDto(ReminderDto.fromJson(json)))
        .toList();
  }

  // GET /api/reminders/pet/:petId - Reminders by pet
  Future<List<Reminder>> getRemindersByPet(String petId) async {
    final response = await _apiService.get('reminders/pet/$petId');
    final dynamic data = response.data;
    final List<dynamic> remindersJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return remindersJson
        .map((json) => Reminder.fromDto(ReminderDto.fromJson(json)))
        .toList();
  }

  // GET /api/reminders/:id - Reminder by ID
  Future<Reminder> getReminderById(String reminderId) async {
    final response = await _apiService.get('reminders/$reminderId');
    final dynamic respData = response.data;
    final Map<String, dynamic> reminderJson =
        (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
    return Reminder.fromDto(ReminderDto.fromJson(reminderJson));
  }

  // PATCH /api/reminders/:id/sent - Mark as sent (admin)
  Future<Reminder> markAsSent(String reminderId) async {
    final response = await _apiService.patch('reminders/$reminderId/sent');
    final dynamic respData = response.data;
    final Map<String, dynamic> reminderJson =
        (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
    return Reminder.fromDto(ReminderDto.fromJson(reminderJson));
  }

  // DELETE /api/reminders/:id - Delete reminder (admin)
  Future<void> deleteReminder(String reminderId) async {
    await _apiService.delete('reminders/$reminderId');
  }

  // GET /api/reminders/upcoming - Upcoming reminders (admin/owner)
  Future<List<Reminder>> getUpcomingReminders({int days = 7}) async {
    final response = await _apiService.get(
      'reminders/upcoming',
      queryParameters: {'days': days.toString()},
    );
    final dynamic data = response.data;
    final List<dynamic> remindersJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return remindersJson
        .map((json) => Reminder.fromDto(ReminderDto.fromJson(json)))
        .toList();
  }
}
