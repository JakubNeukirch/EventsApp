import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class EventsAppFirebaseUser {
  EventsAppFirebaseUser(this.user);
  final User user;
  bool get loggedIn => user != null;
}

EventsAppFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<EventsAppFirebaseUser> eventsAppFirebaseUserStream() => FirebaseAuth
    .instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<EventsAppFirebaseUser>(
        (user) => currentUser = EventsAppFirebaseUser(user));
