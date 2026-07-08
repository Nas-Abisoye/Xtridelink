part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final ValueGetter<User?> currentUser;
  final ProcessState<bool> fetchUserResponse;
  final ProcessState<List<LocationPrediction>> addressPredictions;
  const ProfileState._({
    required this.currentUser,
    required this.fetchUserResponse,
    required this.addressPredictions,
  });

  ProfileState.initial()
      : this._(
          currentUser: () => null,
          fetchUserResponse: ProcessState.init(null),
          addressPredictions: ProcessState.init([]),
        );

  ProfileState copyWith({
    ValueGetter<User?>? currentUser,
    ProcessState<bool>? fetchUserResponse,
    ProcessState<List<LocationPrediction>>? addressPredictions,
  }) {
    return ProfileState._(
      currentUser: currentUser ?? this.currentUser,
      fetchUserResponse: fetchUserResponse ?? this.fetchUserResponse,
      addressPredictions: addressPredictions ?? this.addressPredictions,
    );
  }

  @override
  List<Object> get props => [
        currentUser,
        fetchUserResponse,
        addressPredictions,
      ];
}
