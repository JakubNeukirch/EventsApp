import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'schema_util.dart';
import 'serializers.dart';

part 'events_record.g.dart';

abstract class EventsRecord
    implements Built<EventsRecord, EventsRecordBuilder> {
  static Serializer<EventsRecord> get serializer => _$eventsRecordSerializer;

  @nullable
  String get name;

  @nullable
  Timestamp get date;

  @nullable
  DocumentReference get creator;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(EventsRecordBuilder builder) =>
      builder..name = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('events');

  static Stream<EventsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  EventsRecord._();
  factory EventsRecord([void Function(EventsRecordBuilder) updates]) =
      _$EventsRecord;
}

Map<String, dynamic> createEventsRecordData({
  String name,
  Timestamp date,
  DocumentReference creator,
}) =>
    serializers.serializeWith(
        EventsRecord.serializer,
        EventsRecord((e) => e
          ..name = name
          ..date = date
          ..creator = creator));

EventsRecord get dummyEventsRecord {
  final builder = EventsRecordBuilder()
    ..name = dummyString
    ..date = dummyTimestamp;
  return builder.build();
}

List<EventsRecord> createDummyEventsRecord({int count}) =>
    List.generate(count, (_) => dummyEventsRecord);
