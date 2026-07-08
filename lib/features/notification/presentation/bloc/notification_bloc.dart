import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../common/helper/src/data_state_model.dart';

import '../../../../common/helper/src/droppable_pro_max.dart';

import '../../../../common/helper/src/pagination_state_model.dart';

import '../../../../common/models/notification_model.dart';

import '../../domain/use_cases/get_all_notification_use_case.dart';

import '../../domain/use_cases/mark_notification_read_use_case.dart';

import 'package:injectable/injectable.dart';

part 'notification_event.dart';

part 'notification_state.dart';

@lazySingleton
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetAllNotificationUseCase _getAllNotificationUseCase;

  final MarkNotificationReadUseCase _markNotificationReadUseCase;

  NotificationBloc(
    this._getAllNotificationUseCase,

    this._markNotificationReadUseCase,
  ) : super(NotificationState()) {
    on<GetAllNotificationEvent>(_getAll, transformer: droppableProMax());

    on<MarkNotificationReadEvent>(_markNotificationRead);

    on<AddOneNotificationEvent>(_addOneNotification);

    on<NewNotificationRevisedEvent>(_newNotification);
  }

  FutureOr<void> _newNotification(
    NewNotificationRevisedEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(
        newNotificationRevisedData: state.newNotificationRevisedData
            .setLoading(),
      ),
    );

    emit(
      state.copyWith(
        newNotificationRevisedData: state.newNotificationRevisedData.setSuccess(
          data: event.id,
        ),
      ),
    );

    if (emit.isDone) return;

    emit(
      state.copyWith(
        newNotificationRevisedData: state.newNotificationRevisedData
            .resetData(),
      ),
    );
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

  FutureOr<void> _markNotificationRead(
    MarkNotificationReadEvent event,

    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(
        markNotificationReadData: state.markNotificationReadData.setLoading(),
      ),
    );

    final result = await _markNotificationReadUseCase(event.params);

    result.fold(
      (l) {
        emit(
          state.copyWith(
            markNotificationReadData: state.markNotificationReadData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },

      (_) {
        final list = state.getAllNotification.list;

        final updatedList = list.map((notification) {
          if (notification.id == event.params.id) {
            return notification.copyWith(readAt: DateTime.now());
          }

          return notification;
        }).toList();

        final isNew = updatedList.any((item) => item.readAt == null);

        emit(
          state.copyWith(
            markNotificationReadData: state.markNotificationReadData
                .setSuccess(),

            getAllNotification: state.getAllNotification.copyWith(
              list: updatedList,
            ),

            isNew: isNew,
          ),
        );
            },
    );
  }

  FutureOr<void> _getAll(
    GetAllNotificationEvent event,

    Emitter<NotificationState> emit,
  ) async {
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

          final bool isNew = list.any((item) => item.readAt == null);

          emit(
            state.copyWith(
              getAllNotification: state.getAllNotification.setSuccess(
                data: r.data!,
              ),

              isNew: isNew,
            ),
          );
        },
      );
    }
  }
}
