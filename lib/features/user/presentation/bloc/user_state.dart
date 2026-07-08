part of 'user_bloc.dart';

class UserState {
  final DataStateModel<DriverProfileResponse?> getMeData;
  final DataStateModel<DriverProfileResponse?> driverGetMeData;
  final DataStateModel<DriverProfileResponse?> updateAvailabilityData;
  final DataStateModel<void> postLocationData;
  final DataStateModel<UserResponse?> postProfileImageData;
  final DataStateModel<UserResponse?> updateMeData;
  final DataStateModel<void> deleteMeData;
  final String? photo;

  UserState({
    this.getMeData = const DataStateModel.setDefultValue(defultValue: null),
    this.driverGetMeData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.updateAvailabilityData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.postLocationData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.postProfileImageData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.updateMeData = const DataStateModel.setDefultValue(defultValue: null),
    this.deleteMeData = const DataStateModel.setDefultValue(defultValue: null),
    this.photo,
  });

  UserState copyWith({
    DataStateModel<DriverProfileResponse?>? getMeData,
    DataStateModel<DriverProfileResponse?>? driverGetMeData,
    DataStateModel<DriverProfileResponse?>? updateAvailabilityData,
    DataStateModel<void>? postLocationData,
    DataStateModel<UserResponse?>? postProfileImageData,
    DataStateModel<UserResponse?>? updateMeData,
    DataStateModel<void>? deleteMeData,
    String? photo,
  }) {
    return UserState(
      getMeData: getMeData ?? this.getMeData,
      driverGetMeData: driverGetMeData ?? this.driverGetMeData,
      updateAvailabilityData:
          updateAvailabilityData ?? this.updateAvailabilityData,
      postLocationData: postLocationData ?? this.postLocationData,
      postProfileImageData: postProfileImageData ?? this.postProfileImageData,
      updateMeData: updateMeData ?? this.updateMeData,
      deleteMeData: deleteMeData ?? this.deleteMeData,
      photo: photo ?? this.photo,
    );
  }
}
