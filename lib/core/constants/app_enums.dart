enum UserRole { customer, owner }

enum PetSpecies { dog, cat, bird, rabbit, other }

enum HistoryType { vaccination, checkup, treatment, surgery, other }

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

enum BoardingStatus { pending, approved, active, completed, cancelled }

// Extension methods for UserRole
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'Customer';
      case UserRole.owner:
        return 'Owner/Staff';
    }
  }

  String get value {
    switch (this) {
      case UserRole.customer:
        return 'CUSTOMER';
      case UserRole.owner:
        return 'OWNER';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toUpperCase()) {
      case 'CUSTOMER':
        return UserRole.customer;
      case 'OWNER':
      case 'STAFF':
        return UserRole.owner;
      default:
        return UserRole.customer;
    }
  }
}

// Extension methods for PetSpecies
extension PetSpeciesExtension on PetSpecies {
  String get displayName {
    switch (this) {
      case PetSpecies.dog:
        return 'Dog';
      case PetSpecies.cat:
        return 'Cat';
      case PetSpecies.bird:
        return 'Bird';
      case PetSpecies.rabbit:
        return 'Rabbit';
      case PetSpecies.other:
        return 'Other';
    }
  }

  String get value {
    return displayName.toUpperCase();
  }

  static PetSpecies fromString(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
        return PetSpecies.dog;
      case 'cat':
        return PetSpecies.cat;
      case 'bird':
        return PetSpecies.bird;
      case 'rabbit':
        return PetSpecies.rabbit;
      default:
        return PetSpecies.other;
    }
  }
}

// Extension methods for BoardingStatus
extension BoardingStatusExtension on BoardingStatus {
  String get displayName {
    switch (this) {
      case BoardingStatus.pending:
        return 'Pending';
      case BoardingStatus.approved:
        return 'Approved';
      case BoardingStatus.active:
        return 'Active';
      case BoardingStatus.completed:
        return 'Completed';
      case BoardingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get value {
    return displayName.toUpperCase();
  }

  static BoardingStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return BoardingStatus.pending;
      case 'approved':
        return BoardingStatus.approved;
      case 'active':
        return BoardingStatus.active;
      case 'completed':
        return BoardingStatus.completed;
      case 'cancelled':
        return BoardingStatus.cancelled;
      default:
        return BoardingStatus.pending;
    }
  }
}

// Extension methods for OrderStatus
extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get value {
    return displayName.toUpperCase();
  }

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
