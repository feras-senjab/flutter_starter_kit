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
