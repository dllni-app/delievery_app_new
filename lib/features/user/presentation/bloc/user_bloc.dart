import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../common/helper/src/data_state_model.dart';
import '../../../../common/helper/src/helper_func.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/driver_profile_response.dart';
import '../../data/models/user_model.dart';
import '../../domain/use_cases/driver_get_me_use_cases.dart';
import '../../domain/use_cases/post_location_use_cases.dart';
import '../../domain/use_cases/update_availability_use_cases.dart';
import '../../domain/use_cases/user_delete_me_use_cases.dart';
import '../../domain/use_cases/user_get_me_use_cases.dart';
import '../../domain/use_cases/user_update_profile_use_cases.dart';
import '../../domain/use_cases/user_update_me_use_cases.dart';
import 'package:injectable/injectable.dart';

part 'user_event.dart';

part 'user_state.dart';

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserGetMeUseCases _getMeUseCases;
  final DriverGetMeUseCases _driverGetMeUseCases;
  final UpdateAvailabilityUseCases _updateAvailabilityUseCases;
  final PostLocationUseCases _postLocationUseCases;
  final UserDeleteMeUseCases _deleteMeUseCases;
  final UserUpdateMeUseCases _updateMeUseCases;
  final UserUpdateProfileImageUseCases _userUpdateProfileImageUseCases;

  UserBloc(
    this._deleteMeUseCases,
    this._getMeUseCases,
    this._driverGetMeUseCases,
    this._updateAvailabilityUseCases,
    this._postLocationUseCases,
    this._userUpdateProfileImageUseCases,
    this._updateMeUseCases,
  ) : super(UserState()) {
    on<UserGetMeEvent>(_getMe);
    on<DriverGetMeEvent>(_driverGetMe);
    on<UpdateAvailabilityEvent>(_updateAvailability);
    on<PostLocationEvent>(_postLocation);
    on<UserUpdateProfileImageEvent>(_updateProfileImage);
    on<UserDeleteMeEvent>(_deleteMe);
    on<UserUpdateMeEvent>(_updateMe);
  }

  FutureOr<void> _getMe(UserGetMeEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(getMeData: state.getMeData.setLoading()));

    final val = await _getMeUseCases(NoParams());

    val.fold(
      (l) {
        emit(
          state.copyWith(
            getMeData: state.getMeData.setFaild(errorMessage: l.message),
          ),
        );
      },
      (r) {
        emit(state.copyWith(getMeData: state.getMeData.setSuccess(data: r)));
      },
    );
  }

  FutureOr<void> _driverGetMe(
    DriverGetMeEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(driverGetMeData: state.driverGetMeData.setLoading()));

    final val = await _driverGetMeUseCases(NoParams());

    val.fold(
      (l) {
        emit(
          state.copyWith(
            driverGetMeData: state.driverGetMeData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            driverGetMeData: state.driverGetMeData.setSuccess(data: r),
          ),
        );
      },
    );
  }

  FutureOr<void> _updateAvailability(
    UpdateAvailabilityEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(
      state.copyWith(
        updateAvailabilityData: state.updateAvailabilityData.setLoading(),
      ),
    );

    final val = await _updateAvailabilityUseCases(event.params);

    val.fold(
      (l) {
        emit(
          state.copyWith(
            updateAvailabilityData: state.updateAvailabilityData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            updateAvailabilityData: state.updateAvailabilityData.setSuccess(
              data: r,
            ),
            driverGetMeData: state.driverGetMeData.isSuccess
                ? state.driverGetMeData.copyWith(data: r)
                : state.driverGetMeData.setSuccess(data: r),
            getMeData: state.getMeData.isSuccess
                ? state.getMeData.copyWith(data: r)
                : state.getMeData,
          ),
        );
      },
    );
  }

  FutureOr<void> _postLocation(
    PostLocationEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(postLocationData: state.postLocationData.setLoading()));

    final val = await _postLocationUseCases(event.params);

    val.fold(
      (l) {
        emit(
          state.copyWith(
            postLocationData: state.postLocationData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(postLocationData: state.postLocationData.setSuccess()),
        );
      },
    );
  }

  FutureOr<void> _deleteMe(
    UserDeleteMeEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(deleteMeData: state.deleteMeData.setLoading()));

    final val = await _deleteMeUseCases(NoParams());

    val.fold(
      (l) {
        emit(
          state.copyWith(
            deleteMeData: state.deleteMeData.setFaild(errorMessage: l.message),
          ),
        );
      },
      (r) {
        emit(state.copyWith(deleteMeData: state.deleteMeData.setSuccess()));
        HelperFunc.logout();
      },
    );
  }

  FutureOr<void> _updateMe(
    UserUpdateMeEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(updateMeData: state.updateMeData.setLoading()));

    final val = await _updateMeUseCases(event.params);

    val.fold(
      (l) {
        emit(
          state.copyWith(
            updateMeData: state.updateMeData.setFaild(errorMessage: l.message),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(updateMeData: state.updateMeData.setSuccess(data: r)),
        );
      },
    );
  }

  FutureOr<void> _updateProfileImage(
    UserUpdateProfileImageEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(
      state.copyWith(
        postProfileImageData: state.postProfileImageData.setLoading(),
      ),
    );

    final result = await _userUpdateProfileImageUseCases(event.params);

    result.fold(
      (l) => emit(
        state.copyWith(
          postProfileImageData: state.postProfileImageData.setFaild(
            errorMessage: l.message,
          ),
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            postProfileImageData: state.postProfileImageData.setSuccess(
              data: r,
            ),
          ),
        );
      },
    );
  }
}
