import 'package:Pizzeria_Guerrin/models/pedido.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

num mesaOrden = 0;
num orderCount = 0;
List<Pedido> pedidos = [];
String idUser = "";
BuildContext? globalContext;
BuildContext? tomarMesa;
Map<String, dynamic> datosUsuario = {};
Map<String, dynamic>? clienteSeleccionado;
String numeroFactura= "";
ValueNotifier<String> idStripe = ValueNotifier<String>('');
bool estado_stripe = false;
Map<String, dynamic> datosFactura = {
  'num_mes': 0,
  'met_pag': 0,
};
double ivaGlobal = 0.0; 

Future<void> fetchIvaFromFirebase() async {
  try {
    var firestore = FirebaseFirestore.instance;
    var docSnapshot = await firestore.collection('iva').get();
    var doc = docSnapshot.docs.first;
    var valorIva = doc.data()?['valor_iva'];
    ivaGlobal = (valorIva is int) ? valorIva.toDouble() : (valorIva ?? 0.0);
  
  } catch (e) {
   // print('Error al obtener el IVA de Firebase: $e');
  }
}