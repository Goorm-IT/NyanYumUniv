import 'package:deanora/Widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print(args);
    if (args.value is PickerDateRange) {
      _range =
          DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
              ' - ' +
              DateFormat('dd/MM/yyyy')
                  .format(args.value.endDate ?? args.value.startDate)
                  .toString();
    } else if (args.value is DateTime) {
      _selectedDate = args.value.toString();
    } else if (args.value is List<DateTime>) {
      _dateCount = args.value.length.toString();
    } else {
      _rangeCount = args.value.length.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfDateRangePicker(
        monthCellStyle: DateRangePickerMonthCellStyle(
          cellDecoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.4),
              border: Border.all(color: Colors.red, width: 1),
              shape: BoxShape.circle),
        ),
        backgroundColor: Colors.blueGrey,
        todayHighlightColor: Colors.white.withOpacity(0),
        onSelectionChanged: _onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.range,
        initialSelectedRange: PickerDateRange(
            DateTime.now().subtract(const Duration(days: 4)),
            DateTime.now().add(const Duration(days: 3))),
      ),
    );
  }
}
