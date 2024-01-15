import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Report2 extends StatefulWidget {
  const Report2({super.key});

  @override
  _Report2State createState() => _Report2State();
}

class _Report2State extends State<Report2> {
  String _range = '';
  DateTime _startRange = DateTime.now().subtract(const Duration(days: 4));
  DateTime _endRange = DateTime.now().add(const Duration(days: 3));
  List<BarChartGroupData> _barGroups = [];
  Map<String, String> productNames = {};

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

  Future<String> _getProductName(String productKey) async {
    DocumentSnapshot productDoc = await FirebaseFirestore.instance.collection('productos').doc(productKey).get();
    return (productDoc.data() as Map<String, dynamic>?)?['nombre'] ?? 'Producto desconocido';
  }

  void _fetchData() async {
    try {

final pizzaProducts = await FirebaseFirestore.instance
        .collection('productos')
        .where('tipo', isEqualTo: 'bebida')
        .get();

    // Crear un conjunto de IDs de producto para las pizzas.
    final pizzaProductIds = Set.from(
      pizzaProducts.docs.map((doc) => doc.id),
    );

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('pedidos')
          .where('pagado', isEqualTo: false)
          .where('fecha', isGreaterThan: Timestamp.fromDate(_startRange))
          .where('fecha', isLessThan: Timestamp.fromDate(_endRange.add(const Duration(days: 1))))
          .get();

      final Map<String, int> productCounts = {};
    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final Map<String, dynamic> detallePedido = data['detalle_pedido'];
      for (var productKey in detallePedido.keys) {
        if (pizzaProductIds.contains(productKey)) {
          // Este producto es una pizza, contabilizarlo.
          final cantidad = detallePedido[productKey]['cantidad'] as int;
          productCounts[productKey] = (productCounts[productKey] ?? 0) + cantidad;
        }
      }
    }

      // Fetch product names
      for (var productKey in productCounts.keys) {
        productNames[productKey] = await _getProductName(productKey);
      }

      final List<BarChartGroupData> barGroups = [];
      productCounts.forEach((productKey, count) {
        final productName = productNames[productKey] ?? 'Unknown';
        final barRods = BarChartRodData(
          toY: count.toDouble(),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(2),
        );
        barGroups.add(BarChartGroupData(
          x: productKey.hashCode, // Unique identifier for the group
          barRods: [barRods],
          showingTooltipIndicators: [0],
        ));
      });

      setState(() {
        _barGroups = barGroups;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bebidas Más Pedidas'),
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
              child: BarChart(
                BarChartData(
                  barGroups: _barGroups,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                         reservedSize: 40, 
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final String productName = productNames.entries
                              .firstWhere(
                                (element) => element.key.hashCode == value.toInt(),
                                orElse: () => const MapEntry('Unknown', 'Unknown'),
                              )
                              .value;
                          return Text(
          productName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        );
      },
    ),
  ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                      topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false), // Agregar esto
    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final String productName = productNames.entries
                            .firstWhere(
                              (element) => element.key.hashCode == group.x.toInt(),
                              orElse: () => const MapEntry('Unknown', 'Unknown'),
                            )
                            .value;
                        return BarTooltipItem(
                          productName + '\n' + (rod.toY - 1).toString(),
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
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
  runApp(const MaterialApp(home: Report2()));
}
