import 'package:Pizzeria_Guerrin/models/pedido.dart';
import 'package:flutter/material.dart';

num mesaOrden = 0;
num orderCount = 0;
List<Pedido> pedidos = [];
String idUser = "";
BuildContext? globalContext;
Map<String, dynamic> datosUsuario = {};