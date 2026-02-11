# ANNIVET - Veterinary Clinic Mobile App

A Flutter mobile application for the ANNIVET veterinary clinic, providing comprehensive pet care management for pet owners and clinic staff.

## Features

### For Pet Owners (Customers)
- 🐾 **Pet Management**: Add and manage your pets with photos, medical history, and reminders
- 🛒 **Online Store**: Browse and purchase pet products
- 📰 **Clinic Feed**: Stay updated with clinic announcements and news
- 🏨 **Boarding Requests**: Request and track pet boarding with daily updates
- ⚙️ **Settings**: Manage profile, notifications, and preferences

### For Clinic Staff/Owners
- 👥 **User Management**: View all registered users and their pets
- 📝 **Medical Records**: Add medical history, vaccinations, and treatment records
- 📦 **Product Management**: Add/edit products in the store
- 📋 **Order Management**: Process and fulfill customer orders
- 📢 **Announcements**: Create and manage clinic feed posts
- 🏨 **Boarding Management**: Approve requests and add daily care logs

## Tech Stack

- **Framework**: Flutter 3.19+ (Dart 3.3+)
- **State Management**: Riverpod 2.x
- **Routing**: GoRouter (role-based guards)
- **Networking**: Dio (with JWT interceptors)
- **API Integration**: fl_query (Tanstack Query for Flutter)
- **Storage**: flutter_secure_storage (JWT tokens)
- **UI**: Material 3 with custom veterinary theme
- **Responsive**: flutter_screenutil
- **Notifications**: flutter_local_notifications
- **Internationalization**: English + Swahili support

## Prerequisites

- Flutter SDK 3.19.0 or higher
- Dart SDK 3.3.0 or higher
- Android Studio / Xcode (for mobile development)
- Backend API running (Express + TypeScript + Prisma)

## Getting Started

### 1. Clone the Repository

```bash
cd /Users/beginnertech/Documents/Code/Project/anivet/frontend
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure API Base URL

Edit `lib/core/constants/app_constants.dart` and update the API base URL:

```dart
static const String apiBaseUrl = 'http://your-backend-url:3000/api/v1';
```

For local development:
- **Android emulator**: `http://10.0.2.2:3000/api/v1`
- **iOS simulator**: `http://localhost:3000/api/v1`
- **Physical device**: `http://<your-computer-ip>:3000/api/v1`

### 4. Create Assets Folders

```bash
mkdir -p assets/images assets/icons
```

### 5. Run the App

```bash
# Check for issues
flutter analyze

# Run on connected device/emulator
flutter run

# Run in release mode
flutter run --release
```

## Project Structure

```
lib/
├── core/                          # Shared utilities & infrastructure
│   ├── constants/                 # App-wide constants
│   │   ├── app_colors.dart
│   │   ├── app_constants.dart
│   │   ├── app_enums.dart
│   │   └── app_strings.dart
│   ├── services/                  # Core services
│   │   ├── api_service.dart       # Dio HTTP client
│   │   ├── storage_service.dart   # Secure storage wrapper
│   │   └── notification_service.dart
│   ├── theme/                     # Material 3 theming
│   │   └── app_theme.dart
│   ├── widgets/                   # Reusable widgets
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   ├── loading_indicator.dart
│   │   ├── app_error_widget.dart
│   │   └── shimmer_loading.dart
│   └── app.dart                   # Main app widget & router
├── features/                      # Feature-based modules
│   ├── auth/                      # Authentication
│   │   ├── data/                  # DTOs, repositories
│   │   ├── domain/                # Entities
│   │   └── presentation/          # Screens, widgets, providers
│   ├── pet/                       # Pet management
│   ├── store/                     # Products & orders
│   ├── feed/                      # Clinic announcements
│   ├── boarding/                  # Boarding requests
│   └── settings/                  # User settings
└── main.dart                      # Entry point
```

## Development

### Code Generation

If using code generation (e.g., for Riverpod or JSON serialization):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting

The project uses strict linting rules defined in `analysis_options.yaml`:

```bash
flutter analyze
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build iOS app
flutter build ios --release
```

## API Endpoints Expected

The app expects the following REST API endpoints:

- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/register` - User registration
- `GET /api/v1/auth/me` - Get current user
- `GET /api/v1/pets` - Get all pets
- `POST /api/v1/pets` - Create pet
- `GET /api/v1/pets/:id` - Get pet by ID
- `PUT /api/v1/pets/:id` - Update pet
- `DELETE /api/v1/pets/:id` - Delete pet
- `POST /api/v1/pets/:id/photo` - Upload pet photo
- (Additional endpoints for store, feed, boarding...)

## Environment Variables

For production, use `--dart-define` to pass environment variables:

```bash
flutter run --dart-define=API_BASE_URL=https://api.annivet.com/api/v1
```

## Troubleshooting

### Common Issues

1. **"Target of URI doesn't exist"**: Run `flutter pub get`
2. **API connection fails**: Verify backend is running and base URL is correct
3. **Build errors**: Run `flutter clean && flutter pub get`

### Android Specific

If you encounter network issues on Android, add to `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:usesCleartextTraffic="true">
```

## Contributing

1. Follow the established folder structure (feature-based)
2. Use the defined constants (no magic strings)
3. Implement proper error handling
4. Write unit tests for repositories and business logic
5. Follow the linting rules

## License

Proprietary - ANNIVET Veterinary Clinic

## Support

For issues or questions, contact the development team.
