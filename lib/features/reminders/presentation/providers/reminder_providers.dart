import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/reminders/data/repositories/reminder_repository.dart';
import 'package:annivet/features/reminders/domain/entities/reminder.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ReminderRepository(apiService);
});

// ============ QUERIES ============

final allRemindersProvider = FutureProvider<List<Reminder>>((ref) async {
  final repository = ref.watch(reminderRepositoryProvider);
  return repository.getAllReminders();
});

final upcomingRemindersProvider = FutureProvider<List<Reminder>>((ref) async {
  final repository = ref.watch(reminderRepositoryProvider);
  return repository.getUpcomingReminders();
});

final petRemindersProvider =
    FutureProvider.family<List<Reminder>, String>((ref, petId) async {
  final repository = ref.watch(reminderRepositoryProvider);
  return repository.getRemindersByPet(petId);
});

final reminderDetailProvider =
    FutureProvider.family<Reminder, String>((ref, reminderId) async {
  final repository = ref.watch(reminderRepositoryProvider);
  return repository.getReminderById(reminderId);
});

// ============ MUTATIONS ============

final createReminderProvider =
    FutureProvider.family<Reminder, Map<String, dynamic>>(
        (ref, variables) async {
  final repository = ref.watch(reminderRepositoryProvider);
  final newReminder = await repository.createReminder(variables);
  ref.invalidate(allRemindersProvider);
  final petId = variables['petId'];
  if (petId != null) {
    ref.invalidate(petRemindersProvider(petId as String));
  }
  return newReminder;
});

final markReminderSentProvider =
    FutureProvider.family<Reminder, String>((ref, reminderId) async {
  final repository = ref.watch(reminderRepositoryProvider);
  final updatedReminder = await repository.markAsSent(reminderId);
  ref.invalidate(allRemindersProvider);
  ref.invalidate(reminderDetailProvider(reminderId));
  return updatedReminder;
});

final deleteReminderProvider =
    FutureProvider.family<void, String>((ref, reminderId) async {
  final repository = ref.watch(reminderRepositoryProvider);
  await repository.deleteReminder(reminderId);
  ref.invalidate(allRemindersProvider);
});
