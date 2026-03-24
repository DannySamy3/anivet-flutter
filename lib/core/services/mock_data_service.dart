import 'package:annivet/core/models/billing_breakdown.dart';
import 'package:annivet/features/pet/data/models/pet_dto.dart';
import 'package:annivet/features/boarding/data/dtos/boarding_dto.dart';

/// Mock data service for development and testing
/// Provides dummy data matching the backend structure
class MockDataService {
  static const String _customerId = 'customer-uuid-001';
  static const String _clinicId = 'clinic-uuid-001';

  /// Get mock pets list
  static List<PetDto> getMockPets() {
    return [
      PetDto(
        id: 'pet-uuid-001',
        name: 'Simba',
        species: 'dog',
        breed: 'German Shepherd',
        age: 3,
        ownerId: _customerId,
        photoUrl:
            'https://images.unsplash.com/photo-1633722715463-d30f4f325e24?w=400&h=300&fit=crop',
        createdAt:
            DateTime.now().subtract(Duration(days: 180)).toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
      PetDto(
        id: 'pet-uuid-002',
        name: 'Bella',
        species: 'dog',
        breed: 'Golden Retriever',
        age: 2,
        ownerId: _customerId,
        photoUrl:
            'https://images.unsplash.com/photo-1633722715463-d30f4f325e24?w=400&h=300&fit=crop',
        createdAt:
            DateTime.now().subtract(Duration(days: 120)).toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
      PetDto(
        id: 'pet-uuid-003',
        name: 'Whiskers',
        species: 'cat',
        breed: 'Persian',
        age: 4,
        ownerId: _customerId,
        photoUrl:
            'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400&h=300&fit=crop',
        createdAt:
            DateTime.now().subtract(Duration(days: 90)).toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
      PetDto(
        id: 'pet-uuid-004',
        name: 'Max',
        species: 'dog',
        breed: 'Labrador Retriever',
        age: 5,
        ownerId: _customerId,
        photoUrl:
            'https://images.unsplash.com/photo-1633722715463-d30f4f325e24?w=400&h=300&fit=crop',
        createdAt:
            DateTime.now().subtract(Duration(days: 200)).toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    ];
  }

  /// Get mock pet detail by ID
  static PetDto? getMockPetDetail(String petId) {
    final pets = getMockPets();
    try {
      return pets.firstWhere((pet) => pet.id == petId);
    } catch (e) {
      return null;
    }
  }

  /// Get mock boardings list
  static List<BoardingDto> getMockBoardings() {
    final now = DateTime.now();
    return [
      BoardingDto(
        id: 'boarding-uuid-001',
        petId: 'pet-uuid-001',
        customerId: _customerId,
        checkIn: now.subtract(Duration(days: 5)),
        checkOut: now.add(Duration(days: 2)),
        numberOfDays: 7,
        status: 'ACTIVE',
        dailyRate: 25000.0,
        medicationAdminDays: 2,
        medicationAdminFee: 5000.0,
        groomingRequired: true,
        groomingFee: 30000.0,
        pickupDropoffRequired: true,
        pickupDropoffFee: 20000.0,
        totalAmount: 225000.0,
        paidAmount: 150000.0,
        specialInstructions:
            'Feed twice a day. Give medication every 12 hours.',
        billingBreakdown: BillingBreakdown(
          dailyCharge: DailyCharge(
            days: 7,
            dailyRate: 25000.0,
            subtotal: 175000.0,
          ),
          medicationAdmin: MedicationAdmin(
            days: 2,
            dailyFee: 5000.0,
            subtotal: 10000.0,
          ),
          grooming: Grooming(fee: 30000.0),
          pickupDropoff: PickupDropoff(fee: 20000.0),
          total: 235000.0,
          currency: 'IDR',
        ),
        createdAt: now.subtract(Duration(days: 6)),
        updatedAt: now.subtract(Duration(hours: 2)),
      ),
      BoardingDto(
        id: 'boarding-uuid-002',
        petId: 'pet-uuid-002',
        customerId: _customerId,
        checkIn: now.add(Duration(days: 10)),
        checkOut: now.add(Duration(days: 15)),
        numberOfDays: 5,
        status: 'REQUESTED',
        dailyRate: 25000.0,
        medicationAdminDays: 0,
        medicationAdminFee: 0.0,
        groomingRequired: false,
        groomingFee: 0.0,
        pickupDropoffRequired: true,
        pickupDropoffFee: 20000.0,
        totalAmount: 145000.0,
        paidAmount: 0.0,
        specialInstructions: 'Just regular boarding. No special care needed.',
        billingBreakdown: BillingBreakdown(
          dailyCharge: DailyCharge(
            days: 5,
            dailyRate: 25000.0,
            subtotal: 125000.0,
          ),
          medicationAdmin: null,
          grooming: null,
          pickupDropoff: PickupDropoff(fee: 20000.0),
          total: 145000.0,
          currency: 'IDR',
        ),
        createdAt: now.subtract(Duration(days: 2)),
        updatedAt: now.subtract(Duration(days: 1)),
      ),
      BoardingDto(
        id: 'boarding-uuid-003',
        petId: 'pet-uuid-003',
        customerId: _customerId,
        checkIn: now.subtract(Duration(days: 15)),
        checkOut: now.subtract(Duration(days: 10)),
        numberOfDays: 5,
        status: 'COMPLETED',
        dailyRate: 20000.0,
        medicationAdminDays: 0,
        medicationAdminFee: 0.0,
        groomingRequired: true,
        groomingFee: 25000.0,
        pickupDropoffRequired: false,
        pickupDropoffFee: 0.0,
        totalAmount: 125000.0,
        paidAmount: 125000.0,
        specialInstructions:
            'Whiskers is picky with food. Use premium cat food.',
        billingBreakdown: BillingBreakdown(
          dailyCharge: DailyCharge(
            days: 5,
            dailyRate: 20000.0,
            subtotal: 100000.0,
          ),
          medicationAdmin: null,
          grooming: Grooming(fee: 25000.0),
          pickupDropoff: null,
          total: 125000.0,
          currency: 'IDR',
        ),
        createdAt: now.subtract(Duration(days: 20)),
        updatedAt: now.subtract(Duration(days: 9)),
      ),
      BoardingDto(
        id: 'boarding-uuid-004',
        petId: 'pet-uuid-004',
        customerId: _customerId,
        checkIn: now.add(Duration(days: 30)),
        checkOut: now.add(Duration(days: 35)),
        numberOfDays: 5,
        status: 'APPROVED',
        dailyRate: 28000.0,
        medicationAdminDays: 5,
        medicationAdminFee: 5000.0,
        groomingRequired: true,
        groomingFee: 35000.0,
        pickupDropoffRequired: true,
        pickupDropoffFee: 20000.0,
        totalAmount: 215000.0,
        paidAmount: 50000.0,
        specialInstructions:
            'Max needs daily medication for his arthritis. Three times per day.',
        billingBreakdown: BillingBreakdown(
          dailyCharge: DailyCharge(
            days: 5,
            dailyRate: 28000.0,
            subtotal: 140000.0,
          ),
          medicationAdmin: MedicationAdmin(
            days: 5,
            dailyFee: 5000.0,
            subtotal: 25000.0,
          ),
          grooming: Grooming(fee: 35000.0),
          pickupDropoff: PickupDropoff(fee: 20000.0),
          total: 220000.0,
          currency: 'IDR',
        ),
        createdAt: now.subtract(Duration(days: 5)),
        updatedAt: now.subtract(Duration(hours: 12)),
      ),
    ];
  }

  /// Get mock boarding detail by ID
  static BoardingDto? getMockBoardingDetail(String boardingId) {
    final boardings = getMockBoardings();
    try {
      return boardings.firstWhere((boarding) => boarding.id == boardingId);
    } catch (e) {
      return null;
    }
  }

  /// Get mock store products
  static List<Map<String, dynamic>> getMockStoreProducts() {
    return [
      {
        'id': 'product-uuid-001',
        'clinicId': _clinicId,
        'name': 'Rabies Vaccine 1ml',
        'description': 'Single dose rabies vaccination for dogs and cats',
        'price': 35000.0,
        'stock': 10,
        'lowStockThreshold': 5,
        'photoUrl':
            'https://images.unsplash.com/photo-1631217216431-cf80564a3e5b?w=500&h=400&fit=crop',
        'category': 'Vaccines',
        'createdAt':
            DateTime.now().subtract(Duration(days: 90)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product-uuid-002',
        'clinicId': _clinicId,
        'name': 'DHPP Vaccine Bundle',
        'description':
            'Combined vaccination for distemper, hepatitis, parvo, and parainfluenza',
        'price': 55000.0,
        'stock': 15,
        'lowStockThreshold': 5,
        'photoUrl':
            'https://images.unsplash.com/photo-1584966990007-11e25f97f46e?w=500&h=400&fit=crop',
        'category': 'Vaccines',
        'createdAt':
            DateTime.now().subtract(Duration(days: 75)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product-uuid-003',
        'clinicId': _clinicId,
        'name': 'Flea & Tick Prevention',
        'description': 'Monthly topical flea and tick prevention for dogs',
        'price': 45000.0,
        'stock': 22,
        'lowStockThreshold': 10,
        'photoUrl':
            'https://images.unsplash.com/photo-1601758228578-a1e89af92d26?w=500&h=400&fit=crop',
        'category': 'Preventive',
        'createdAt':
            DateTime.now().subtract(Duration(days: 60)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product-uuid-004',
        'clinicId': _clinicId,
        'name': 'Antibiotic Tablets - Amoxicillin 250mg',
        'description': 'Broad-spectrum antibiotic for bacterial infections',
        'price': 25000.0,
        'stock': 3,
        'lowStockThreshold': 5,
        'photoUrl':
            'https://images.unsplash.com/photo-1587854692152-cbe660dbde0b?w=500&h=400&fit=crop',
        'category': 'Medications',
        'createdAt':
            DateTime.now().subtract(Duration(days: 45)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product-uuid-005',
        'clinicId': _clinicId,
        'name': 'Premium Dog Food 10kg',
        'description': 'High-quality balanced diet for adult dogs',
        'price': 280000.0,
        'stock': 8,
        'lowStockThreshold': 3,
        'photoUrl':
            'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=500&h=400&fit=crop',
        'category': 'Nutrition',
        'createdAt':
            DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product-uuid-006',
        'clinicId': _clinicId,
        'name': 'Premium Cat Food 5kg',
        'description': 'Nutritionally balanced diet formulated for cats',
        'price': 180000.0,
        'stock': 12,
        'lowStockThreshold': 5,
        'photoUrl':
            'https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?w=500&h=400&fit=crop',
        'category': 'Nutrition',
        'createdAt':
            DateTime.now().subtract(Duration(days: 25)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product-uuid-007',
        'clinicId': _clinicId,
        'name': 'Dental Chews for Dogs',
        'description': 'Dental health support, helps reduce tartar buildup',
        'price': 65000.0,
        'stock': 18,
        'lowStockThreshold': 8,
        'photoUrl':
            'https://images.unsplash.com/photo-1585515320310-39c02521eaea?w=500&h=400&fit=crop',
        'category': 'Accessories',
        'createdAt':
            DateTime.now().subtract(Duration(days: 20)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'product-uuid-008',
        'clinicId': _clinicId,
        'name': 'Anti-Inflammatory Medication',
        'description': 'Relief for pain and inflammation in pets',
        'price': 50000.0,
        'stock': 7,
        'lowStockThreshold': 5,
        'photoUrl':
            'https://images.unsplash.com/photo-1631217216428-c8782e14261b?w=500&h=400&fit=crop',
        'category': 'Medications',
        'createdAt':
            DateTime.now().subtract(Duration(days: 15)).toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    ];
  }

  /// Get mock product detail by ID
  static Map<String, dynamic>? getMockProductDetail(String productId) {
    final products = getMockStoreProducts();
    try {
      return products.firstWhere((product) => product['id'] == productId);
    } catch (e) {
      return null;
    }
  }

  /// Get mock boarding logs for activity tracking
  static List<Map<String, dynamic>> getMockBoardingLogs(String boardingId) {
    final now = DateTime.now();
    return [
      {
        'id': 'log-uuid-001',
        'boardingId': boardingId,
        'timestamp': now.subtract(Duration(hours: 24)).toIso8601String(),
        'action': 'CHECK_IN',
        'staffName': 'Dr. Sarah',
        'notes': 'Pet checked in successfully. Appears healthy and calm.',
      },
      {
        'id': 'log-uuid-002',
        'boardingId': boardingId,
        'timestamp': now.subtract(Duration(hours: 20)).toIso8601String(),
        'action': 'FEEDING',
        'staffName': 'John',
        'notes': 'First meal given. Pet ate well.',
      },
      {
        'id': 'log-uuid-003',
        'boardingId': boardingId,
        'timestamp': now.subtract(Duration(hours: 16)).toIso8601String(),
        'action': 'PLAY_TIME',
        'staffName': 'Maria',
        'notes': 'Enjoyed 30 minutes of play in exercise area.',
      },
      {
        'id': 'log-uuid-004',
        'boardingId': boardingId,
        'timestamp': now.subtract(Duration(hours: 12)).toIso8601String(),
        'action': 'MEDICATION',
        'staffName': 'Dr. Sarah',
        'notes': 'Medication administered as scheduled.',
      },
      {
        'id': 'log-uuid-005',
        'boardingId': boardingId,
        'timestamp': now.subtract(Duration(hours: 8)).toIso8601String(),
        'action': 'GROOMING',
        'staffName': 'Lisa',
        'notes': 'Full grooming session completed. Pet looks great!',
      },
    ];
  }

  /// Get mock boarding logs (as DTOs)
  static List<BoardingLogDto> getMockBoardingLogDtos(String boardingId) {
    final now = DateTime.now();
    return [
      BoardingLogDto(
        id: 'log-uuid-001',
        boardingId: boardingId,
        date: now.subtract(Duration(hours: 24)),
        notes: 'Pet checked in successfully. Appears healthy and calm.',
      ),
      BoardingLogDto(
        id: 'log-uuid-002',
        boardingId: boardingId,
        date: now.subtract(Duration(hours: 20)),
        notes: 'First meal given. Pet ate well and drank water.',
      ),
      BoardingLogDto(
        id: 'log-uuid-003',
        boardingId: boardingId,
        date: now.subtract(Duration(hours: 16)),
        notes: 'Enjoyed 30 minutes of play in exercise area.',
      ),
      BoardingLogDto(
        id: 'log-uuid-004',
        boardingId: boardingId,
        date: now.subtract(Duration(hours: 12)),
        notes: 'Medication administered as scheduled (3PM).',
      ),
      BoardingLogDto(
        id: 'log-uuid-005',
        boardingId: boardingId,
        date: now.subtract(Duration(hours: 8)),
        notes: 'Full grooming session completed. Pet looks great!',
      ),
    ];
  }

  /// Get mock billing information for a boarding
  static Map<String, dynamic> getMockBillingInfo(String boardingId) {
    final boarding = getMockBoardingDetail(boardingId);
    if (boarding == null) {
      return {};
    }

    return {
      'boardingId': boardingId,
      'petName': 'Simba',
      'owner': 'John Doe',
      'email': 'john@example.com',
      'phone': '+62-812-3456-7890',
      'checkIn': boarding.checkIn.toIso8601String(),
      'checkOut': boarding.checkOut?.toIso8601String() ?? '',
      'numberOfDays': boarding.numberOfDays,
      'dailyRate': boarding.dailyRate,
      'subtotalDaily': boarding.dailyRate * boarding.numberOfDays,
      'medicationAdminDays': boarding.medicationAdminDays,
      'medicationAdminFee': boarding.medicationAdminFee,
      'subtotalMedication':
          boarding.medicationAdminFee * boarding.medicationAdminDays,
      'groomingRequired': boarding.groomingRequired,
      'groomingFee': boarding.groomingFee,
      'pickupDropoffRequired': boarding.pickupDropoffRequired,
      'pickupDropoffFee': boarding.pickupDropoffFee,
      'subtotal': boarding.totalAmount,
      'tax': (boarding.totalAmount * 0.1).toStringAsFixed(2),
      'total': boarding.totalAmount,
      'paid': boarding.paidAmount,
      'balance':
          (boarding.totalAmount - boarding.paidAmount).toStringAsFixed(2),
      'paymentMethod': 'Bank Transfer',
      'invoiceNumber': 'INV-2025-${boardingId.split('-')[0].toUpperCase()}',
      'currency': 'IDR',
    };
  }
}
