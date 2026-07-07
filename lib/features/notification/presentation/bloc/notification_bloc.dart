import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../common/helper/src/data_state_model.dart';
import '../../../../common/helper/src/droppable_pro_max.dart';
import '../../../../common/helper/src/pagination_state_model.dart';
import '../../../../common/models/notification_model.dart';
import '../../../../core/use_case/use_case.dart';
import 'package:injectable/injectable.dart';
import '../../domin/use_cases/get_all_notification_use_case.dart';
import '../../domin/use_cases/post_mark_all_use_case.dart';

part 'notification_event.dart';

part 'notification_state.dart';

@lazySingleton
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetAllNotificationUseCase _getAllNotificationUseCase;
  final GetMarkUseCase _getMarkUseCase;

  NotificationBloc(this._getAllNotificationUseCase, this._getMarkUseCase)
    : super(NotificationState()) {
    on<GetAllNotificationEvent>(_getAll, transformer: droppableProMax());
    on<GetMarkNotificationEvent>(_getMark);
    on<AddOneNotificationEvent>(_addOneNotification);
    on<NewNotificationRevisedEvent>(_newNotification);
  }


  FutureOr<void> _newNotification(NewNotificationRevisedEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(newNotificationRevisedData: state.newNotificationRevisedData.setLoading()));


    emit(state.copyWith(
      newNotificationRevisedData: state.newNotificationRevisedData.setSuccess(
        data: event.id
      )
    ));



    if (emit.isDone) return;

    emit(state.copyWith( newNotificationRevisedData: state.newNotificationRevisedData.resetData()));
  }
  FutureOr<void> _addOneNotification(
      AddOneNotificationEvent event,
      Emitter<NotificationState> emit,
      ) async {
    if (state.getAllNotification.isSuccess) {

      final list = List<NotificationModel>.from(
        state.getAllNotification.list ?? [],
      );

      list.insert(0, event.notificationModel);

      emit(
        state.copyWith(
          getAllNotification: state.getAllNotification.copyWith(list: list),
          isNew: true,
        ),
      );
    }
  }

  FutureOr<void> _getMark(
    GetMarkNotificationEvent event,
    Emitter<NotificationState> emit,
  )
  async {
    final isNewLocal = state.isNew;
    emit(
      state.copyWith(
        getMarkNotification: state.getMarkNotification.setLoading(),
        isNew: false,
      ),
    );
    final result = await _getMarkUseCase(NoParams());
    result.fold(
      (l) {
        emit(
          state.copyWith(
            getMarkNotification: state.getMarkNotification.setFaild(
              errorMessage: l.message,
            ),
            isNew: isNewLocal,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            getMarkNotification: state.getMarkNotification.setSuccess(),
          ),
        );
      },
    );
  }

  FutureOr<void> _getAll(
    GetAllNotificationEvent event,
    Emitter<NotificationState> emit,
  )
  async {
    if (!state.getAllNotification.isEndPage || event.isReload) {
      emit(
        state.copyWith(
          getAllNotification: state.getAllNotification.setLoading(
            isReload: event.isReload,
          ),
        ),
      );

      final result = await _getAllNotificationUseCase(
        GetAllNotificationParams(
          page: state.getAllNotification.pageNumber,
          perPage: state.getAllNotification.perPage,
        ),
      );

      result.fold(
        (l) {
          emit(
            state.copyWith(
              getAllNotification: state.getAllNotification.setFaild(
                errorMessage: l.message,
              ),
            ),
          );
        },
        (r) {
          final list = r.data!;

          final bool isNew = list.items!.any((item) => item.readAt == null);

          emit(
            state.copyWith(
              getAllNotification: state.getAllNotification.setSuccess(
                data: r.data!.items!,
              ),
              isNew: isNew,
            ),
          );
        },
      );
    }
  }
}
