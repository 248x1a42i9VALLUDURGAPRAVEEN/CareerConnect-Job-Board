# CareerConnect – Flutter Job Board

A beginner-friendly Flutter Android project for browsing remote job listings,
viewing job details, filtering jobs, and validating a demo job application form.

## Features
- Job listings loaded from the Remotive public API.
- Search by job title, company, or category.
- Filter by location and job type.
- Job detail screen.
- Validated application form.
- Provider (`ChangeNotifier`) shared state.
- Loading, error/retry, empty, and data states.
- Widget test.

## Requirements
- Flutter 3.35 or newer (stable channel)
- Dart with null safety
- Android Studio, Flutter and Dart plugins
- JDK 17
- Android emulator or physical Android phone

## Run the project
1. Install Flutter and Android Studio.
2. Open this folder in Android Studio.
3. Run `flutter doctor` and resolve Android toolchain issues.
4. Run `flutter pub get`.
5. Run `flutter run`.

## API
This project requests job listings from:
https://remotive.com/api/remote-jobs?limit=50

Review the API's current terms, usage limits, and attribution requirements before
public release. The API contains remote-job listings; it is not a comprehensive
database of local vacancies.

## Application form limitation
The application form validates user input and displays a demo confirmation.
It does not transmit personal information to employers or store applications.
Applicants should follow the original job listing URL to apply with the employer.

## Tests
Run:
`flutter test`

## Release APK
Run:
`flutter build apk --release`

APK output:
`build/app/outputs/flutter-apk/app-release.apk`

Install and test the APK on a physical Android device.

## Suggested team contributions
Update this section with your actual team member names and work:
- Member 1: Home screen and job model
- Member 2: API service and Provider
- Member 3: Details, filters, application form and testing

All team members should make regular commits to the shared GitHub repository.

## Before submission
- Add at least three genuine screenshots.
- Update member names and actual contributions.
- Maintain a defect log with reproduction steps and fixed status.
- Verify the API works at demonstration time.
- Test the release APK on a physical phone.
