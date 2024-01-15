import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Report3 extends StatefulWidget {
  const Report3({super.key});

  @override
  _Report3State createState() => _Report3State();
}

class _Report3State extends State<Report3> {
  String _range = '';
  DateTime _startRange = DateTime.now().subtract(const Duration(days: 4));
  DateTime _endRange = DateTime.now().add(const Duration(days: 3));
  List<LineChartBarData> _lineBarsData = [];
  Map<DateTime, double> dailyTotals = {};


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

  void _fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('facturas')
          .where('fec_emi_fac', isGreaterThan: Timestamp.fromDate(_startRange))
          .where('fec_emi_fac', isLessThan: Timestamp.fromDate(_endRange.add(const Duration(days: 1))))
          .get();

      dailyTotals = {}; // Limpiar datos anteriores al cambiar el rango de fechas

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final Timestamp timestamp = data['fec_emi_fac'];
        final DateTime date = timestamp.toDate();
        final double total = data['total'];

        dailyTotals[date] = (dailyTotals[date] ?? 0) + total;
      }

      _generateLineBars();
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void _generateLineBars() {
  List<LineChartBarData> lineBarsData = [];
  List<FlSpot> spots = [];

  // Consolidar los totales por día y hora
  Map<DateTime, double> consolidatedTotals = {};

  dailyTotals.forEach((date, total) {
    // Truncate la fecha a la hora para agrupar por día y hora
    DateTime truncatedDate = DateTime(date.year, date.month, date.day);

    consolidatedTotals[truncatedDate] = (consolidatedTotals[truncatedDate] ?? 0) + total;
  });

  // Convertir los datos de totales diarios a puntos para el gráfico
  consolidatedTotals.forEach((date, total) {
    spots.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), total));
  });

  // Crear la línea de datos del gráfico
  LineChartBarData lineChartBarData = LineChartBarData(
    spots: spots,
    isCurved: false,
    color: Colors.green,
    barWidth: 4,
    belowBarData: BarAreaData(show: false),
    dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
      return FlDotCirclePainter(
        radius: 8,
        color: Colors.green,
        strokeWidth: 2,
        strokeColor: Colors.white,
      );
    }),
    isStrokeCapRound: true,
    // Puedes ajustar otros atributos según tus preferencias
  );

  lineBarsData.add(lineChartBarData);

  setState(() {
    _lineBarsData = lineBarsData;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresos'),
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
              height: MediaQuery.of(context).size.height * 0.3,
              padding: const EdgeInsets.only(left: 45, right: 16, top: 8, bottom: 8),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(
  leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                      topTitles:  AxisTitles(
      sideTitles: SideTitles(showTitles: false), // Agregar esto
    ), bottomTitles:  AxisTitles(
      sideTitles: SideTitles(showTitles: false), // Agregar esto
    ),
                  ),

                  borderData: FlBorderData(show: true),
                  lineBarsData: _lineBarsData,
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
  runApp(const MaterialApp(home: Report3()));
}
