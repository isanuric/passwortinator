# Passwortinator

A modern, cryptographically secure password generator built with Flutter, Material 3, and Riverpod.

## Features

- **Cryptographically Secure:** Uses `Random.secure()` with guaranteed character representation per enabled category and secure shuffling.
- **Entropy & Strength Estimation:** Calculates information entropy using the formula `E = L * log2(R)` to categorize password strength (Weak, Medium, Strong).
- **Customizable Parameters:** Configurable length (8 to 64 characters) and individual toggles for uppercase, lowercase, numbers, and special characters.
- **Safety Validation:** Prevents disabling all character categories to ensure valid password generation.
- **Material 3 Design:** Responsive layout supporting system-based Light and Dark modes.
- **Clipboard Integration:** Quick copy to clipboard with toast notification.

## Tech Stack & Architecture

- **Framework:** Flutter (Material 3)
- **Language:** Dart
- **State Management:** Riverpod (Feature-first architecture with strict separation of logic and UI)

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.10.0)
- Dart SDK (>= 3.0.0)

### Installation & Run

1. Clone the repository:
   ```bash
   git clone git@github.com:isanuric/passwortinator.git
   cd passwortinator
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   # Run in Chrome
   flutter run -d chrome

   # Run on connected desktop / mobile device
   flutter run
   ```

4. Run tests:
   ```bash
   flutter test
   ```
