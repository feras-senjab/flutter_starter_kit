/// Representing the different flavors of the app.
/// Flavors are used to differentiate between various build configurations
enum Flavor {
  /// Development flavor, used for development and testing.
  dev,

  /// Production flavor, used for the released version of the app.
  prod,
}

//! Note: We use `FormzStatus` specifically for form validation states (e.g., validation, submission status).
//! For other application states (e.g., loading, success, failure) we use this global enum.
//! This distinction helps keep form-related status management separate from general application state management.
enum StateStatus {
  initial,
  loading,
  success,
  failure,
  canceled,
}

enum ImageType {
  assetImage,
  networkImage,
  // .. can add more if needed ..
}
