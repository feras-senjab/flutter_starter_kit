/// Deployment Enviroment
enum DeploymentEnv {
  testing,
  production,
}

/// Deployment Enviroment Path Extenstion..
/// ! This is very sensitive.. paths here determine paths in firestore..
extension DeploymentEnvPath on DeploymentEnv {
  String get path {
    switch (this) {
      case DeploymentEnv.testing:
        return 'testing/environment/';
      case DeploymentEnv.production:
        return 'production/environment/';
    }
  }
}

class Config {
  final DeploymentEnv deploymentEnv;

  Config({required this.deploymentEnv});

  /// Users collection.
  String get usersCollection => '${deploymentEnv.path}users';
}
