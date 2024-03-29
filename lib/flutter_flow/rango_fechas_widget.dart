import 'dart:developer';


import 'package:logger/logger.dart';
import 'package:login2/flutter_flow/flutter_flow_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:colombia_holidays/colombia_holidays.dart';

class RangoFechasWidget extends StatefulWidget {
  const RangoFechasWidget({Key? key}) : super(key: key);

  @override
  _RangoFechasWidgetState createState() => _RangoFechasWidgetState();
}

class _RangoFechasWidgetState extends State<RangoFechasWidget> {
  DateTime? datePicked1;
  DateTime? datePicked2;
  ColombiaHolidays holidays = ColombiaHolidays();
  List<DateTime> _listadiasFestivos = [];
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    diasFestivos();
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: FlutterFlowTheme.of(context).lineColor,
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SfDateRangePicker(
            onSelectionChanged:
                (DateRangePickerSelectionChangedArgs args) async {
              final PickerDateRange dateRanges = (args.value);

              if (_controller.selectedRange != null) {
                log('rango fecha seleccionado');
                _controller.selectedRange = PickerDateRange(
                    DateTime.now(), _controller.selectedRange!.endDate);
              }
              if (args.value is PickerDateRange && args.value != null) {
                final DateTime rangeStartDate = args.value.startDate;
                DateTime rangeEndDate = rangeStartDate;
                if (args.value.endDate != null) {
                  rangeEndDate = args.value.endDate;
                }
                final DateTimeRange range =
                    DateTimeRange(start: rangeStartDate, end: rangeEndDate);
                Logger().i('El rango de fecha es:${range.duration.inDays}');
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('fecha_inicio', rangeStartDate.toString());
                prefs.setString('fecha_fin', rangeEndDate.toString());
              }
            },
            initialDisplayDate: DateTime.now(),
            controller: _controller,
            minDate: DateTime.now(),
            initialSelectedDate: DateTime.now(),
            todayHighlightColor: FlutterFlowTheme.of(context).primaryColor,
            selectionColor: FlutterFlowTheme.of(context).primaryColor,
            rangeSelectionColor:
                FlutterFlowTheme.of(context).primaryColor.withOpacity(0.30),
            startRangeSelectionColor: FlutterFlowTheme.of(context).primaryColor,
            endRangeSelectionColor: FlutterFlowTheme.of(context).primaryColor,
            selectionTextStyle: FlutterFlowTheme.of(context).bodyText1.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                  fontSize: 20,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText1Family),
                ),
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            selectableDayPredicate: (DateTime dateTime) {
              if (dateTime.weekday == 7 ||
                  dateTime.weekday == 6 ||
                  (_listadiasFestivos.where((element) => element == dateTime))
                      .isNotEmpty) {
                return false;
              }
              return true;
            },
            enablePastDates: false,
            toggleDaySelection: false,
            showNavigationArrow: true,
            rangeTextStyle: FlutterFlowTheme.of(context).bodyText1.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                  fontSize: 16,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText1Family),
                ),
            monthCellStyle: DateRangePickerMonthCellStyle(
              trailingDatesTextStyle: FlutterFlowTheme.of(context)
                  .bodyText1
                  .override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                    fontSize: 16,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText1Family),
                  ),
              textStyle: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText1Family),
                  ),
              blackoutDatesDecoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(color: const Color(0xFFF44436), width: 1),
                  shape: BoxShape.circle),
              weekendDatesDecoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  border: Border.all(
                      color: FlutterFlowTheme.of(context).primaryText,
                      width: 1),
                  shape: BoxShape.circle),
              specialDatesDecoration: BoxDecoration(
                  color: const Color.fromARGB(255, 6, 113, 122),
                  border: Border.all(color: const Color(0xFF2B732F), width: 1),
                  shape: BoxShape.circle),
              disabledDatesTextStyle: FlutterFlowTheme.of(context)
                  .bodyText1
                  .override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText1Family),
                  ),
              blackoutDateTextStyle: TextStyle(
                  color: Colors.white, decoration: TextDecoration.lineThrough),
              specialDatesTextStyle: const TextStyle(color: Colors.white),
            ),
            monthViewSettings: DateRangePickerMonthViewSettings(
                specialDates: _listadiasFestivos,
                dayFormat: 'EEE',
                numberOfWeeksInView: 5,
                firstDayOfWeek: 7,
                enableSwipeSelection: true,
                showTrailingAndLeadingDates: true),
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,
            initialSelectedRange: PickerDateRange(
                DateTime.now(), DateTime.now()),
          ),
        ),
      ),
    );
  }

  diasFestivos() async {
    if (_listadiasFestivos.length == 0) {
      DateTime fecha_fin = DateTime.now().add(Duration(days: 90));
      final holidaysByYear2022 = await holidays.getHolidays(year: 2022);
      for (var holiday in holidaysByYear2022) {
        List<String> res = holiday.date.toString().split('/');
        _listadiasFestivos.add(
            DateTime(int.parse(res[2]), int.parse(res[1]), int.parse(res[0])));
        if (_listadiasFestivos.last > fecha_fin) {
          break;
        }
      }
      final holidaysByYear2023 = await holidays.getHolidays(year: 2023);
      for (var holiday in holidaysByYear2023) {
        List<String> res = holiday.date.toString().split('/');
        _listadiasFestivos.add(
            DateTime(int.parse(res[2]), int.parse(res[1]), int.parse(res[0])));
        if (_listadiasFestivos.last > fecha_fin) {
          break;
        }
      }
    
    }
  }
}