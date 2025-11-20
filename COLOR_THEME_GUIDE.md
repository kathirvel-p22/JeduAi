# JeduAI Color Theme Guide

## Section Color Schemes

Each section of the app has its own vibrant color theme:

### 1. **Home/Dashboard** - Blue Theme
- Primary: `#2196F3` (Blue)
- Secondary: `#64B5F6` (Light Blue)
- Gradient: Blue → Light Blue
- Use: Welcome banner, main navigation

### 2. **AI Tutor** - Green Theme  
- Primary: `#4CAF50` (Green)
- Secondary: `#81C784` (Light Green)
- Gradient: Green → Light Green
- Use: Chat interface, AI responses

### 3. **Translation** - Purple Theme
- Primary: `#9C27B0` (Purple)
- Secondary: `#CE93D8` (Light Purple)
- Gradient: Purple → Light Purple
- Use: Translation interface, language selection

### 4. **Assessment** - Pink Theme
- Primary: `#E91E63` (Pink)
- Secondary: `#F48FB1` (Light Pink)
- Gradient: Pink → Light Pink
- Use: Quiz cards, test interfaces

### 5. **Learning Hub** - Orange Theme
- Primary: `#FF9800` (Orange)
- Secondary: `#FFB74D` (Light Orange)
- Gradient: Orange → Light Orange
- Use: Course cards, lesson materials

### 6. **Online Classes** - Cyan Theme
- Primary: `#00BCD4` (Cyan)
- Secondary: `#4DD0E1` (Light Cyan)
- Gradient: Cyan → Light Cyan
- Use: Class schedules, video calls

### 7. **Profile** - Teal Theme
- Primary: `#009688` (Teal)
- Secondary: `#4DB6AC` (Light Teal)
- Gradient: Teal → Light Teal
- Use: User profile, settings

## Design Patterns

### Gradient Cards
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryColor, secondaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.3),
        spreadRadius: 1,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
)
```

### Icon Containers
- Soft colored backgrounds with matching icons
- Rounded corners (12-16px)
- Subtle shadows for depth

### App Bars
- Gradient backgrounds matching section theme
- White text and icons
- No elevation for modern flat design

### Buttons
- Gradient backgrounds
- Rounded corners
- White text
- Elevation on hover/press

### Cards
- White background with subtle shadow
- OR gradient background for featured items
- 16px border radius
- Consistent padding

## Color Usage Guidelines

1. **Primary Actions**: Use section's primary color
2. **Secondary Actions**: Use section's secondary color
3. **Success States**: Green (#4CAF50)
4. **Warning States**: Orange (#FF9800)
5. **Error States**: Red (#F44336)
6. **Info States**: Blue (#2196F3)
7. **Neutral**: Grey (#9E9E9E)

## Accessibility

- All color combinations meet WCAG AA standards
- Text on colored backgrounds uses white for contrast
- Icons are clearly visible
- Focus states are clearly indicated

## Implementation

Use the `AppTheme` class in `lib/theme/app_theme.dart` for consistent theming across the app.

```dart
import 'package:jeduai_app1/theme/app_theme.dart';

// Use predefined gradients
Container(
  decoration: AppTheme.cardDecoration(AppTheme.greenGradient),
)

// Get theme for specific section
Theme(
  data: AppTheme.getThemeForSection('ai_tutor'),
  child: YourWidget(),
)
```
