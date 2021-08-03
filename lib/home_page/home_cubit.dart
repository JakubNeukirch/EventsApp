import 'package:events_app/backend/backend.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EventCubit extends Cubit<EventState> {
  final DateFormat _format = DateFormat("dd.MM");
  EventCubit(EventsRecord event) : super(EventState("")) {
    formatDate(event.date.toDate());
  }

  void formatDate(DateTime date) {
    emit(EventState(_format.format(date)));
  }

  void addToFavorite() {
    //todo add saving as favorite
  }
}

class EventState {
  final String date;
  EventState(this.date);
}