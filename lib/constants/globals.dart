import 'package:Pizzeria_Guerrin/models/pedido.dart';
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

Map<String, dynamic> datosFactura = {
  'num_mes': 0,
  'met_pag': 0,
};