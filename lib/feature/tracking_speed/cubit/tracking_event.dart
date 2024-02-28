sealed class LocationServiceEvent {}

class DisableLocationServiceEvent extends LocationServiceEvent {}

class DeniedLocationPermissionEvent extends LocationServiceEvent {}

class DeniedForeverLocationPermissionEvent extends LocationServiceEvent {}
