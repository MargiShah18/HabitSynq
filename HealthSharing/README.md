# HabitSynq - Personal Goals, Social Momentum

A modern iOS app built with SwiftUI that helps users build and track healthy habits while connecting with friends for social motivation and accountability.

![HabitSynq Logo](HealthSharing/Assets.xcassets/logo.imageset/ChatGPT_Image_Jun_27__2025__05_42_25_PM-removebg-preview%20(1).png)

## 🚀 Features

### Core Functionality
- **Habit Tracking**: Create and manage personal habits with customizable frequency
- **Visual Progress**: Weekly calendar view with color-coded completion status
- **Social Features**: Connect with friends to share progress and stay motivated
- **QR Code Integration**: Easy friend addition through QR code scanning
- **Real-time Updates**: Firebase-powered data synchronization

### Key Features

#### 📱 Habit Management
- Create habits with custom titles and descriptions
- Set frequency: Daily, Specific Days, Days per Week, or Days per Month
- Visual weekly calendar with tap-to-complete functionality
- Success/Failure tracking with color-coded indicators

#### 👥 Social Features
- Add friends via QR code scanning
- Share your QR code for easy friend connections
- Invite friends through shareable links
- View friends' activity and progress

#### 🎨 Modern UI/UX
- Clean, intuitive interface with smooth animations
- Bouncy button interactions for enhanced user experience
- Material design-inspired overlays and sheets
- Responsive layout optimized for iOS devices

## 🛠️ Technology Stack

- **Frontend**: SwiftUI
- **Backend**: Firebase (Authentication, Firestore)
- **QR Code**: Core Image Framework
- **Architecture**: MVVM with ObservableObject pattern


### Main Screens
- **Welcome Screen**: Landing page with login/signup options
- **Home Tab**: Habit dashboard with weekly progress view
- **Friends Tab**: Social connections and friend management
- **Settings Tab**: User preferences and account management

### Key Interactions
- **Habit Creation**: Multi-step form with frequency customization
- **Progress Tracking**: Tap circles to mark daily completion
- **Friend Addition**: QR scanner and code sharing
- **Real-time Updates**: Instant synchronization across devices

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MargiShah18/HabitSynq.git
   cd HealthSharing
   ```

2. **Setup Firebase**
   - Create a new Firebase project
   - Enable Authentication and Firestore
   - Download `GoogleService-Info.plist` and add it to the project
   - Configure Firestore security rules

3. **Open in Xcode**
   ```bash
   open HealthSharing.xcodeproj
   ```

4. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Firebase Configuration

1. **Authentication Setup**
   - Enable Email/Password authentication in Firebase Console
   - Configure sign-in methods as needed

2. **Firestore Database**
   - Create a Firestore database
   - Set up collections: `habits`, `users`, `friendships`
   - Configure security rules for data access

3. **Security Rules Example**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /habits/{habitId} {
         allow read, write: if request.auth != null && 
           request.auth.uid == resource.data.userId;
       }
     }
   }
   ```

## 📁 Project Structure

```
HealthSharing/
├── HealthSharing/
│   ├── Views/
│   │   ├── ContentView.swift          # Main app entry point
│   │   ├── LoggedInHomeView.swift     # Home dashboard
│   │   ├── FriendsView.swift          # Social features
│   │   ├── SettingsView.swift         # User settings
│   │   └── AddHabitView.swift         # Habit creation
│   ├── Components/
│   │   ├── HabitCardView.swift        # Habit display card
│   │   ├── BouncyButton.swift         # Custom button component
│   │   ├── QRCodeView.swift           # QR code generation
│   │   └── OverlayMenu.swift          # Context menus
│   ├── ViewModels/
│   │   └── HabitsViewModel.swift      # Habit data management
│   ├── Models/
│   │   └── Item.swift                 # Data models
│   ├── Utilities/
│   │   └── Date+Helpers.swift         # Date utilities
│   └── Assets/
│       └── Assets.xcassets/           # App icons and images
├── HealthSharingTests/                # Unit tests
└── HealthSharingUITests/              # UI tests
```

## 🔧 Key Components

### Data Models
- **Habit**: Core habit structure with title, description, and frequency
- **CompletionStatus**: Enum for tracking success/failure/none states
- **User**: Firebase user integration

### ViewModels
- **HabitsViewModel**: Manages habit data, CRUD operations, and real-time updates
- **Firebase Integration**: Handles authentication and data synchronization

### Custom Components
- **BouncyButton**: Animated button with spring effects
- **HabitDayCircle**: Interactive day completion indicators
- **QRCodeView**: QR code generation and display
- **OverlayMenu**: Context-sensitive action menus

## 🎯 Features in Detail

### Habit Tracking System
- **Flexible Frequency**: Support for daily, weekly, and monthly habits
- **Visual Feedback**: Color-coded completion status (green=success, red=failure, blue=pending)
- **Tap Interactions**: Quick completion marking with overlay menus
- **Progress Persistence**: Real-time sync with Firebase

### Social Features
- **QR Code Integration**: Scan friends' codes or share your own
- **Friend Management**: Add, view, and manage social connections
- **Activity Sharing**: Share progress with connected friends
- **Invite System**: Generate and share invitation links

### User Experience
- **Smooth Animations**: Spring-based interactions and transitions
- **Material Design**: Modern UI with cards, overlays, and sheets
- **Responsive Layout**: Optimized for all iOS device sizes
- **Accessibility**: VoiceOver support and semantic markup
