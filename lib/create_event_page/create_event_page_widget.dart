import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_calendar.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateEventPageWidget extends StatefulWidget {
  CreateEventPageWidget({Key key}) : super(key: key);

  @override
  _CreateEventPageWidgetState createState() => _CreateEventPageWidgetState();
}

class _CreateEventPageWidgetState extends State<CreateEventPageWidget> {
  DateTimeRange calendarSelectedDay;
  TextEditingController textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.primaryColor,
        automaticallyImplyLeading: true,
        title: Text(
          'Nowe wydarzenie',
          style: FlutterFlowTheme.title1.override(
            fontFamily: 'Poppins',
            color: FlutterFlowTheme.tertiaryColor,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: TextFormField(
                controller: textController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Nazwa',
                  labelStyle: FlutterFlowTheme.bodyText1.override(
                    fontFamily: 'Poppins',
                  ),
                  hintText: 'np. Konferencja NoCode',
                  hintStyle: FlutterFlowTheme.bodyText1.override(
                    fontFamily: 'Poppins',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                ),
                style: FlutterFlowTheme.bodyText1.override(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 0, 4),
              child: Text(
                'Data wydarzenia',
                style: FlutterFlowTheme.subtitle2.override(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            FlutterFlowCalendar(
              color: FlutterFlowTheme.primaryColor,
              weekFormat: false,
              weekStartsMonday: false,
              onChange: (DateTimeRange newSelectedDate) {
                setState(() => calendarSelectedDay = newSelectedDate);
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FFButtonWidget(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    text: 'Anuluj',
                    icon: Icon(
                      Icons.close,
                      size: 15,
                    ),
                    options: FFButtonOptions(
                      width: 130,
                      height: 40,
                      color: FlutterFlowTheme.tertiaryColor,
                      textStyle: FlutterFlowTheme.subtitle2.override(
                        fontFamily: 'Poppins',
                        color: Color(0xFF717171),
                      ),
                      borderSide: BorderSide(
                        color: Color(0xFF717171),
                        width: 1,
                      ),
                      borderRadius: 12,
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      final name = textController.text;
                      final date = calendarSelectedDay.start;
                      final creator = currentUserReference;

                      final eventsRecordData = createEventsRecordData(
                        name: name,
                        date: Timestamp.fromDate(date),
                        creator: creator,
                      );

                      await EventsRecord.collection.doc().set(eventsRecordData);
                      Navigator.pop(context);
                    },
                    text: 'Dodaj',
                    icon: Icon(
                      Icons.add,
                      size: 15,
                    ),
                    options: FFButtonOptions(
                      width: 130,
                      height: 40,
                      color: FlutterFlowTheme.primaryColor,
                      textStyle: FlutterFlowTheme.subtitle2.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: 12,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
