import '../../../../core/services/api_service.dart';
import '../dtos/reminder_dto.dart';
import '../../domain/entities/reminder.dart';

class ReminderRepository {
  final ApiService _apiService;

  ReminderRepository(this._apiService);

  // POST /api/reminders - Create reminder (admin)
  Future<Reminder> createReminder(Map<String, dynamic> data) async {
    final response = await _apiService.post('/reminders', data: data);
    return Reminder.fromDto(ReminderDto.fromJson(response.data));
  }

  // GET /api/reminders - All reminders (admin)
  Future<List<Reminder>> getAllReminders() async {
    final response = await _apiService.get('/reminders');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Reminder.fromDto(ReminderDto.fromJson(json)))
        .toList();
  }

  // GET /api/reminders/pet/:petId - Reminders by pet
  Future<List<Reminder>> getRemindersByPet(String petId) async {
    final response = await _apiService.get('/reminders/pet/$petId');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Reminder.fromDto(ReminderDto.fromJson(json)))
        .toList();
  }

  // GET /api/reminders/:id - Reminder by ID
  Future<Reminder> getReminderById(String reminderId) async {
    final response = await _apiService.get('/reminders/$reminderId');
    return Reminder.fromDto(ReminderDto.fromJson(response.data));
  }

  // PATCH /api/reminders/:id/sent - Mark as sent (admin)
  Future<Reminder> markAsSent(String reminderId) async {
    final response = await _apiService.patch('/reminders/$reminderId/sent');
    return Reminder.fromDto(ReminderDto.fromJson(response.data));
  }

  // DELETE /api/reminders/:id - Delete reminder (admin)
  Future<void> deleteReminder(String reminderId) async {
    await _apiService.delete('/reminders/$reminderId');
  }
}
