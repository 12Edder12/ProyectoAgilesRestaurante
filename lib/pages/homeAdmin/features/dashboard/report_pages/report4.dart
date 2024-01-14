import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Report4 extends StatefulWidget {
  const Report4({super.key});

  @override
  _Report4State createState() => _Report4State();
}

class _Report4State extends State<Report4> {
  String _range = '';
  DateTime _startRange = DateTime.now().subtract(const Duration(days: 4));
  DateTime _endRange = DateTime.now().add(const Duration(days: 3));
  List<PieChartSectionData> _pieChartSections = [];
  int countMetPag0 = 0;
  int countMetPag1 = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    final value = args.value as PickerDateRange;
    setState(() {
      _startRange = value.startDate!;
      _endRange = value.endDate ?? value.startDate!;
      _range = '${DateFormat('dd/MM/yyyy').format(_startRange)} - ${DateFormat('dd/MM/yyyy').format(_endRange)}';
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('facturas')
          .where('fec_emi_fac', isGreaterThan: Timestamp.fromDate(_startRange))
          .where('fec_emi_fac', isLessThan: Timestamp.fromDate(_endRange.add(const Duration(days: 1))))
          .get();

      countMetPag0 = 0;
      countMetPag1 = 0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        final int? metPag = data['met_pag'] as int?;

        if (metPag != null) {
          if (metPag == 0) {
            countMetPag0++;
          } else if (metPag == 1) {
            countMetPag1++;
          }
        }
      }

      _generatePieChart();
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void _generatePieChart() {
    final List<PieChartSectionData> sections = [
      PieChartSectionData(
        color: Colors.green,
         value: countMetPag0 > 0 ? countMetPag0.toDouble() : 0.1,
        title: '$countMetPag0\n(Directo)',
        radius: 150,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.amber,
        value: countMetPag1 > 0 ? countMetPag1.toDouble() : 0.1,
        title: '$countMetPag1\n(STRIPE)',
        radius: 150,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];

    setState(() {
      _pieChartSections = sections;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Método de Pago'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Rango: $_range'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.3,
              child: SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(_startRange, _endRange),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.all(8.0),
              child: PieChart(
                PieChartData(
                  sections: _pieChartSections,
                  centerSpaceRadius: 0,
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  sectionsSpace: 0,
                  centerSpaceColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Report4()));
}
