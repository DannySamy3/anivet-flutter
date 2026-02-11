import 'package:go_router/go_router.dart';
import 'presentation/screens/pet_list_screen.dart';
import 'presentation/screens/pet_detail_screen.dart';
import 'presentation/screens/add_edit_pet_screen.dart';
import 'presentation/screens/admin_pets_screen.dart';

final petRoutes = [
  GoRoute(
    path: '/pets',
    builder: (context, state) => const PetListScreen(),
  ),
  GoRoute(
    path: '/pets/add',
    builder: (context, state) => const AddEditPetScreen(),
  ),
  GoRoute(
    path: '/pets/:id',
    builder: (context, state) {
      final petId = state.pathParameters['id']!;
      return PetDetailScreen(petId: petId);
    },
  ),
  GoRoute(
    path: '/pets/:id/edit',
    builder: (context, state) {
      final petId = state.pathParameters['id']!;
      return AddEditPetScreen(petId: petId);
    },
  ),
  GoRoute(
    path: '/admin/pets',
    builder: (context, state) => const AdminPetsScreen(),
  ),
];
