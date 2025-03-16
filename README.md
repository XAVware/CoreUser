# CoreUser

Skeleton project containing user authentication, core navigation, and user profile functionality.


## Get Started
1. Create a new project in Firebase and follow the setup instructions. 
    - Enable Firebase Authentication with Email/Password
    - Enable Firestore
2. Once you add the GoogleService plist file to the root of the project you'll be able to use the app as you'd expect.



## Features

### User Registration
- [x] Create new account with email and password
- [x] Validate email format
- [x] Enforce password length requirements (minimum 6 characters)
- [x] Handle existing email addresses
- [x] Create user document in Firestore after successful registration. Document ID is set to AuthUser ID
- [x] Send email verification after registration
        - [x] Validating email immediately after creating account displays correct 'Verified' status in profile.
- [x] Show appropriate loading states during registration
- [x] Display success/error alerts
        - Though a few more cases need to be handled

### Login
- [x] Login with email and password
- [x] Handle invalid credentials appropriately
- [x] Show loading state during authentication
- [x] Maintain user session after successful login
- [x] Handle network errors gracefully
- [x] Display appropriate error messages
- [x] Sync Firebase Auth user with Firestore user data

### Password Management
- [x] Allow users to request password reset
- [x] Send password reset email
- [ ] Handle invalid email addresses for reset
- [x] Show confirmation when reset email is sent
- [ ] Handle reset email errors appropriately
- [x] Allow login with new password
- [x] Display accurate email verification status

### Profile Management
- [x] Display user profile information
- [x] Allow editing display name
- [x] Allow editing email address
- [x] Sign user out after request is submitted
- [x] Show confirmation when email change verification email is sent
- [x] Require reauthentication for sensitive operations
- [x] Show email verification status
- [x] Update both Firebase Auth and Firestore when profile is modified
- [ ] Handle update errors appropriately

### Session Management
- [x] Handle sign out properly
- [x] Clear navigation stack on sign out
- [x] Show appropriate loading states
- [ ] Handle onboarding state
- [x] Manage alerts and loading states globally

## UI/UX Features

### Navigation
- [x] Proper navigation stack management
- [x] Back button functionality
- [x] Menu navigation
- [x] Handle deep linking appropriately


