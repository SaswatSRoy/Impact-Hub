# ImpactHub 🌍

A community-driven mobile application built with Flutter that connects volunteers with meaningful events and communities to create positive social impact.

## Overview

ImpactHub is a volunteer management platform designed to make it easy for individuals to discover, join, and participate in community events and volunteer organizations. Whether you're passionate about environmental cleanup, education, health initiatives, or social causes, ImpactHub helps you find opportunities to make a real difference.

### Key Features

- **User Authentication**: Secure login/registration with JWT token management
- **Event Discovery**: Browse and explore upcoming volunteer events
- **Community Engagement**: Join communities with shared social impact goals
- **Impact Tracking**: Monitor your volunteer contributions, points earned, and impact metrics
- **User Dashboard**: Personalized dashboard showing your activities and statistics
- **Event Management**: Join events, track participation, and view event details
- **Secure Storage**: OAuth2 token management with secure local storage

## Tech Stack

### Frontend
- **Flutter 3.x** - Cross-platform mobile development
- **Dart** - Programming language
- **Riverpod** - State management solution
- **Freezed** - Immutable data classes and JSON serialization
- **Dio** - HTTP client for API communication
- **Flutter Secure Storage** - Secure local token storage
- **Google Fonts** - Custom typography

### Architecture
- **MVVM Pattern**: Models, Views, and ViewModels for clean separation of concerns
- **Repository Pattern**: Data access layer abstraction
- **Providers**: Riverpod for efficient state and dependency management
- **Service Layer**: Low-level HTTP communication layer

## Project Structure

```
lib/
├── constants/
│   └── api.dart                          # API configuration
├── features/
│   ├── auth/
│   │   ├── controllers/
│   │   │   └── auth_notifier.dart        # Authentication state management
│   │   ├── models/
│   │   │   ├── app_user.dart
│   │   │   └── auth_response.dart
│   │   ├── repository/
│   │   │   └── auth_repository.dart      # Authentication data layer
│   │   ├── services/
│   │   │   └── auth_service.dart         # Low-level API calls
│   │   ├── ui/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── forgot_password_screen.dart
│   │   ├── auth_validators.dart          # Form validation
│   │   └── providers.dart                # Riverpod providers
│   ├── dashboard/
│   │   ├── controllers/
│   │   │   ├── dashboard_controller.dart
│   │   │   └── dashboard_provider.dart
│   │   ├── data/
│   │   │   └── dashboard_repository.dart
│   │   └── ui/
│   │       └── dashboard_screen.dart
│   ├── home/
│   │   ├── controllers/
│   │   │   └── home_provider.dart
│   │   ├── data/
│   │   │   └── home_repository.dart
│   │   └── ui/
│   │       ├── home_screen.dart
│   │       ├── event_details_screen.dart
│   │       └── communities_screen.dart
│   └── shared/
│       └── shared_models.dart            # Common data models
├── widgets/
│   ├── primary_button.dart
│   ├── profile_header.dart
│   ├── impact_summary.dart
│   ├── upcoming_events.dart
│   ├── event_preview.dart
│   ├── quick_actions.dart
│   └── [other reusable widgets]
├── main.dart                             # App entry point
└── [configuration files]
```

## Installation & Setup

### Prerequisites
- Flutter SDK (3.x or higher)
- Dart SDK
- Android Studio or Xcode
- Git

### Clone Repository

```bash
git clone https://github.com/yourusername/impact-hub.git
cd impact-hub
```

### Install Dependencies

```bash
flutter pub get
```

### Generate Build Files

```bash
# Generate Freezed classes and JSON serialization
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch mode for development
flutter pub run build_runner watch
```

### Run the App

```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

## Configuration

### API Base URL

Update the API endpoint in `lib/constants/api.dart`:

```dart
const String API_URL = "https://your-backend-url.com";
```

### Backend Requirements

The backend should provide these endpoints:

#### Authentication
- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `GET /auth/me` - Get current user
- `POST /auth/logout` - Logout user

#### Events
- `GET /events` - Fetch all events (supports `limit` query param)
- `POST /events/{id}/join` - Join an event

#### Communities
- `GET /communities` - Fetch all communities (supports `limit` query param)
- `POST /communities/{id}/join` - Join a community

#### User Metrics
- `GET /users/{userId}/impact` - Fetch user impact statistics

## Authentication Flow

1. **Registration**: User signs up with email, password, and optional location
2. **Login**: User logs in with credentials
3. **Token Storage**: JWT token securely stored using Flutter Secure Storage
4. **Session Restoration**: App automatically restores user session on startup
5. **Logout**: User session cleared and token removed

## State Management with Riverpod

### Key Providers

```dart
// Authentication
authNotifierProvider -> StateNotifierProvider<AuthNotifier, AuthState>

// Dashboard
dashboardControllerProvider -> StateNotifierProvider<DashboardController, DashboardState>
dashboardEventsProvider -> FutureProvider
dashboardCommunitiesProvider -> FutureProvider
dashboardMetricsProvider -> FutureProvider

// Home
featuredEventsProvider -> FutureProvider
featuredCommunitiesProvider -> FutureProvider
```

## Key Features in Detail

### 1. Authentication
- Email/password login and registration
- Google OAuth integration support
- Secure token management
- Automatic session restoration

### 2. Event Management
- Browse upcoming events
- View detailed event information
- Join events with one tap
- Track participant count
- Event categorization

### 3. Community Features
- Discover active communities
- Join communities of interest
- View community member count
- Community verification badges

### 4. Impact Dashboard
- Personal statistics (events attended, communities joined)
- Impact points tracking
- Volunteer hours logged
- Activity metrics visualization

## Error Handling

The app implements comprehensive error handling:

- **Network Errors**: Graceful fallback with user-friendly messages
- **Authentication Errors**: 401 handling with session refresh prompts
- **Validation**: Client-side form validation with clear feedback
- **API Errors**: Backend error messages displayed to users

## Development Guidelines

### Code Style
- Follow Dart naming conventions
- Use immutable data classes with Freezed
- Keep widgets focused and composable
- Use Riverpod for state management

### Adding New Features

1. Create feature folder under `lib/features/`
2. Organize into `models/`, `controllers/`, `data/`, and `ui/` subdirectories
3. Create providers in a `providers.dart` file
4. Create repository for data access
5. Create notifier for state management
6. Build UI screens using ConsumerWidget/ConsumerStatefulWidget

### Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Security Considerations

- API keys are never hardcoded
- Tokens stored in secure storage
- HTTP interceptor handles authorization headers
- Form inputs validated before submission
- Sensitive data not logged

## Performance Optimizations

- Auto-dispose providers prevent memory leaks
- Lazy loading for lists and pagination
- Efficient state updates with Riverpod
- Image caching for network images
- Conditional rebuilds with select() operator

## Troubleshooting

### Build Issues
```bash
# Clean build
flutter clean
flutter pub get
flutter pub run build_runner clean

# Regenerate files
flutter pub run build_runner build
```

### Authentication Issues
- Clear secure storage: `flutter run --no-fast-start`
- Check API_URL configuration
- Verify backend token format

### State Management Issues
- Use Riverpod DevTools for debugging
- Check provider invalidation logic
- Verify async provider error handling

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

## Roadmap

- [ ] Push notifications for events
- [ ] Social sharing features
- [ ] Leaderboard and achievements
- [ ] Advanced event filtering
- [ ] Profile customization
- [ ] Direct messaging
- [ ] Event calendar view
- [ ] Offline mode support

## Known Limitations

- Google OAuth requires additional backend setup
- Forgot password flow not yet implemented
- Offline event browsing not supported
- Limited to 20 communities per request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Email: 123cs0025@nitrkl.ac.in

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod community for state management
- All contributors and testers

---

**Made with ❤️ for positive social impact**
