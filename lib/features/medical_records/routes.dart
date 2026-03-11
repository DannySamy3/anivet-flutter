import 'package:go_router/go_router.dart';
import 'presentation/screens/medical_records_screen.dart';
import 'presentation/screens/medical_record_form_screen.dart';
import 'presentation/screens/medical_record_detail_screen.dart';

final medicalRecordRoutes = [
  GoRoute(
    path: '/medical-records',
    builder: (context, state) {
      final petId = state.uri.queryParameters['petId'] ?? '';
      return MedicalRecordsScreen(petId: petId);
    },
  ),
  GoRoute(
    path: '/medical-records/create',
    builder: (context, state) {
      final petId = state.uri.queryParameters['petId'] ?? '';
      return MedicalRecordFormScreen(petId: petId);
    },
  ),
  GoRoute(
    path: '/medical-records/:id',
    builder: (context, state) {
      final recordId = state.pathParameters['id']!;
      final petId = state.uri.queryParameters['petId'];
      return MedicalRecordDetailScreen(
        recordId: recordId,
        petId: petId,
      );
    },
  ),
  GoRoute(
    path: '/medical-records/edit/:id',
    builder: (context, state) {
      final recordId = state.pathParameters['id']!;
      final petId = state.extra as String?;
      return MedicalRecordFormScreen(
        petId: petId ?? '',
        recordId: recordId,
      );
    },
  ),
];
